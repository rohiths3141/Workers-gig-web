import { z } from 'zod';

import { customerRoute } from '@/lib/api/customer-handler';
import { AppError } from '@/lib/errors/app-error';
import { verifyRazorpaySignature } from '@/lib/payments/razorpay';
import { serviceClient } from '@/lib/supabase/server';
import type { SystemRpc } from '@/lib/supabase/system-rpc';

/**
 * POST /api/customer/payments/verify
 *
 * The only path that can ever mark a payment SUCCESS. The client's own
 * "it worked" is never trusted — only a signature that verifies against the
 * Razorpay key secret is. See migration 0011's confirm_payment(), which
 * itself refuses to run unless p_signature_verified is true.
 */

const schema = z.object({
  paymentId: z.string().uuid(),
  razorpayOrderId: z.string().min(1),
  razorpayPaymentId: z.string().min(1),
  razorpaySignature: z.string().min(1),
});

export const POST = customerRoute(
  async ({ session, body }) => {
    // Confirm the payment row is really this customer's own before doing
    // anything with the gateway ids it names.
    const { data: payment, error: paymentError } = await session.db
      .from('payments')
      .select('id, gateway_order_id, status')
      .eq('id', body.paymentId)
      .maybeSingle();

    if (paymentError) throw AppError.internal(undefined, paymentError);
    if (!payment) throw AppError.notFound('That payment');

    if (payment.gateway_order_id !== body.razorpayOrderId) {
      throw AppError.forbidden('Payment verification failed.');
    }

    if (payment.status === 'SUCCESS') {
      // Already confirmed (e.g. a retried client call) — idempotent no-op.
      return { verified: true };
    }

    const signatureValid = verifyRazorpaySignature({
      orderId: body.razorpayOrderId,
      paymentId: body.razorpayPaymentId,
      signature: body.razorpaySignature,
    });

    if (!signatureValid) {
      throw AppError.forbidden('Payment verification failed.');
    }

    const admin = serviceClient();
    // See lib/supabase/system-rpc.ts — confirm_payment is real and
    // service-role-only, just absent from the generated Database types.
    const { error: confirmError } = await (admin.rpc as unknown as SystemRpc)('confirm_payment', {
      p_payment_id: body.paymentId,
      p_gateway_payment_id: body.razorpayPaymentId,
      p_signature_verified: true,
      p_payload: { razorpayOrderId: body.razorpayOrderId },
    });

    if (confirmError) throw AppError.internal(undefined, confirmError);

    return { verified: true };
  },
  { bodySchema: schema },
);
