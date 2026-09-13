import 'server-only';

import { randomUUID } from 'node:crypto';

import { AppError } from '@/lib/errors/app-error';
import type { WorkerSession } from '@/lib/auth/worker-session';
import {
  objectMetadata,
  signedDownloadUrl,
  signedUploadUrl,
  storageBucket,
} from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';
import { MediaPurpose, MediaType } from '@/types/domain';

/**
 * Authorizing an upload from the Worker app.
 *
 * The Firebase Storage rules for this project deny every client read and write,
 * deliberately: a Storage rule cannot know who is a party to a booking, or which
 * administrator holds workers.documents.read. So the client never touches
 * Storage directly, and this module is the only thing that lets bytes in.
 *
 * The rule that makes it safe is that the storage path is BUILT HERE, from the
 * purpose rule and the owning resource id, and never accepted from the request.
 * A caller can ask to upload a KYC document; it cannot say where the file goes.
 * `enforce_media_asset_integrity()` in migration 0008 then rebuilds the same
 * prefix and rejects the row if it does not match, so the rule is enforced
 * twice, in two different systems.
 *
 *   authorize  -> validate type and size against media_purpose_rules
 *              -> check the caller owns the resource it is being attached to
 *              -> build the path, insert media_assets PENDING
 *              -> return a short-lived signed PUT URL
 *
 *   complete   -> confirm the object exists and its size matches
 *              -> mark COMPLETED
 *
 * Until COMPLETED, the asset counts as evidence nowhere.
 */

/** Long enough for a video on a poor connection, short enough to be useless if leaked. */
const UPLOAD_URL_TTL_SECONDS = 15 * 60;

const DOWNLOAD_TTL_SECONDS = {
  PUBLIC: 60 * 60,
  INTERNAL: 15 * 60,
  SENSITIVE: 5 * 60,
} as const;

/**
 * Purposes a worker may create. Anything else is refused outright.
 *
 * Deliberately excludes CUSTOMER_PROFILE_PHOTO, WORKER_BACKGROUND_CHECK and
 * SERVICE_CATALOGUE_IMAGE: none of those are a worker's to upload, and listing
 * them here is what would let one through.
 */
const WORKER_PURPOSES: ReadonlySet<MediaPurpose> = new Set<MediaPurpose>([
  MediaPurpose.WORKER_PROFILE_PHOTO,
  MediaPurpose.WORKER_KYC_DOCUMENT,
  MediaPurpose.WORKER_QUALIFICATION,
  MediaPurpose.WORKER_RPL_CREDENTIAL,
  MediaPurpose.WORKER_INSURANCE_DOCUMENT,
  MediaPurpose.BOOKING_BEFORE_WORK,
  MediaPurpose.BOOKING_DURING_WORK,
  MediaPurpose.BOOKING_AFTER_WORK,
  MediaPurpose.BOOKING_ARRIVAL_PROOF,
  MediaPurpose.BOOKING_MATERIAL_PHOTO,
  MediaPurpose.BOOKING_RECEIPT,
  MediaPurpose.CLAIM_EVIDENCE,
  MediaPurpose.SUPPORT_ATTACHMENT,
]);

/** Narrows an unvalidated string from the request body to a known purpose. */
export function isWorkerPurpose(value: string): value is MediaPurpose {
  return WORKER_PURPOSES.has(value as MediaPurpose);
}

export interface UploadRequest {
  purpose: string;
  fileName: string;
  mimeType: string;
  sizeBytes: number;
  bookingId?: string;
  materialId?: string;
  claimId?: string;
  ticketId?: string;
  capturedAt?: string;
}

export interface UploadAuthorization {
  mediaAssetId: string;
  uploadUrl: string;
  expiresAt: string;
}

