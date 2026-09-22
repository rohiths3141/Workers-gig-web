import { randomUUID } from 'node:crypto';

import { cookies } from 'next/headers';
import type { NextRequest } from 'next/server';
import { z } from 'zod';

import {
  clearedCookieOptions,
  idTokenCookieName,
  sessionCookieName,
  sessionCookieOptions,
} from '@/lib/auth/cookies';
import { sessionMaxAgeSeconds } from '@/lib/auth/session';
import { fail, ok } from '@/lib/api/response';
import { adminRoutes, publicRoutes } from '@/lib/config/routes';
import { AppError } from '@/lib/errors/app-error';
import {
  createSessionCookie,
  ensureSupabaseRoleClaim,
  revokeUserSessions,
  verifyIdToken,
  verifySessionCookie,
} from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';
import { serviceClient, userScopedClient } from '@/lib/supabase/server';

/**
 * Session exchange.
 *
 * POST   — trade a freshly minted Firebase ID token for httpOnly session cookies
 * DELETE — sign out, clearing the cookies and revoking Firebase refresh tokens
 *
 * This endpoint is where authentication turns into authorization. It verifies
 * the token with the Firebase Admin SDK, then asks the database whether that
 * Firebase UID belongs to an active administrator. The answer it returns is
 * advisory for routing only — every protected page and API route re-derives the
 * same answer independently, so a tampered response buys nothing.
 */

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const bodySchema = z.object({
  idToken: z.string().min(20).max(4096),
});

export async function POST(request: NextRequest) {
  const requestId = randomUUID();

  try {
    const body = bodySchema.parse(await request.json());

    // 1. Authenticate. checkRevoked catches a user disabled since the token was
    //    issued, which is what stops a removed administrator signing back in.
    const user = await verifyIdToken(body.idToken, true);

    // 1b. Supabase maps the token's `role` claim to a Postgres role, and Firebase
    //     does not issue one. Without `role: "authenticated"` the forwarded token
    //     is treated as anonymous and every RLS policy denies. Add the claim on
    //     the server and ask the client for a fresh token that carries it. No
    //     cookie is set from a token that Supabase would reject.
    if (!user.hasSupabaseRole) {
      await ensureSupabaseRoleClaim(user.uid);

      logger.info('Added Supabase role claim; client must refresh its token', {
        requestId,
        uid: user.uid,
      });

      return ok(
        { isAdmin: false, redirectTo: publicRoutes.home, refreshRequired: true },
        { requestId },
      );
    }

    // 2. Mint the session cookie. Firebase refuses if the ID token is older than
    //    five minutes, so a cookie can only follow a real, recent sign-in.
    const maxAge = sessionMaxAgeSeconds();
    const sessionCookie = await createSessionCookie(body.idToken, maxAge * 1000);

    const jar = await cookies();
    jar.set(sessionCookieName(), sessionCookie, sessionCookieOptions(maxAge));

    // The ID token is forwarded to Supabase on later requests so Row Level
    // Security applies with this identity. It is short-lived by design; the
    // session keeper refreshes it from the browser before it expires.
    jar.set(idTokenCookieName(), body.idToken, sessionCookieOptions(55 * 60));

    // 3. Authorize. Read the platform's own view of this identity.
    const db = userScopedClient(body.idToken, { requestId });

    const { data: admin, error } = await db
      .from('admin_users')
      .select('id, role, full_name, is_active')
      .eq('firebase_uid', user.uid)
      .eq('is_active', true)
      .maybeSingle();

    if (error) {
      logger.error('Failed to check administrator status during sign-in', {
        requestId,
        uid: user.uid,
        error: error.message,
      });
    }

    const isAdmin = Boolean(admin);

    // 4. Record the sign-in. Uses the service role because a first-time signer
    //    may have no profile row yet, and because last_login_at must be written
    //    even for a non-admin who cannot update their own profile.
    await recordSignIn(user.uid, user.email, user.phoneNumber, user.displayName, isAdmin, admin?.id);

    logger.info('Session established', {
      requestId,
      uid: user.uid,
      isAdmin,
      provider: user.signInProvider,
    });

    return ok(
      {
        isAdmin,
        redirectTo: isAdmin ? adminRoutes.dashboard() : publicRoutes.home,
      },
      { requestId },
    );
  } catch (error) {
    if (error instanceof AppError) {
      return fail(error, requestId);
    }

    // A rejected token is an ordinary outcome: expired, replayed, or forged.
    // Log it without the token itself and answer with nothing useful.
    logger.warn('Session exchange rejected', {
      requestId,
      reason: error instanceof Error ? error.message : 'unknown',
    });

    return fail(
      AppError.unauthenticated('Sign-in could not be completed. Please try again.'),
      requestId,
    );
  }
}

export async function DELETE() {
  const jar = await cookies();
  const existing = jar.get(sessionCookieName())?.value;

  // Revoking refresh tokens invalidates every session for this user, not just
  // this browser. Sign-out should mean signed out everywhere for an admin.
  if (existing) {
    try {
      const user = await verifySessionCookie(existing, false);
      await revokeUserSessions(user.uid);
      logger.info('Sessions revoked on sign-out', { uid: user.uid });
    } catch {
      // Already invalid. Clearing the cookies below is still the right thing.
    }
  }

  jar.set(sessionCookieName(), '', clearedCookieOptions());
  jar.set(idTokenCookieName(), '', clearedCookieOptions());

  return ok({ signedOut: true });
}

/**
 * Mirror the Firebase user onto their platform profile.
 *
 * Firebase remains authoritative for identity; these columns exist so that
 * operational screens and joins do not need a Firebase call per row. A profile
 * is created on first sign-in with the CUSTOMER role — being present in
 * profiles confers no privilege, and an administrator is only ever created
 * deliberately through the admin management flow.
 */
async function recordSignIn(
  uid: string,
  email: string | null,
  phone: string | null,
  displayName: string | null,
  isAdmin: boolean,
  adminId?: string,
): Promise<void> {
  const db = serviceClient();
  const now = new Date().toISOString();

  try {
    const { data: existing } = await db
      .from('profiles')
      .select('id')
      .eq('firebase_uid', uid)
      .maybeSingle();

    if (existing) {
      await db
        .from('profiles')
        .update({
          last_login_at: now,
          // Refresh the mirrored contact fields; Firebase is the source.
          ...(email ? { email } : {}),
          ...(phone ? { phone: phone.replace(/^\+/, '') } : {}),
          ...(displayName ? { display_name: displayName } : {}),
        })
        .eq('firebase_uid', uid);
    } else {
      await db.from('profiles').insert({
        firebase_uid: uid,
        role: 'CUSTOMER',
        account_status: 'ACTIVE',
        email: email ?? undefined,
        phone: phone ? phone.replace(/^\+/, '') : undefined,
        display_name: displayName ?? undefined,
        last_login_at: now,
      });
    }

    if (isAdmin && adminId) {
      await db.from('admin_users').update({ last_login_at: now }).eq('id', adminId);
    }
  } catch (error) {
    // Sign-in must not fail because bookkeeping failed.
    logger.error('Failed to record sign-in', {
      uid,
      error: error instanceof Error ? error.message : 'unknown',
    });
  }
}
