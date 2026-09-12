import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { AdminShell } from '@/components/admin/admin-shell';
import { SessionKeeper } from '@/components/auth/session-keeper';
import { ToastProvider } from '@/components/ui/toast';
import { getAdminSession } from '@/lib/auth/admin-session';
import { publicEnv } from '@/lib/config/env';
import { adminRoute } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: { default: 'Admin', template: '%s | Admin' },
  // Belt and braces alongside the X-Robots-Tag header set in next.config.ts.
  robots: { index: false, follow: false, nocache: true },
};

/**
 * Admin panel layout — the second authorization layer.
 *
 *   1. Middleware redirected anyone with no session cookie. That check is cheap
 *      and unverified; it proves nothing.
 *   2. This layout verifies the cookie with the Firebase Admin SDK, resolves
 *      the Firebase UID against public.admin_users, and loads the effective
 *      permissions from Postgres. A signed-in customer or worker gets nothing.
 *   3. Each page re-checks the permission it needs.
 *   4. Each API route checks again.
 *   5. Each database function checks again, inside the transaction.
 *
 * Rendering is never allowed to proceed on the assumption that an earlier layer
 * did its job.
 */

// Authorization must be evaluated per request; nothing here may be cached.
export const dynamic = 'force-dynamic';
export const revalidate = 0;

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const session = await getAdminSession();

  if (!session) {
    // Includes the intended destination so the operator lands where they meant
    // to go after signing in. The login page validates it against open redirect.
    redirect(`/login?next=${encodeURIComponent(adminRoute())}`);
  }

  const { brand } = publicEnv();

  return (
    <ToastProvider>
      {/* Keeps the server's Firebase ID token fresh so Supabase RLS continues to
          see this operator's identity for the whole session. */}
      <SessionKeeper />

      <AdminShell
        fullName={session.fullName}
        email={session.email}
        role={session.role}
        permissions={session.permissions}
        brandName={brand.name}
      >
        {children}
      </AdminShell>
    </ToastProvider>
  );
}
