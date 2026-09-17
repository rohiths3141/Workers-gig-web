import 'server-only';

import type { AdminSession } from '@/lib/auth/admin-session';
import { AppError } from '@/lib/errors/app-error';
import { objectMetadata, signedDownloadUrl } from '@/lib/supabase/storage';
import { logger } from '@/lib/logging/logger';
import { MediaSensitivity, MediaUploadStatus } from '@/types/domain';

/**
 * Access to media held in Supabase Storage.
 *
 * This is the only place in the web tier that mints a download URL, and it is
 * the reason a client-supplied storage path is never trusted anywhere: the path
 * is read from public.media_assets, not from the request.
 *
 * The sequence, for every single file:
 *
 *   media id (never a path)
 *     -> row read through the operator's RLS-scoped client
 *     -> permission named by the purpose rule checked against this operator
 *     -> access to a SENSITIVE file recorded in the audit trail
 *     -> short-lived signed URL minted by the Supabase service-role client
 *
 * Nothing sensitive is ever public, and a URL that does escape stops working
 * within minutes.
 */

/**
 * Signed URL lifetime.
 *
 * Long enough to open a document and read it, short enough that a URL copied
 * out of a browser history or a chat message is useless by the time it is used.
 * Identity documents get the shortest window.
 */
const TTL_SECONDS = {
  [MediaSensitivity.PUBLIC]: 60 * 60,
  [MediaSensitivity.INTERNAL]: 15 * 60,
  [MediaSensitivity.SENSITIVE]: 5 * 60,
} as const;

export interface SignedMedia {
  id: string;
  url: string;
  fileName: string;
  mimeType: string;
  sizeBytes: number;
  sensitivity: string;
  expiresAt: string;
}

export async function signedUrlForMedia(
  session: AdminSession,
  mediaId: string,
): Promise<SignedMedia> {
  // 1. Read the asset. RLS already limits this to media the caller may see, so
  //    a missing row and a forbidden row are indistinguishable — which is the
  //    correct answer to give either way.
  const { data: media, error } = await session.db
    .from('media_assets')
    .select(
      'id, storage_path, storage_bucket, purpose, sensitivity, upload_status, original_file_name, mime_type, file_size_bytes, worker_id, booking_id, claim_id, support_ticket_id, deleted_at',
    )
    .eq('id', mediaId)
    .maybeSingle();

  if (error) {
    logger.error('Media lookup failed', { mediaId, error: error.message });
    throw AppError.internal('The file could not be opened.');
  }

  if (!media || media.deleted_at) {
    throw AppError.notFound('That file');
  }

  if (media.upload_status !== MediaUploadStatus.COMPLETED) {
    throw AppError.conflict(
      'That upload has not finished, so there is nothing to open yet.',
    );
  }

  // 2. Check the permission this purpose demands. The rule lives in the
  //    database next to the data, so adding a media purpose cannot accidentally
  //    ship without an access rule.
  const { data: rule } = await session.db
    .from('media_purpose_rules')
    .select('required_permission, sensitivity')
    .eq('purpose', media.purpose)
    .maybeSingle();

  if (!rule) {
    logger.error('Media purpose has no access rule', { mediaId, purpose: media.purpose });
    throw AppError.internal('The file could not be opened.');
  }

  if (!session.permissions.includes(rule.required_permission)) {
    logger.warn('Media access denied', {
      mediaId,
      adminId: session.adminId,
      purpose: media.purpose,
      required: rule.required_permission,
    });

    throw AppError.forbidden(
      `Opening this file requires the "${rule.required_permission}" permission.`,
    );
  }

  // 3. Record access to sensitive material. Who opened which identity document
  //    and when is exactly what an investigation or a privacy audit needs.
  if (media.sensitivity === MediaSensitivity.SENSITIVE) {
    const { error: auditError } = await session.db.rpc('write_audit_log', {
      p_action: 'media.sensitive_accessed',
      p_resource_type: 'media_asset',
      p_resource_id: media.id,
      p_after: {
        purpose: media.purpose,
        worker_id: media.worker_id,
        claim_id: media.claim_id,
        support_ticket_id: media.support_ticket_id,
      },
      p_reason: 'Opened from the admin panel',
    });

    // If the access cannot be recorded, do not grant the access. An unlogged
    // read of an identity document is worse than a failed one.
    if (auditError) {
      logger.error('Refusing sensitive media access: audit write failed', {
        mediaId,
        adminId: session.adminId,
        error: auditError.message,
      });

      throw AppError.internal('The file could not be opened. Please try again.');
    }
  }

  // 4. Mint the URL.
  const ttl = TTL_SECONDS[media.sensitivity as keyof typeof TTL_SECONDS] ?? 300;

  try {
    const url = await signedDownloadUrl(media.storage_path, ttl);

    return {
      id: media.id,
      url,
      fileName: media.original_file_name,
      mimeType: media.mime_type,
      sizeBytes: media.file_size_bytes,
      sensitivity: media.sensitivity,
      expiresAt: new Date(Date.now() + ttl * 1000).toISOString(),
    };
  } catch (caught) {
    logger.error('Failed to sign media URL', {
      mediaId,
      error: caught instanceof Error ? caught.message : 'unknown',
    });

    throw AppError.internal('The file could not be opened.');
  }
}

/**
 * Confirm an object really exists in Firebase Storage and matches its record.
 *
 * Used by the upload-completion path and by operational checks. A record whose
 * object is missing, or whose size disagrees with what was declared, must not be
 * treated as a completed upload.
 */
export async function verifyStoredObject(
  storagePath: string,
  declaredSize: number,
): Promise<{ ok: boolean; reason?: string }> {
  const metadata = await objectMetadata(storagePath);

  if (!metadata.exists) {
    return { ok: false, reason: 'The object does not exist in storage.' };
  }

  if (metadata.size !== null && metadata.size !== declaredSize) {
    return {
      ok: false,
      reason: `Stored size ${metadata.size} does not match the declared size ${declaredSize}.`,
    };
  }

  return { ok: true };
}
