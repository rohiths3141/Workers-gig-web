import { workerRoute } from '@/lib/api/worker-handler';
import { signedUrlForWorker } from '@/features/media/server/worker-uploads';

/**
 * POST /api/worker/media/{id}/url
 *
 * A short-lived signed URL for a file the worker is allowed to open.
 *
 * By media id, never by path. The path is read from the row after RLS has
 * decided whether the caller may see it at all, so this cannot be used to fetch
 * an arbitrary object from the bucket. Identity documents get the shortest
 * window of any file on the platform.
 *
 * POST rather than GET because the URL it returns is a credential, and a
 * credential does not belong in a browser history, a proxy log or a referrer
 * header.
 */
export const POST = workerRoute(({ session, requireParam }) =>
  signedUrlForWorker(session, requireParam('id')),
);
