import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { supportStatusSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/** Move a support ticket through its lifecycle. Audited in the database. */
export const POST = withAdminRoute(
  {
    permission: 'support.respond',
    bodySchema: supportStatusSchema,
  },
  async ({ session, body, params }) => {
    const ticketId = params.id;

    if (!ticketId) {
      throw AppError.validation('No ticket was specified.');
    }

    const { data, error } = await session.db.rpc('admin_set_ticket_status', {
      p_ticket_id: ticketId,
      p_status: body.status,
      p_note: body.note ?? null,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
