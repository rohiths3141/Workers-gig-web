import 'server-only';

import { cache } from 'react';

import { getSession } from '@/lib/auth/session';
import { AppError } from '@/lib/errors/app-error';
import type { VerifiedFirebaseUser } from '@/lib/firebase/admin';
import { logger } from '@/lib/logging/logger';
import type { Permission } from '@/lib/permissions/permissions';
import { userScopedClient, type TypedSupabaseClient } from '@/lib/supabase/server';
import type { AdminRole } from '@/types/domain';

/**
 * Resolving the caller's administrative identity.
 *
 * The order here is the whole point, and it is the order the platform
 * specification requires:
 *
 *   Firebase ID token / session cookie
 *        -> verified by the Firebase Admin SDK          (authentication)
 *        -> Firebase UID
 *        -> looked up in public.admin_users             (are they an admin?)
 *        -> effective permissions read from Postgres    (may they do this?)
 *
 * Being signed in proves nothing beyond identity. A customer or worker with a
 * perfectly valid Firebase session resolves to `null` here and is refused.
 *
 * Permissions are read from the database on every request. They are never taken
 * from a token claim, a cookie, or the request body, so an attacker who forges
 * any of those gains nothing.
 */

export interface AdminSession {
  firebaseUid: string;
  /** public.admin_users.id — the actor recorded in the audit trail. */
  adminId: string;
  profileId: string;
  email: string;
  fullName: string;
  role: AdminRole;
  permissions: readonly string[];
  /** The verified Firebase user record behind this session. */
  user: VerifiedFirebaseUser;
  /** Forwarded to Supabase so Row Level Security sees the real identity. */
  idToken: string;
  /** A Supabase client acting as this administrator, with RLS applied. */
  db: TypedSupabaseClient;
}

/**
 * Resolve the current administrator, or null.
 *
 * Wrapped in React `cache` so a server-rendered page that checks permissions in
 * a layout, a header and three panels performs one lookup, not five.
 */
export const getAdminSession = cache(async (): Promise<AdminSession | null> => {
  const session = await getSession();

  if (!session) {
    return null;
  }

  // The session cookie is valid but the short-lived ID token has lapsed. The
  // browser refreshes it automatically; until then there is no token to give
  // Supabase, so the request cannot be authorized.
  if (!session.idToken) {
    logger.debug('Session present but identity token missing or expired', {
      uid: session.user.uid,
    });
    return null;
  }

  const db = userScopedClient(session.idToken);

  // RLS on admin_users allows a caller to read their own row, so this query
  // returns exactly one row for an administrator and nothing for anyone else.
  const { data: admin, error } = await db
    .from('admin_users')
    .select('id, profile_id, firebase_uid, email, full_name, role, is_active')
    .eq('firebase_uid', session.user.uid)
    .eq('is_active', true)
    .maybeSingle();

  if (error) {
    logger.error('Failed to resolve administrator record', {
      uid: session.user.uid,
      error: error.message,
    });
    return null;
  }

  if (!admin) {
    // A signed-in user who is not an administrator. Expected and not an error —
    // a customer opening /admin lands here.
    return null;
  }

  const { data: permissions, error: permissionError } = await db.rpc('admin_permissions', {
    p_admin_id: admin.id,
  });

  if (permissionError) {
    logger.error('Failed to resolve administrator permissions', {
      adminId: admin.id,
      error: permissionError.message,
    });
    return null;
  }

  return {
    firebaseUid: admin.firebase_uid,
    adminId: admin.id,
    profileId: admin.profile_id,
    email: admin.email,
    fullName: admin.full_name,
    role: admin.role,
    permissions: permissions ?? [],
    user: session.user,
    idToken: session.idToken,
    db,
  };
});

/**
 * Require an administrative session, and optionally a specific permission.
 *
 * Throws rather than returning null so a caller cannot forget to check the
 * result. The API wrapper turns these into 401 and 403 responses; the admin
 * layout turns them into a redirect and a Forbidden page.
 */
export async function requireAdmin(permission?: Permission): Promise<AdminSession> {
  const session = await getAdminSession();

  if (!session) {
    throw AppError.unauthenticated('Sign in with an administrator account to continue.');
  }

  if (permission && !session.permissions.includes(permission)) {
    // A denied attempt on an admin surface is worth recording. The database
    // records denials raised inside RPCs; this catches the ones refused earlier.
    logger.warn('Administrative permission denied', {
      adminId: session.adminId,
      role: session.role,
      required: permission,
    });

    throw AppError.forbidden(
      `This action requires the "${permission}" permission, which your role does not include.`,
    );
  }

  return session;
}

/** Non-throwing permission check for conditional rendering. */
export function sessionHasPermission(
  session: AdminSession | null,
  permission: Permission,
): boolean {
  return session?.permissions.includes(permission) ?? false;
}
