import { cookies } from 'next/headers';
import type { NextRequest } from 'next/server';
import { z } from 'zod';

import {
  idTokenCookieName,
  sessionCookieName,
  sessionCookieOptions,
} from '@/lib/auth/cookies';
import { fail, ok } from '@/lib/api/response';
import { AppError } from '@/lib/errors/app-error';
import { verifyIdToken, verifySessionCookie } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';

/**
 * Refresh the stored Firebase ID token.
 *
 * A Firebase ID token lasts an hour. The server needs a current one to forward
 * to Supabase so Row Level Security applies with the caller's identity, but the
 * server cannot refresh it itself — only the browser holds the refresh token.
 *
 * So the browser's session keeper posts a newly refreshed ID token here, and
 * this endpoint verifies it before storing it. Two checks make that safe:
 *
 *   1. The token's signature and expiry are verified by the Admin SDK.
 *   2. The token's UID must match the UID in the existing session cookie, so a
 *      refresh cannot be used to swap the session to a different user.
 */

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const bodySchema = z.object({
  idToken: z.string().min(20).max(4096),
});

export async function POST(request: NextRequest) {
  try {
    const body = bodySchema.parse(await request.json());

    const jar = await cookies();
    const sessionCookie = jar.get(sessionCookieName())?.value;

    if (!sessionCookie) {
      return fail(AppError.unauthenticated('No active session to refresh.'));
    }

    const [sessionUser, tokenUser] = await Promise.all([
      verifySessionCookie(sessionCookie, true),
      verifyIdToken(body.idToken, false),
    ]);

    // The refresh must belong to the session it is refreshing.
    if (sessionUser.uid !== tokenUser.uid) {
      logger.warn('Identity token refresh rejected: UID mismatch', {
        sessionUid: sessionUser.uid,
        tokenUid: tokenUser.uid,
      });
      return fail(AppError.forbidden('That token does not belong to this session.'));
    }

    // A token without the Supabase role claim would be treated as anonymous by
    // the database, so it is not worth storing.
    if (!tokenUser.hasSupabaseRole) {
      return fail(AppError.unauthenticated('Please sign in again to finish setting up your session.'));
    }

    jar.set(idTokenCookieName(), body.idToken, sessionCookieOptions(55 * 60));

    return ok({ refreshed: true });
  } catch (error) {
    logger.debug('Identity token refresh failed', {
      reason: error instanceof Error ? error.message : 'unknown',
    });

    return fail(AppError.unauthenticated('Your session has expired. Please sign in again.'));
  }
}
