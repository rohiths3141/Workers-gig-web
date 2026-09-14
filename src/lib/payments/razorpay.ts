import 'server-only';

import { createHmac, timingSafeEqual } from 'node:crypto';

import { serverEnv } from '@/lib/config/env';
import { AppError } from '@/lib/errors/app-error';

/**
 * Minimal Razorpay REST client.
 *
 * No SDK dependency — two endpoints and an HMAC check don't need one, and it
 * keeps this codebase's minimal-dependency style. Every call here runs only
 * on the server; the key secret never reaches a client of any kind.
 */

const RAZORPAY_API_BASE = 'https://api.razorpay.com/v1';

function credentials(): { keyId: string; keySecret: string } {
  const { razorpay } = serverEnv();
  if (!razorpay.keyId || !razorpay.keySecret) {
    throw AppError.internal(
      'Payments are not configured yet. Please try again later.',
    );
  }
  return { keyId: razorpay.keyId, keySecret: razorpay.keySecret };
}

export interface RazorpayOrder {
  id: string;
  amount: number;
  currency: string;
  status: string;
}

/**
 * Creates a Razorpay order for the given amount (in minor units, e.g. paise).
 * The amount always comes from the booking's own server-computed final
 * amount — never from anything the client sent.
 */
export async function createRazorpayOrder(params: {
  amountMinor: number;
  currency: string;
  receipt: string;
  notes?: Record<string, string>;
}): Promise<RazorpayOrder> {
  const { keyId, keySecret } = credentials();
  const basicAuth = Buffer.from(`${keyId}:${keySecret}`).toString('base64');

  const response = await fetch(`${RAZORPAY_API_BASE}/orders`, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${basicAuth}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      amount: params.amountMinor,
      currency: params.currency,
      receipt: params.receipt,
      notes: params.notes ?? {},
    }),
  });

  if (!response.ok) {
    const detail = await response.text().catch(() => '');
    throw AppError.internal('Could not start the payment. Please try again.', detail);
  }

  const data = (await response.json()) as RazorpayOrder;
  return data;
}

/**
 * Verifies the HMAC-SHA256 signature Razorpay returns after a successful
 * checkout: signature = HMAC_SHA256(order_id + "|" + payment_id, key_secret).
 * This is the ONLY thing that may mark a payment as verified — a client
 * asserting "it succeeded" is never trusted on its own.
 */
export function verifyRazorpaySignature(params: {
  orderId: string;
  paymentId: string;
  signature: string;
}): boolean {
  const { keySecret } = credentials();

  const expected = createHmac('sha256', keySecret)
    .update(`${params.orderId}|${params.paymentId}`)
    .digest('hex');

  const expectedBuf = Buffer.from(expected, 'utf8');
  const actualBuf = Buffer.from(params.signature, 'utf8');

  if (expectedBuf.length !== actualBuf.length) return false;
  return timingSafeEqual(expectedBuf, actualBuf);
}

export function razorpayKeyId(): string {
  return credentials().keyId;
}
