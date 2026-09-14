import 'server-only';

import type { NextRequest } from 'next/server';

import { AppError } from '@/lib/errors/app-error';
import { verifyIdToken, type VerifiedFirebaseUser } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';
import { userScopedClient, type TypedSupabaseClient } from '@/lib/supabase/server';

/**
 * Authenticating a request from the Customer mobile app.
 *
 * Mirrors requireWorker in lib/auth/worker-session.ts exactly, resolved
 * against public.customers instead of public.workers. The customer id is
 * never read from the request body — only from the verified token subject —
 * so a caller cannot act as another customer by passing a different id.
 */

export interface CustomerSession {
  user: VerifiedFirebaseUser;
  /** The platform customer id, resolved server-side from the verified token. */
  customerId: string;
  /** RLS-scoped client acting as this customer. */
  db: TypedSupabaseClient;
}

export async function requireCustomer(request: NextRequest): Promise<CustomerSession> {
  const header = request.headers.get('authorization');

  if (!header?.startsWith('Bearer ')) {
    throw AppError.unauthenticated('Please sign in to continue.');
  }

  const idToken = header.slice('Bearer '.length).trim();
  if (!idToken) {
    throw AppError.unauthenticated('Please sign in to continue.');
  }

  let user: VerifiedFirebaseUser;
  try {
    user = await verifyIdToken(idToken, true);
  } catch (error) {
    logger.debug('Customer ID token rejected', {
      reason: error instanceof Error ? error.message : 'unknown',
    });
    throw AppError.unauthenticated('Your session has ended. Please sign in again.');
  }

  const db = userScopedClient(idToken, {
    userAgent: request.headers.get('user-agent'),
  });

  const { data, error } = await db
    .from('customers')
    .select('id, status')
    .eq('firebase_uid', user.uid)
    .maybeSingle();

  if (error) {
    logger.error('Customer lookup failed', { error: error.message });
    throw AppError.internal();
  }

  if (!data) {
    throw AppError.forbidden('Finish setting up your profile to continue.');
  }

  if (data.status === 'DEACTIVATED') {
    throw AppError.forbidden('This account is closed. Contact support.');
  }

  return { user, customerId: data.id, db };
}
