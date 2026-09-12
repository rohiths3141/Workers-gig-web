import type { Metadata } from 'next';
import Link from 'next/link';
import { redirect } from 'next/navigation';
import { ShieldCheck } from 'lucide-react';

import { LoginForm } from '@/app/login/login-form';
import { getAdminSession } from '@/lib/auth/admin-session';
import { publicEnv } from '@/lib/config/env';
import { adminRoutes, isAdminPath, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Sign in',
  // The sign-in page carries no public value and should not be indexed.
  robots: { index: false, follow: false },
};

export const dynamic = 'force-dynamic';

/**
 * Sign-in page.
 *
 * Serves administrators. Customers and workers authenticate in the Flutter
 * apps against the same Firebase project and the same identity model — they do
 * not need a web session, and being signed in here would give them nothing.
 */
export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string }>;
}) {
  const { brand } = publicEnv();
  const params = await searchParams;

  // Already signed in as an administrator: skip the form.
  const session = await getAdminSession();
  if (session) {
    redirect(safeRedirect(params.next) ?? adminRoutes.dashboard());
  }

  return (
    <main className="flex min-h-dvh flex-col bg-ink-50">
      <div className="flex flex-1 items-center justify-center px-5 py-12">
        <div className="w-full max-w-md">
          <Link
            href={publicRoutes.home}
            className="mx-auto flex w-fit items-center gap-2 text-lg font-semibold tracking-tight text-ink-900"
          >
            <span className="flex size-8 items-center justify-center rounded-lg bg-brand-700 text-white">
              <ShieldCheck aria-hidden className="size-4.5" />
            </span>
            {brand.name}
          </Link>

          <div className="mt-7 rounded-2xl border border-ink-200 bg-white p-6 shadow-card sm:p-8">
            <h1 className="text-xl font-semibold tracking-tight text-ink-900">
              Sign in to the admin panel
            </h1>
            <p className="mt-1.5 text-sm text-ink-600">
              Use the Google account or mobile number registered to your administrator profile.
            </p>

            <div className="mt-6">
              <LoginForm redirectTo={safeRedirect(params.next)} />
            </div>
          </div>

          <p className="mt-6 text-center text-sm text-ink-500">
            Looking to book a service or take on work?{' '}
            <Link href={publicRoutes.home} className="font-medium text-brand-700 hover:underline">
              Use the mobile apps
            </Link>
            .
          </p>
        </div>
      </div>
    </main>
  );
}

/**
 * Validate the post-login destination.
 *
 * An unchecked `next` parameter is an open-redirect: an attacker sends
 * /login?next=https://evil.example and the victim is bounced off-site straight
 * after authenticating. Only a relative path inside the admin surface is
 * accepted — no absolute URLs, no protocol-relative `//host` form.
 */
function safeRedirect(next: string | undefined): string | undefined {
  if (!next) return undefined;
  if (!next.startsWith('/') || next.startsWith('//')) return undefined;
  if (!isAdminPath(next)) return undefined;
  return next;
}
