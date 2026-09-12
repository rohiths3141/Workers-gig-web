import 'server-only';

import { cookies } from 'next/headers';

import {
  idTokenCookieName,
  sessionCookieName,
} from '@/lib/auth/cookies';
import { serverEnv } from '@/lib/config/env';
import { verifySessionCookie, type VerifiedFirebaseUser } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';

/**
 * Reading the caller's authenticated identity on the server.
 *
 * Writing the session lives in the route handler at /api/auth/session, because
 * only a route handler may set cookies. This module only reads and verifies.
 */

export interface AuthenticatedSession {
  user: VerifiedFirebaseUser;
  /**
   * The current Firebase ID token, forwarded to Supabase so RLS sees the real
   * identity. Absent when the token has expired and the browser has not yet
   * refreshed it — callers must handle that rather than assuming it is present.
   */
  idToken: string | null;
}

/**
 * Verify the session cookie and return the Firebase user.
 *
 * Returns null rather than throwing for an absent or invalid session, so a page
 * can decide between redirecting to login and rendering a public view.
 * `checkRevoked` is on, so an administrator who has been disabled loses access
 * on their next request rather than at the end of their session.
 */
export async function getSession(): Promise<AuthenticatedSession | null> {
  const jar = await cookies();
  const sessionCookie = jar.get(sessionCookieName())?.value;

  if (!sessionCookie) {
    return null;
  }

  try {
    const user = await verifySessionCookie(sessionCookie, true);
    const idToken = jar.get(idTokenCookieName())?.value ?? null;

    return { user, idToken };
  } catch (error) {
    // An expired or revoked cookie is an ordinary event, not an incident. The
    // cookie is cleared by the login page when it sees no session.
    logger.debug('Session cookie rejected', {
      reason: error instanceof Error ? error.message : 'unknown',
    });
    return null;
  }
}

/**
 * The Firebase ID token for forwarding to Supabase.
 *
 * Throws when missing, because every call site that needs it cannot proceed
 * without it — silently falling back to an unauthenticated Supabase client
 * would turn an authorization failure into an empty page.
 */
export async function requireIdToken(): Promise<string> {
  const session = await getSession();

  if (!session) {
    throw new SessionExpiredError('No active session.');
  }

  if (!session.idToken) {
    throw new SessionExpiredError(
      'The identity token has expired and has not been refreshed yet.',
    );
  }

  return session.idToken;
}

/** Raised when the caller has no usable session and must sign in again. */
export class SessionExpiredError extends Error {
  readonly code = 'SESSION_EXPIRED';

  constructor(message: string) {
    super(message);
    this.name = 'SessionExpiredError';
  }
}

/** How long a newly minted session cookie should live. */
export function sessionMaxAgeSeconds(): number {
  return serverEnv().firebaseAdmin.sessionCookieMaxAgeSeconds;
}
