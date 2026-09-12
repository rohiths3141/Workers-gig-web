import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { customerStatusSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/** Restrict, suspend or reinstate a customer account. Audited in the database. */
export const POST = withAdminRoute(
  {
    permission: 'customers.restrict',
    bodySchema: customerStatusSchema,
    requiresReason: true,
  },
  async ({ session, body, params }) => {
    const customerId = params.id;

    if (!customerId) {
      throw AppError.validation('No customer was specified.');
    }

    const { data, error } = await session.db.rpc('admin_set_customer_status', {
      p_customer_id: customerId,
      p_status: body.status,
      p_reason: body.reason,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
