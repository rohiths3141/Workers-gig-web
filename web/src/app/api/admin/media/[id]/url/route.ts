import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError } from '@/lib/errors/app-error';
import { signedUrlForMedia } from '@/features/media/server/media-access';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Mint a short-lived signed URL for one media asset.
 *
 * The caller supplies a media id, never a storage path. The path is read from
 * the database, and the permission required to open it comes from that asset's
 * purpose rule — so this endpoint cannot be talked into signing an arbitrary
 * object in the bucket.
 *
 * `media.read` only gets you through the door; signedUrlForMedia then enforces
 * the specific permission the asset demands, which for identity documents is
 * workers.documents.read.
 */
export const GET = withAdminRoute({ permission: 'media.read' }, async ({ session, params }) => {
  const mediaId = params.id;

  if (!mediaId || !/^[0-9a-f-]{36}$/i.test(mediaId)) {
    throw AppError.validation('That is not a valid media reference.');
  }

  const media = await signedUrlForMedia(session, mediaId);

  return { data: media };
});
