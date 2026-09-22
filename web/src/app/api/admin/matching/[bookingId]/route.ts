import { withAdminRoute } from '@/lib/api/admin-handler';
import { AppError, translateDatabaseError } from '@/lib/errors/app-error';
import { rerunMatchingSchema } from '@/lib/validation/admin-schemas';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Re-run the matching engine for one booking.
 *
 * Scoring happens entirely inside run_matching(), reading verification state,
 * availability, rating and distance from the database. No score is accepted
 * from any client, so a worker cannot promote themselves up the shortlist.
 */
export const POST = withAdminRoute(
  {
    permission: 'matching.rerun',
    bodySchema: rerunMatchingSchema,
  },
  async ({ session, params }) => {
    const bookingId = params.bookingId;

    if (!bookingId) {
      throw AppError.validation('No booking was specified.');
    }

    const { data, error } = await session.db.rpc('admin_rerun_matching', {
      p_booking_id: bookingId,
    });

    if (error) throw translateDatabaseError(error);

    return { data: { candidates: data ?? [] } };
  },
);
