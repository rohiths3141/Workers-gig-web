import { workerRoute } from '@/lib/api/worker-handler';
import { completeWorkerUpload } from '@/features/media/server/worker-uploads';

/**
 * POST /api/worker/media/{id}/complete
 *
 * Confirms the bytes landed, and only then marks the asset COMPLETED.
 *
 * The client saying "done" is not evidence that anything was uploaded, so this
 * asks Firebase Storage whether the object exists and whether its size matches
 * what was authorized. Until it does, the asset counts as evidence nowhere —
 * job completion, KYC submission and material cost recording all require a
 * COMPLETED asset, and the database checks that itself.
 */
export const POST = workerRoute(({ session, requireParam }) =>
  completeWorkerUpload(session, requireParam('id')),
);
