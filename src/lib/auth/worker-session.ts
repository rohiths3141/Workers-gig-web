import 'server-only';

import type { NextRequest } from 'next/server';

import { AppError } from '@/lib/errors/app-error';
import { verifyIdToken, type VerifiedFirebaseUser } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';
import { userScopedClient, type TypedSupabaseClient } from '@/lib/supabase/server';

/**
 * Authenticating a request from the Worker mobile app.
 *
 * The mobile app has no cookies. It sends the Firebase ID token it already
 * holds as a Bearer header, the Admin SDK verifies it here, and the same token
 * is forwarded to Supabase so RLS sees the real identity.
 *
 * Note what is NOT read from the request: the worker id. It is resolved from
 * the token's subject against the database, so a caller cannot act as another
 * worker by putting an id in the body — which is the mistake that makes most
 * mobile backends exploitable.
 */

export interface WorkerSession {
  user: VerifiedFirebaseUser;
  /** The platform worker id, resolved server-side from the verified token. */
  workerId: string;
  /** RLS-scoped client acting as this worker. */
  db: TypedSupabaseClient;
}

/**
 * Verify the Bearer token and resolve the worker.
 *
 * `checkRevoked` is on, so a worker whose account is disabled loses access on
 * their next request rather than whenever their token happens to expire.
 */
export async function requireWorker(request: NextRequest): Promise<WorkerSession> {
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
    logger.debug('Worker ID token rejected', {
      reason: error instanceof Error ? error.message : 'unknown',
    });
    throw AppError.unauthenticated('Your session has ended. Please sign in again.');
  }

  const db = userScopedClient(idToken, {
    userAgent: request.headers.get('user-agent'),
  });

  // The worker row is read through the RLS-scoped client, so this doubles as a
  // check that the token really does resolve to a worker on this platform.
  const { data, error } = await db
    .from('workers')
    .select('id, status')
    .eq('firebase_uid', user.uid)
    .maybeSingle();

  if (error) {
    logger.error('Worker lookup failed', { error: error.message });
    throw AppError.internal();
  }

  if (!data) {
    throw AppError.forbidden('Finish setting up your profile to continue.');
  }

  // A deactivated account keeps no access at all. Every other state — including
  // restricted and suspended — can still reach the app, because a worker needs
  // to be able to see why and contact support.
  if (data.status === 'DEACTIVATED') {
    throw AppError.forbidden('This account is closed. Contact support.');
  }

  return { user, workerId: data.id, db };
}
