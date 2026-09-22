import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { bookingTransitionSchema } from '@/lib/validation/admin-schemas';
import { BookingStatus } from '@/types/domain';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Move a booking through its state machine.
 *
 * The target status is validated against public.booking_transitions inside
 * admin_transition_booking(), so an illegal move is refused by the database
 * rather than by whichever branch of UI code happened to run. The timeline
 * event and the audit entry are written in the same transaction as the status
 * change, so the three can never disagree.
 *
 * Cancellation needs a different permission from an ordinary transition, and
 * the database applies that distinction itself.
 */
export const POST = withAdminRoute(
  {
    // The coarser permission gates the route; the database applies
    // bookings.cancel specifically when the target status is CANCELLED.
    permission: 'bookings.update',
    bodySchema: bookingTransitionSchema,
    requiresReason: true,
  },
  async ({ session, body, params }) => {
    const bookingId = params.id;

    if (!bookingId) {
      throw AppError.validation('No booking was specified.');
    }

    if (body.status === BookingStatus.CANCELLED && !session.permissions.includes('bookings.cancel')) {
      throw AppError.forbidden('Cancelling a booking requires the "bookings.cancel" permission.');
    }

    const { data, error } = await session.db.rpc('admin_transition_booking', {
      p_booking_id: bookingId,
      p_to_status: body.status,
      p_reason: body.reason,
    });

    if (error) throw translateDatabaseError(error);

    return { data };
  },
);
