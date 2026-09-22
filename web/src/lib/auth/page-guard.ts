import 'server-only';

import { redirect } from 'next/navigation';

import { getAdminSession, type AdminSession } from '@/lib/auth/admin-session';
import { adminRoute } from '@/lib/config/routes';
import type { Permission } from '@/lib/permissions/permissions';

/**
 * Page-level authorization.
 *
 * Distinguishes the two failures so each gets the right treatment:
 *
 *   not signed in  -> redirect to the sign-in page, remembering the destination
 *   signed in but not permitted -> render the page shell with a Forbidden panel
 *
 * Redirecting on a permission failure would be wrong: it hides the fact that
 * the operator reached the right place with the wrong role, and a redirect loop
 * is the usual result.
 */

export interface PageGuardResult {
  session: AdminSession;
  /** False when the operator is signed in but lacks the required permission. */
  allowed: boolean;
}

export async function guardPage(
  permission: Permission,
  currentPath?: string,
): Promise<PageGuardResult> {
  const session = await getAdminSession();

  if (!session) {
    redirect(`/login?next=${encodeURIComponent(currentPath ?? adminRoute())}`);
  }

  return {
    session,
    allowed: session.permissions.includes(permission),
  };
}
