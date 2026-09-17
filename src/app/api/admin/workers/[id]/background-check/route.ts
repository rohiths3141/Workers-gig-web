import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Open a background-check case for a worker.
 *
 * Background checks are run by the platform, never submitted by the worker, so
 * an operator starts one here. admin_open_background_check() re-checks the
 * permission, refuses when a check is already open or current, and writes the
 * audit row in the same transaction.
 */
export const POST = withAdminRoute(
  { permission: 'verification.review' },
  async ({ session, params }) => {
    const workerId = params.id;

    if (!workerId) {
      throw AppError.validation('No worker was specified.');
    }

    const { data, error } = await session.db.rpc('admin_open_background_check', {
      p_worker_id: workerId,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
