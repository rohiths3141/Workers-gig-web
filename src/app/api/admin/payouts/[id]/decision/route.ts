import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { payoutDecisionSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Approve or reject a payout.
 *
 * decide_payout() debits the wallet and moves the payout in one transaction,
 * using a ledger idempotency key derived from the payout id. A double-clicked
 * approval cannot pay twice: the second attempt finds the payout is no longer
 * REQUESTED and is refused.
 */
export const POST = withAdminRoute(
  {
    permission: 'payouts.read',
    bodySchema: payoutDecisionSchema,
  },
  async ({ session, body, params }) => {
    const payoutId = params.id;

    if (!payoutId) {
      throw AppError.validation('No payout was specified.');
    }

    const required = body.decision === 'APPROVE' ? 'payouts.approve' : 'payouts.reject';

    if (!session.permissions.includes(required)) {
      throw AppError.forbidden(`This decision requires the "${required}" permission.`);
    }

    const { data, error } = await session.db.rpc('decide_payout', {
      p_payout_id: payoutId,
      p_decision: body.decision,
      p_reason: body.reason ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
