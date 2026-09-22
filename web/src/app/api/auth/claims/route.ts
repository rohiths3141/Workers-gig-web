import type { NextRequest } from 'next/server';

import { fail, ok } from '@/lib/api/response';
import { AppError } from '@/lib/errors/app-error';
import { ensureSupabaseRoleClaim, verifyIdToken } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * Ensure a Firebase user carries the Supabase role claim.
 *
 * For the Flutter customer and worker apps, which talk to Supabase directly with
 * their Firebase ID token and have no web session. Call once after sign-in:
 *
 *   POST /api/auth/claims
 *   Authorization: Bearer <Firebase ID token>
 *
 * If the response says `refreshRequired`, call `getIdToken(true)` before using
 * Supabase — custom claims only appear in tokens minted after they are set.
 *
 * The caller's identity comes from the verified token only; the body is ignored.
 * The claim grants nothing beyond what RLS allows any signed-in user.
 */
export async function POST(request: NextRequest) {
  const header = request.headers.get('authorization') ?? '';
  const idToken = header.startsWith('Bearer ') ? header.slice('Bearer '.length).trim() : '';

  if (idToken.length < 20) {
    return fail(AppError.unauthenticated('Send the Firebase ID token as a Bearer token.'));
  }

  try {
    const user = await verifyIdToken(idToken, true);

    if (!user.hasSupabaseRole) {
      await ensureSupabaseRoleClaim(user.uid);
      logger.info('Added Supabase role claim for app user', { uid: user.uid });
    }

    return ok({ refreshRequired: !user.hasSupabaseRole });
  } catch (error) {
    logger.warn('Claim provisioning rejected', {
      reason: error instanceof Error ? error.message : 'unknown',
    });
    return fail(AppError.unauthenticated('The identity token could not be verified.'));
  }
}