export async function authorizeWorkerUpload(
  session: WorkerSession,
  input: UploadRequest,
): Promise<UploadAuthorization> {
  if (!isWorkerPurpose(input.purpose)) {
    throw AppError.forbidden('That kind of file cannot be uploaded here.');
  }

  const purpose: MediaPurpose = input.purpose;

  // 1. The purpose rule is the source of truth for where the file lives, what
  //    types are allowed and how large it may be. It is read from the database
  //    rather than duplicated here, so adding a purpose cannot ship without one.
  const { data: rule, error: ruleError } = await session.db
    .from('media_purpose_rules')
    .select('purpose, path_root, path_folder, owner_column, allowed_mime_types, max_size_bytes')
    .eq('purpose', purpose)
    .maybeSingle();

  if (ruleError || !rule) {
    logger.error('Media purpose rule missing', {
      purpose,
      error: ruleError?.message,
    });
    throw AppError.internal('That file could not be uploaded.');
  }

  const mimeType = input.mimeType.toLowerCase();

  if (!rule.allowed_mime_types.includes(mimeType)) {
    const kinds = [...new Set(rule.allowed_mime_types.map((m) => m.split('/')[1]?.toUpperCase()))];
    throw AppError.validation(
      `That file type is not accepted here. Use ${kinds.join(', ')}.`,
    );
  }

  if (input.sizeBytes <= 0) {
    throw AppError.validation('That file is empty.');
  }

  if (input.sizeBytes > rule.max_size_bytes) {
    const limitMb = Math.round(rule.max_size_bytes / 1048576);
    throw AppError.validation(`That file is too large. The limit is ${limitMb}MB.`);
  }

  // 2. Resolve the owning resource and prove the caller owns it. The reads go
  //    through the RLS-scoped client, so a booking belonging to another worker
  //    simply is not visible and the check fails as not-found.
  const owner = await resolveOwner(session, rule.owner_column, input);

  // 3. Build the path. Nothing from the request reaches it except the extension,
  //    and the file name is generated rather than taken, so a name like
  //    "../../other-worker/kyc/id.jpg" has nowhere to go.
  const mediaAssetId = randomUUID();
  const storagePath = buildStoragePath({
    pathRoot: rule.path_root,
    ownerId: owner.id,
    pathFolder: rule.path_folder,
    mediaAssetId,
    mimeType,
  });

  // 4. Record the intent. PENDING means "authorized but not yet arrived", and
  //    nothing in the platform treats a PENDING asset as evidence.
  const { error: insertError } = await session.db.from('media_assets').insert({
    id: mediaAssetId,
    firebase_storage_path: storagePath,
    storage_bucket: storageBucket().name,
    media_type: mediaTypeFor(mimeType),
    purpose,
    upload_status: 'PENDING',
    uploaded_by_type: 'WORKER',
    uploaded_by_firebase_uid: session.user.uid,
    [rule.owner_column]: owner.id,
    ...(input.bookingId && rule.owner_column !== 'booking_id'
      ? { booking_id: input.bookingId }
      : {}),
    ...(input.materialId ? { material_id: input.materialId } : {}),
    original_file_name: safeFileName(input.fileName),
    mime_type: mimeType,
    file_size_bytes: input.sizeBytes,
    captured_at: input.capturedAt ?? null,
  });

  if (insertError) {
    // The path trigger fires here. A rejection means the path did not match the
    // prefix the purpose implies, which should be impossible given the path was
    // built above — so it is logged as the anomaly it would be.
    logger.error('Media asset insert rejected', {
      purpose,
      workerId: session.workerId,
      error: insertError.message,
    });
    throw AppError.internal('That file could not be uploaded.');
  }

  // 5. The signed URL binds the content type, so the client cannot upload a
  //    different kind of file than the one that was just authorized.
  const uploadUrl = await signedUploadUrl(storagePath, mimeType, UPLOAD_URL_TTL_SECONDS);

  return {
    mediaAssetId,
    uploadUrl,
    expiresAt: new Date(Date.now() + UPLOAD_URL_TTL_SECONDS * 1000).toISOString(),
  };
}

/**
 * Confirm the bytes actually landed.
 *
 * Only this function may move an asset to COMPLETED, and it does so only after
 * asking Firebase whether the object exists and how big it is. A client saying
 * "done" is not evidence that anything was uploaded.
 */
export async function completeWorkerUpload(
  session: WorkerSession,
  mediaAssetId: string,
): Promise<{ id: string; uploadStatus: string }> {
  const { data: asset, error } = await session.db
    .from('media_assets')
    .select('id, firebase_storage_path, file_size_bytes, upload_status, worker_id')
    .eq('id', mediaAssetId)
    .maybeSingle();

  if (error || !asset) {
    throw AppError.notFound('That upload');
  }

  if (asset.upload_status === 'COMPLETED') {
    return { id: asset.id, uploadStatus: 'COMPLETED' };
  }

  const metadata = await objectMetadata(asset.firebase_storage_path);

  if (!metadata.exists) {
    await markFailed(session, mediaAssetId, 'The file did not finish uploading.');
    throw AppError.validation('That upload did not finish. Please try again.');
  }

  // A size that does not match what was authorized means something other than
  // the intended file arrived. Refusing it is cheap; accepting it would put an
  // unverified object into the evidence chain.
  if (metadata.size !== null && metadata.size !== asset.file_size_bytes) {
    logger.warn('Uploaded object size does not match authorization', {
      mediaAssetId,
      expected: asset.file_size_bytes,
      actual: metadata.size,
    });
    await markFailed(session, mediaAssetId, 'The uploaded file did not match.');
    throw AppError.validation('That upload did not finish. Please try again.');
  }

  // Marked through the service-definer path in the database: the client has no
  // grant to write upload_status, which is what makes COMPLETED meaningful.
  const { error: updateError } = await session.db.rpc('worker_complete_media_upload', {
    p_media_id: mediaAssetId,
  });

  if (updateError) {
    logger.error('Marking media completed failed', {
      mediaAssetId,
      error: updateError.message,
    });
    throw AppError.internal('That file could not be saved.');
  }

  return { id: mediaAssetId, uploadStatus: 'COMPLETED' };
}

/**
 * A short-lived signed URL for a file the worker is allowed to see.
 *
 * By media id, never by path. The path is read from the row after RLS has
 * already decided whether the caller may see it, so a caller cannot ask for an
 * arbitrary object in the bucket.
 */
