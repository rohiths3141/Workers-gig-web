import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { workerApproveAllSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Clear every admin gate for a worker in one action.
 *
 * admin_approve_worker_all() approves identity and the background check,
 * every case the worker is waiting on, their requested trades and pending
 * services, then activates the account — in one transaction, with an audit row
 * for each step. It refuses a restricted or suspended account; that is the
 * Reinstate action.
 *
 * It replaces actions that need verification.approve and workers.restrict, so
 * it needs both. The database checks both again.
 */
export const POST = withAdminRoute(
  {
    permission: 'verification.approve',
    bodySchema: workerApproveAllSchema,
    requiresReason: true,
  },
  async ({ session, body, params }) => {
    const workerId = params.id;

    if (!workerId) {
      throw AppError.validation('No worker was specified.');
    }

    if (!session.permissions.includes('workers.restrict')) {
      throw AppError.forbidden('Approving everything also activates the account, which requires the "workers.restrict" permission.');
    }

    const { data, error } = await session.db.rpc('admin_approve_worker_all', {
      p_worker_id: workerId,
      p_reason: body.reason,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
