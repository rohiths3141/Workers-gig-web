import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { supportMessageSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Reply on a support ticket.
 *
 * Internal notes are marked in the database, and the RLS policy serving the
 * customer and worker apps filters them out — visibility is decided by the
 * database, not by a client-side filter a modified app could skip.
 */
export const POST = withAdminRoute(
  {
    permission: 'support.respond',
    bodySchema: supportMessageSchema,
  },
  async ({ session, body, params }) => {
    const ticketId = params.id;

    if (!ticketId) {
      throw AppError.validation('No ticket was specified.');
    }

    const { data, error } = await session.db.rpc('admin_post_support_message', {
      p_ticket_id: ticketId,
      p_body: body.body,
      p_is_internal: body.isInternal,
    });

    if (error) throw translateDatabaseError(error);

    return { data, status: 201 };
  },
);
