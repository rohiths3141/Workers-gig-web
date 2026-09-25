'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { ChevronRight, LogOut, Menu, X } from 'lucide-react';

import { visibleNavigation } from '@/components/admin/navigation';
import { BrandLogo } from '@/components/shared/brand-logo';
import { publicRoutes } from '@/lib/config/routes';
import { signOutEverywhere } from '@/lib/firebase/sign-in';
import { ROLE_LABELS } from '@/lib/permissions/permissions';
import { cn } from '@/lib/utils/cn';
import { initialsOf } from '@/lib/utils/format';
import type { AdminRole } from '@/types/domain';

/**
 * Admin chrome: sidebar, header and the mobile drawer.
 *
 * A client component because it needs the current path and a menu toggle, but
 * it receives the identity and permission list as props from the server. It
 * never resolves either itself, so nothing here can be manipulated into showing
 * a link the operator has not been granted.
 *
 * Desktop-first, as an operational console should be — but the sidebar
 * collapses into a drawer and the layout stays usable on a tablet or a phone.
 */

export interface AdminShellProps {
  fullName: string;
  email: string;
  role: AdminRole;
  permissions: readonly string[];
  brandName: string;
  children: React.ReactNode;
}

export function AdminShell({
  fullName,
  email,
  role,
  permissions,
  brandName,
  children,
}: AdminShellProps) {
  const pathname = usePathname();
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [signingOut, setSigningOut] = useState(false);

  const sections = visibleNavigation(permissions);

  useEffect(() => {
    setDrawerOpen(false);
  }, [pathname]);

  const handleSignOut = async () => {
    setSigningOut(true);
    try {
      await signOutEverywhere();
    } finally {
      // A hard navigation, so no server-rendered admin content survives in the
      // back/forward cache after sign-out.
      window.location.href = '/login';
    }
  };

  const navigation = (
    <nav aria-label="Admin sections" className="space-y-6 px-3 py-4">
      {sections.map((section) => (
        <div key={section.heading}>
          <h2 className="px-3 text-[0.6875rem] font-semibold uppercase tracking-wider text-ink-500">
            {section.heading}
          </h2>

          <ul className="mt-1.5 space-y-0.5">
            {section.items.map((item) => {
              const active = item.matchPrefix
                ? pathname === item.href || pathname.startsWith(`${item.href}/`)
                : pathname === item.href;

              const Icon = item.icon;

              return (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    aria-current={active ? 'page' : undefined}
                    className={cn(
                      'flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
                      active
                        ? 'bg-brand-700 text-white'
                        : 'text-ink-300 hover:bg-ink-800 hover:text-white',
                    )}
                  >
                    <Icon aria-hidden className="size-4 shrink-0" />
                    <span className="truncate">{item.label}</span>
                  </Link>
                </li>
              );
            })}
          </ul>
        </div>
      ))}
    </nav>
  );

  return (
    <div className="flex min-h-dvh bg-ink-50">
      <a href="#admin-main" className="skip-link">
        Skip to main content
      </a>

      {/* ---------------------------------------------------------------
          Desktop sidebar
          --------------------------------------------------------------- */}
      <aside className="hidden w-64 shrink-0 flex-col border-r border-ink-800 bg-ink-900 lg:flex">
        <div className="flex h-14 shrink-0 items-center gap-2 border-b border-ink-800 px-4">
          {/* The mark sits on a white tile: the dark sidebar would swallow it. */}
          <span className="flex size-7 shrink-0 items-center justify-center rounded-lg bg-white">
            <BrandLogo name="" variant="mark" className="h-4" />
          </span>
          <span className="truncate text-sm font-semibold text-white">{brandName}</span>
          <span className="ml-auto rounded bg-ink-800 px-1.5 py-0.5 text-[0.625rem] font-semibold uppercase tracking-wide text-ink-400">
            Admin
          </span>
        </div>

        <div className="flex-1 overflow-y-auto">{navigation}</div>

        <AdminIdentity
          fullName={fullName}
          email={email}
          role={role}
          onSignOut={handleSignOut}
          signingOut={signingOut}
        />
      </aside>

      {/* ---------------------------------------------------------------
          Mobile drawer
          --------------------------------------------------------------- */}
      {drawerOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <button
            type="button"
            aria-label="Close navigation"
            onClick={() => setDrawerOpen(false)}
            className="absolute inset-0 bg-ink-950/50"
          />

          <div className="relative flex h-full w-72 max-w-[85vw] flex-col bg-ink-900 shadow-overlay">
            <div className="flex h-14 shrink-0 items-center justify-between border-b border-ink-800 px-4">
              <span className="text-sm font-semibold text-white">{brandName} Admin</span>
              <button
                type="button"
                onClick={() => setDrawerOpen(false)}
                className="rounded p-1.5 text-ink-400 hover:bg-ink-800 hover:text-white"
              >
                <X aria-hidden className="size-5" />
                <span className="sr-only">Close navigation</span>
              </button>
            </div>

            <div className="flex-1 overflow-y-auto">{navigation}</div>

            <AdminIdentity
              fullName={fullName}
              email={email}
              role={role}
              onSignOut={handleSignOut}
              signingOut={signingOut}
            />
          </div>
        </div>
      )}

      {/* ---------------------------------------------------------------
          Main column
          --------------------------------------------------------------- */}
      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-30 flex h-14 shrink-0 items-center gap-3 border-b border-ink-200 bg-white px-4">
          <button
            type="button"
            onClick={() => setDrawerOpen(true)}
            aria-expanded={drawerOpen}
            className="-ml-1 rounded-lg p-2 text-ink-600 hover:bg-ink-100 lg:hidden"
          >
            <Menu aria-hidden className="size-5" />
            <span className="sr-only">Open navigation</span>
          </button>

          <Breadcrumbs pathname={pathname} />

          <div className="ml-auto flex items-center gap-3">
            <Link
              href={publicRoutes.home}
              className="hidden text-sm text-ink-500 hover:text-brand-700 sm:block"
            >
              View website
            </Link>

            <span
              className="flex size-8 items-center justify-center rounded-full bg-brand-100 text-xs font-semibold text-brand-800"
              title={fullName}
            >
              {initialsOf(fullName)}
            </span>
          </div>
        </header>

        <main id="admin-main" className="min-w-0 flex-1 p-4 lg:p-6">
          {children}
        </main>
      </div>
    </div>
  );
}

