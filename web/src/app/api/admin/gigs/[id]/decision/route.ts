import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { gigDecisionSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Approve or reject a gig awaiting review.
 *
 * admin_decide_gig() re-checks verification.approve / verification.reject for
 * the specific decision, refuses a gig that is not PENDING_REVIEW, and writes
 * the audit row in the same transaction.
 */
export const POST = withAdminRoute(
  { permission: 'verification.read', bodySchema: gigDecisionSchema },
  async ({ session, body, params }) => {
    const gigId = params.id;

    if (!gigId) {
      throw AppError.validation('No gig was specified.');
    }

    const required = body.decision === 'APPROVE' ? 'verification.approve' : 'verification.reject';
    if (!session.permissions.includes(required)) {
      throw AppError.forbidden(`This decision requires the "${required}" permission.`);
    }

    const { data, error } = await session.db.rpc('admin_decide_gig', {
      p_gig_id: gigId,
      p_decision: body.decision,
      p_reason: body.reason ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
