import 'server-only';

import { serviceClient } from './server';

/**
 * File storage — Supabase Storage, not Firebase.
 *
 * Application media (KYC documents, booking evidence, profile photos, ...)
 * lives in one private Supabase Storage bucket, folder-prefixed by
 * public.media_purpose_rules.path_root (see migration 0017). Every function
 * here uses the service-role client, which bypasses Storage's RLS-equivalent
 * policies entirely — that is what makes a signed URL meaningful: the caller
 * never authenticates to Storage directly, so there is nothing for a client
 * credential to leak or misuse.
 *
 * This module intentionally mirrors the shape of the old
 * lib/firebase/admin.ts storage functions (signedUploadUrl, signedDownloadUrl,
 * objectMetadata) so callers only need to change an import.
 */

export const MEDIA_BUCKET = 'media';

function bucket() {
  return serviceClient().storage.from(MEDIA_BUCKET);
}

/**
 * A short-lived, single-purpose upload URL.
 *
 * Unlike a Firebase V4 signed URL, Supabase does not cryptographically bind
 * the content type into the signature itself — the client's PUT still sets
 * the Content-Type header, and Storage records whatever was sent as the
 * object's mimetype. The guarantee that the declared type was honoured is
 * enforced at confirmation time instead (objectMetadata is compared against
 * what was authorized), not at signing time. See worker-uploads.ts.
 *
 * [contentType] and [expiresInSeconds] are accepted for interface parity with
 * the previous Firebase implementation; Supabase's signed upload token has a
 * fixed lifetime (currently two hours) that cannot be shortened per call.
 */
export async function signedUploadUrl(
  objectPath: string,
  contentType: string,
  expiresInSeconds: number,
): Promise<string> {
  void contentType;
  void expiresInSeconds;

  const { data, error } = await bucket().createSignedUploadUrl(objectPath);

  if (error || !data) {
    throw new Error(`Could not create a signed upload URL: ${error?.message ?? 'unknown error'}`);
  }

  return data.signedUrl;
}

/** A short-lived, read-only URL for one object. */
export async function signedDownloadUrl(
  objectPath: string,
  expiresInSeconds: number,
): Promise<string> {
  const { data, error } = await bucket().createSignedUrl(objectPath, expiresInSeconds);

  if (error || !data) {
    throw new Error(`Could not create a signed download URL: ${error?.message ?? 'unknown error'}`);
  }

  return data.signedUrl;
}

/** Confirm an object actually exists and report its true size and type. */
export async function objectMetadata(
  objectPath: string,
): Promise<{ exists: boolean; size: number | null; contentType: string | null }> {
  const lastSlash = objectPath.lastIndexOf('/');
  const folder = lastSlash === -1 ? '' : objectPath.slice(0, lastSlash);
  const fileName = lastSlash === -1 ? objectPath : objectPath.slice(lastSlash + 1);

  const { data, error } = await bucket().list(folder, {
    search: fileName,
    limit: 1,
  });

  if (error) {
    throw new Error(`Could not read object metadata: ${error.message}`);
  }

  const found = data?.find((entry) => entry.name === fileName);

  if (!found) {
    return { exists: false, size: null, contentType: null };
  }

  return {
    exists: true,
    size: typeof found.metadata?.size === 'number' ? found.metadata.size : null,
    contentType:
      typeof found.metadata?.mimetype === 'string' ? found.metadata.mimetype : null,
  };
}