function AdminIdentity({
  fullName,
  email,
  role,
  onSignOut,
  signingOut,
}: {
  fullName: string;
  email: string;
  role: AdminRole;
  onSignOut: () => void;
  signingOut: boolean;
}) {
  return (
    <div className="shrink-0 border-t border-ink-800 p-3">
      <div className="flex items-center gap-2.5 rounded-lg px-2 py-1.5">
        <span className="flex size-8 shrink-0 items-center justify-center rounded-full bg-brand-600 text-xs font-semibold text-white">
          {initialsOf(fullName)}
        </span>

        <div className="min-w-0 flex-1">
          <p className="truncate text-sm font-medium text-white">{fullName}</p>
          {/* The role is shown so an operator always knows which hat they are
              wearing before taking a consequential action. */}
          <p className="truncate text-xs text-ink-400" title={email}>
            {ROLE_LABELS[role]}
          </p>
        </div>
      </div>

      <button
        type="button"
        onClick={onSignOut}
        disabled={signingOut}
        className="mt-1 flex w-full items-center gap-2.5 rounded-lg px-3 py-2 text-sm font-medium text-ink-300 transition-colors hover:bg-ink-800 hover:text-white disabled:opacity-60"
      >
        <LogOut aria-hidden className="size-4" />
        {signingOut ? 'Signing out…' : 'Sign out'}
      </button>
    </div>
  );
}

/**
 * Breadcrumbs derived from the path.
 *
 * Opaque identifiers are shown truncated rather than expanded into a name,
 * which would need a lookup per crumb on every render.
 */
function Breadcrumbs({ pathname }: { pathname: string }) {
  const prefix = process.env.NEXT_PUBLIC_ADMIN_PATH_PREFIX ?? '/admin';
  const relative = prefix && pathname.startsWith(prefix) ? pathname.slice(prefix.length) : pathname;
  const segments = relative.split('/').filter(Boolean);

  if (segments.length === 0) {
    return <span className="truncate text-sm font-medium text-ink-900">Dashboard</span>;
  }

  return (
    <nav aria-label="Breadcrumb" className="min-w-0">
      <ol className="flex min-w-0 items-center gap-1.5 text-sm">
        {segments.map((segment, index) => {
          const isLast = index === segments.length - 1;
          const href = `${prefix}/${segments.slice(0, index + 1).join('/')}`;
          const isId = /^[0-9a-f]{8}-[0-9a-f]{4}-/i.test(segment);
          const label = isId
            ? `${segment.slice(0, 8)}…`
            : segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, ' ');

          return (
            <li key={href} className="flex min-w-0 items-center gap-1.5">
              {index > 0 && (
                <ChevronRight aria-hidden className="size-3.5 shrink-0 text-ink-300" />
              )}

              {isLast ? (
                <span aria-current="page" className="truncate font-medium text-ink-900">
                  {label}
                </span>
              ) : (
                <Link href={href} className="truncate text-ink-500 hover:text-brand-700">
                  {label}
                </Link>
              )}
            </li>
          );
        })}
      </ol>
    </nav>
  );
}