export async function signedUrlForWorker(
  session: WorkerSession,
  mediaAssetId: string,
): Promise<{ url: string; expiresAt: string }> {
  const { data: asset, error } = await session.db
    .from('media_assets')
    .select('id, firebase_storage_path, sensitivity, upload_status, deleted_at')
    .eq('id', mediaAssetId)
    .maybeSingle();

  // RLS already limits this to media the caller may see, so a missing row and a
  // forbidden row are indistinguishable — which is the right answer to give
  // either way.
  if (error || !asset || asset.deleted_at) {
    throw AppError.notFound('That file');
  }

  if (asset.upload_status !== 'COMPLETED') {
    throw AppError.conflict('That upload has not finished.');
  }

  const ttl =
    DOWNLOAD_TTL_SECONDS[asset.sensitivity as keyof typeof DOWNLOAD_TTL_SECONDS] ?? 300;

  const url = await signedDownloadUrl(asset.firebase_storage_path, ttl);

  return {
    url,
    expiresAt: new Date(Date.now() + ttl * 1000).toISOString(),
  };
}

async function markFailed(
  session: WorkerSession,
  mediaAssetId: string,
  reason: string,
): Promise<void> {
  await session.db
    .rpc('worker_fail_media_upload', {
      p_media_id: mediaAssetId,
      p_reason: reason,
    })
    .throwOnError()
    .then(
      () => undefined,
      (error: unknown) => {
        // Best effort. A stale PENDING row is swept up by the media sweeper and
        // is harmless; failing the request over it would be worse.
        logger.warn('Could not mark upload failed', {
          mediaAssetId,
          error: error instanceof Error ? error.message : 'unknown',
        });
      },
    );
}

/**
 * Which resource the file belongs to, checked against what the caller can see.
 */
async function resolveOwner(
  session: WorkerSession,
  ownerColumn: string,
  input: UploadRequest,
): Promise<{ id: string }> {
  switch (ownerColumn) {
    case 'worker_id':
      // Always the caller's own id, resolved from the token. Never from input.
      return { id: session.workerId };

    case 'booking_id': {
      if (!input.bookingId) {
        throw AppError.validation('That file must be attached to a job.');
      }
      const { data } = await session.db
        .from('bookings')
        .select('id')
        .eq('id', input.bookingId)
        .maybeSingle();

      if (!data) throw AppError.notFound('That job');
      return { id: data.id };
    }

    case 'claim_id': {
      if (!input.claimId) {
        throw AppError.validation('That file must be attached to a claim.');
      }
      const { data } = await session.db
        .from('claims')
        .select('id')
        .eq('id', input.claimId)
        .maybeSingle();

      if (!data) throw AppError.notFound('That claim');
      return { id: data.id };
    }

    case 'support_ticket_id': {
      if (!input.ticketId) {
        throw AppError.validation('That file must be attached to a request.');
      }
      const { data } = await session.db
        .from('support_tickets')
        .select('id')
        .eq('id', input.ticketId)
        .maybeSingle();

      if (!data) throw AppError.notFound('That request');
      return { id: data.id };
    }

    default:
      throw AppError.forbidden('That kind of file cannot be uploaded here.');
  }
}

/**
 * The object path inside the Storage bucket.
 *
 * Exported so the rule can be tested directly, because this one function is
 * what stands between a caller and another worker's KYC folder. Every segment
 * comes from the purpose rule or from a server-generated UUID — none of it from
 * the request body — and the result is asserted to be free of traversal.
 */
export function buildStoragePath(input: {
  pathRoot: string;
  ownerId: string;
  pathFolder: string;
  mediaAssetId: string;
  mimeType: string;
}): string {
  const path =
    `${input.pathRoot}/${input.ownerId}/${input.pathFolder}/` +
    `${input.mediaAssetId}${extensionFor(input.mimeType)}`;

  // Defence in depth. Reaching this would mean a purpose rule row or a UUID
  // contained something it should not, which is worth failing loudly over
  // rather than writing into the bucket.
  if (path.includes('..') || path.startsWith('/') || /\s/.test(path)) {
    throw AppError.internal('That file could not be uploaded.');
  }

  return path;
}

function mediaTypeFor(mimeType: string): MediaType {
  if (mimeType.startsWith('image/')) return MediaType.IMAGE;
  if (mimeType.startsWith('video/')) return MediaType.VIDEO;
  if (mimeType.startsWith('audio/')) return MediaType.AUDIO;
  return MediaType.DOCUMENT;
}

function extensionFor(mimeType: string): string {
  const map: Record<string, string> = {
    'image/jpeg': '.jpg',
    'image/png': '.png',
    'image/webp': '.webp',
    'video/mp4': '.mp4',
    'video/quicktime': '.mov',
    'application/pdf': '.pdf',
    'text/plain': '.txt',
  };
  return map[mimeType] ?? '';
}

/**
 * The display name only. It never reaches the storage path, so this strips what
 * would be confusing rather than what would be dangerous.
 */
export function safeFileName(name: string): string {
  const cleaned = name.replace(/[/\\]/g, '_').trim();
  return cleaned.length > 0 ? cleaned.slice(0, 255) : 'upload';
}
