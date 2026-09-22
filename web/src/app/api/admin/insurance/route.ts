import { withAdminRoute } from '@/lib/api/admin-handler';
import { translateDatabaseError } from '@/lib/errors/app-error';
import { insuranceRecordSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Record an insurance policy for a worker.
 *
 * admin_record_insurance() stores the policy and approves the worker's
 * INSURANCE check in one transaction, expiring with the policy, and writes the
 * audit row.
 */
export const POST = withAdminRoute(
  { permission: 'insurance.update', bodySchema: insuranceRecordSchema },
  async ({ session, body }) => {
    const { data, error } = await session.db.rpc('admin_record_insurance', {
      p_worker_id: body.workerId,
      p_provider_name: body.providerName,
      p_policy_number: body.policyNumber,
      p_coverage_amount_minor: body.coverageAmountMinor,
      p_start_date: body.startDate,
      p_end_date: body.endDate,
      p_premium_amount_minor: body.premiumAmountMinor ?? null,
      p_notes: body.notes ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data, status: 201 };
  },
);
