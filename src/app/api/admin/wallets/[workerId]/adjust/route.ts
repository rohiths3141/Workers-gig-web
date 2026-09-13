import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { walletAdjustmentSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Post a manual wallet adjustment.
 *
 * This never assigns a balance. It posts a signed entry to the append-only
 * ledger and a trigger recomputes the balance from it. A mistake is corrected
 * with a compensating entry that stays visible. The client-supplied idempotency
 * key makes a retried request post once.
 */
export const POST = withAdminRoute(
  {
    permission: 'wallets.adjust',
    bodySchema: walletAdjustmentSchema,
    requiresReason: true,
  },
  async ({ session, body, params }) => {
    const workerId = params.workerId;

    if (!workerId) {
      throw AppError.validation('No worker was specified.');
    }

    const { data, error } = await session.db.rpc('admin_adjust_wallet', {
      p_worker_id: workerId,
      p_amount_minor: body.amountMinor,
      p_direction: body.direction,
      p_reason: body.reason,
      p_idempotency_key: body.idempotencyKey,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
