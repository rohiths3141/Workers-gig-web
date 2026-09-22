import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { claimDecisionSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Decide a damage claim.
 *
 * There is no automatic approval path. Every outcome carries the deciding
 * administrator, a reason, a claim_events row and an audit entry, written
 * together by decide_claim(). The database also refuses to approve more than
 * was claimed, or a "partial" approval that is actually the full amount.
 */
export const POST = withAdminRoute(
  {
    permission: 'claims.review',
    bodySchema: claimDecisionSchema,
  },
  async ({ session, body, params }) => {
    const claimId = params.id;

    if (!claimId) {
      throw AppError.validation('No claim was specified.');
    }

    const required =
      body.decision === 'APPROVE' || body.decision === 'PARTIALLY_APPROVE'
        ? 'claims.approve'
        : body.decision === 'REJECT'
          ? 'claims.reject'
          : 'claims.review';

    if (!session.permissions.includes(required)) {
      throw AppError.forbidden(`This decision requires the "${required}" permission.`);
    }

    const { data, error } = await session.db.rpc('decide_claim', {
      p_claim_id: claimId,
      p_decision: body.decision,
      p_amount_minor: body.amountMinor ?? null,
      p_note: body.note ?? null,
      p_reason: body.reason ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
