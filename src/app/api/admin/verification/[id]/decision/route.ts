import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { verificationDecisionSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Decide one verification case.
 *
 * decide_verification() resolves the required permission from the decision
 * itself — approve needs verification.approve, reject needs verification.reject,
 * the rest need verification.review — and refuses outright if the reviewer is
 * the worker whose case it is. Nobody verifies their own paperwork.
 */
export const POST = withAdminRoute(
  {
    // Baseline to reach the endpoint. The database applies the specific
    // permission for the decision being made.
    permission: 'verification.review',
    bodySchema: verificationDecisionSchema,
  },
  async ({ session, body, params }) => {
    const verificationId = params.id;

    if (!verificationId) {
      throw AppError.validation('No verification case was specified.');
    }

    const required =
      body.decision === 'APPROVE'
        ? 'verification.approve'
        : body.decision === 'REJECT'
          ? 'verification.reject'
          : 'verification.review';

    if (!session.permissions.includes(required)) {
      throw AppError.forbidden(`This decision requires the "${required}" permission.`);
    }

    const { data, error } = await session.db.rpc('decide_verification', {
      p_verification_id: verificationId,
      p_decision: body.decision,
      p_note: body.note ?? null,
      p_rejection_reason: body.rejectionReason ?? null,
      p_info_requested: body.infoRequested ?? null,
      p_expires_at: body.expiresAt ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
