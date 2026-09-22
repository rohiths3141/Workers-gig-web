import { randomUUID } from 'node:crypto';

import { z } from 'zod';

import { customerRoute } from '@/lib/api/customer-handler';
import { AppError } from '@/lib/errors/app-error';
import { createRazorpayOrder, razorpayKeyId } from '@/lib/payments/razorpay';
import { serviceClient } from '@/lib/supabase/server';
import type { SystemRpc } from '@/lib/supabase/system-rpc';

/**
 * POST /api/customer/payments/create-order
 *
 * Starts (or resumes) payment for a booking. The amount is never taken from
 * the request — it is read from the booking row the database itself
 * computed.
 *
 * Customers pay upfront, right after booking (REQUESTED). The money is held
 * and only credited to the worker once the customer approves the work
 * (migration 0054). COMPLETED / PAYMENT_PENDING remain payable for bookings
 * that were never paid upfront; for those, moving COMPLETED -> PAYMENT_PENDING
 * is a SYSTEM-only transition and the customer asking to pay IS that event.
 */

const schema = z.object({
  bookingId: z.string().uuid(),
});

export const POST = customerRoute(
  async ({ session, body }) => {
    const { bookingId } = body;

    // Read through the RLS-scoped client so a booking that is not the
    // caller's own simply is not found.
    const { data: booking, error: bookingError } = await session.db
      .from('bookings')
      .select('id, status, final_amount_minor, quoted_amount_minor, platform_fee_minor, worker_amount_minor, material_amount_minor, currency')
      .eq('id', bookingId)
      .maybeSingle();

    if (bookingError) throw AppError.internal(undefined, bookingError);
    if (!booking) throw AppError.notFound('That booking');

    const payableStatuses = ['REQUESTED', 'COMPLETED', 'PAYMENT_PENDING'];
    if (!payableStatuses.includes(booking.status)) {
      throw AppError.validation('This booking cannot be paid for at this stage.');
    }

    const amountMinor = booking.final_amount_minor ?? booking.quoted_amount_minor;
    if (!amountMinor || amountMinor <= 0) {
      throw AppError.internal('This booking has no payable amount.');
    }

    const admin = serviceClient();

    // Paid once, never twice: an upfront payment already covers the booking
    // through completion.
    const { data: captured, error: capturedError } = await admin
      .from('payments')
      .select('id')
      .eq('booking_id', bookingId)
      .eq('status', 'SUCCESS')
      .limit(1)
      .maybeSingle();

    if (capturedError) throw AppError.internal(undefined, capturedError);
    if (captured) throw AppError.conflict('This booking is already paid.');

    // Re-use an existing in-flight payment for this booking rather than
    // minting a duplicate Razorpay order every time the customer reopens
    // the payment screen.
    const { data: existing, error: existingError } = await admin
      .from('payments')
      .select('id, gateway_order_id, status, amount_minor, currency')
      .eq('booking_id', bookingId)
      .eq('status', 'PENDING')
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle();

    if (existingError) throw AppError.internal(undefined, existingError);

    if (existing?.gateway_order_id) {
      return {
        paymentId: existing.id,
        razorpayOrderId: existing.gateway_order_id,
        amountMinor: existing.amount_minor,
        currency: existing.currency,
        keyId: razorpayKeyId(),
      };
    }

    if (booking.status === 'COMPLETED') {
      // transition_booking() is intentionally absent from the generated
      // Database types: it has no grant to anon/authenticated, so
      // `supabase gen types` never sees it as part of the public API
      // surface. It is real and callable here because `admin` holds the
      // service_role key, which bypasses grants entirely.
      const { error: transitionError } = await (admin.rpc as unknown as SystemRpc)('transition_booking', {
        p_booking_id: bookingId,
        p_to_status: 'PAYMENT_PENDING',
        p_actor_type: 'SYSTEM',
        p_reason: 'Payment requested by customer',
      });
      if (transitionError) throw AppError.internal(undefined, transitionError);
    }

    const currency = booking.currency ?? 'INR';

    let paymentId = existing?.id ?? null;
    if (!paymentId) {
      const { data: inserted, error: insertError } = await admin
        .from('payments')
        .insert({
          booking_id: bookingId,
          customer_id: session.customerId,
          amount_minor: amountMinor,
          platform_fee_minor: booking.platform_fee_minor ?? 0,
          worker_amount_minor: booking.worker_amount_minor ?? 0,
          material_amount_minor: booking.material_amount_minor ?? 0,
          currency,
          gateway: 'razorpay',
          idempotency_key: randomUUID(),
        })
        .select('id')
        .single();

      if (insertError) throw AppError.internal(undefined, insertError);
      paymentId = inserted.id;
    }

    const order = await createRazorpayOrder({
      amountMinor,
      currency,
      receipt: paymentId,
      notes: { bookingId, customerId: session.customerId },
    });

    const { error: updateError } = await admin
      .from('payments')
      .update({ gateway_order_id: order.id })
      .eq('id', paymentId);

    if (updateError) throw AppError.internal(undefined, updateError);

    return {
      paymentId,
      razorpayOrderId: order.id,
      amountMinor,
      currency,
      keyId: razorpayKeyId(),
    };
  },
  { bodySchema: schema },
);
