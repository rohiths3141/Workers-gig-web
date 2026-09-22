import { z } from 'zod';

import { workerRoute } from '@/lib/api/worker-handler';
import { authorizeWorkerUpload } from '@/features/media/server/worker-uploads';

/**
 * POST /api/worker/media/upload-url
 *
 * Authorizes one upload and returns a short-lived signed PUT URL.
 *
 * The request says what kind of file it is and what it is for. It does NOT say
 * where the file goes: the storage path is built server-side from the purpose
 * rule and the owning resource id, so a caller cannot walk into another
 * worker's folder. The database rebuilds the same prefix and rejects the row if
 * it disagrees, so the rule holds in two places.
 */

const schema = z.object({
  purpose: z.string().min(1),
  fileName: z.string().min(1).max(255),
  mimeType: z.string().min(3).max(128),
  // The declared size is bound into the authorization and checked against the
  // object that actually arrives, so a small declaration cannot smuggle a large
  // file past the limit.
  sizeBytes: z.number().int().positive().max(200 * 1024 * 1024),
  bookingId: z.string().uuid().optional(),
  materialId: z.string().uuid().optional(),
  claimId: z.string().uuid().optional(),
  ticketId: z.string().uuid().optional(),
  capturedAt: z.string().datetime().optional(),
});

export const POST = workerRoute(
  ({ session, body }) => authorizeWorkerUpload(session, body),
  { bodySchema: schema },
);
