import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { workerStatusSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Change a worker's account status.
 *
 * The route does not write to the workers table. It calls
 * admin_set_worker_status(), which re-checks workers.restrict inside the
 * transaction, requires the reason, clears availability when the account is
 * restricted, and writes the audit row — all atomically, so a status change can
 * never exist without its audit entry.
 */
export const POST = withAdminRoute(
  {
    permission: 'workers.restrict',
    bodySchema: workerStatusSchema,
    requiresReason: true,
  },
  async ({ session, body, params }) => {
    const workerId = params.id;

    if (!workerId) {
      throw AppError.validation('No worker was specified.');
    }

    const { data, error } = await session.db.rpc('admin_set_worker_status', {
      p_worker_id: workerId,
      p_status: body.status,
      p_reason: body.reason,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
