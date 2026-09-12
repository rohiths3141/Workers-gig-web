'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Menu, ShieldCheck, X } from 'lucide-react';

import { ButtonLink } from '@/components/ui/button';
import { publicRoutes } from '@/lib/config/routes';
import { cn } from '@/lib/utils/cn';

/**
 * Public website header.
 *
 * Note what is absent: there is no link to the admin panel. The admin surface is
 * reachable by people who know the URL and hold an administrator account; it is
 * not advertised to every visitor, and the public navigation has no awareness of
 * it at all.
 */

const NAV_ITEMS = [
  { href: publicRoutes.services, label: 'Services' },
  { href: publicRoutes.howItWorks, label: 'How it works' },
  { href: publicRoutes.forCustomers, label: 'For customers' },
  { href: publicRoutes.forWorkers, label: 'For workers' },
  { href: publicRoutes.safety, label: 'Safety' },
  { href: publicRoutes.about, label: 'About' },
  { href: publicRoutes.faq, label: 'FAQ' },
] as const;

export function SiteHeader({ brandName }: { brandName: string }) {
  const pathname = usePathname();
  const [menuOpen, setMenuOpen] = useState(false);

  // Any navigation closes the mobile menu, including a browser back.
  useEffect(() => {
    setMenuOpen(false);
  }, [pathname]);

  // A menu that covers the page must not leave the page scrolling behind it.
  useEffect(() => {
    document.body.style.overflow = menuOpen ? 'hidden' : '';
    return () => {
      document.body.style.overflow = '';
    };
  }, [menuOpen]);

  const isActive = (href: string) =>
    href === publicRoutes.home ? pathname === href : pathname.startsWith(href);

  return (
    <header className="sticky top-0 z-40 border-b border-ink-200 bg-white/95 backdrop-blur-sm">
      <div className="container-page">
        <div className="flex h-16 items-center justify-between gap-4">
          <Link
            href={publicRoutes.home}
            className="flex shrink-0 items-center gap-2 text-lg font-semibold tracking-tight text-ink-900"
          >
            <span className="flex size-8 items-center justify-center rounded-lg bg-brand-700 text-white">
              <ShieldCheck aria-hidden className="size-4.5" />
            </span>
            {brandName}
          </Link>

          <nav aria-label="Primary" className="hidden lg:block">
            <ul className="flex items-center gap-1">
              {NAV_ITEMS.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    aria-current={isActive(item.href) ? 'page' : undefined}
                    className={cn(
                      'rounded-lg px-3 py-2 text-sm font-medium transition-colors',
                      isActive(item.href)
                        ? 'bg-brand-50 text-brand-800'
                        : 'text-ink-600 hover:bg-ink-100 hover:text-ink-900',
                    )}
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>

          <div className="hidden shrink-0 items-center gap-2 lg:flex">
            <ButtonLink href={publicRoutes.forWorkers} variant="ghost" size="sm">
              Join as a worker
            </ButtonLink>
            <ButtonLink href={publicRoutes.forCustomers} size="sm">
              Book a service
            </ButtonLink>
          </div>

          <button
            type="button"
            onClick={() => setMenuOpen((open) => !open)}
            aria-expanded={menuOpen}
            aria-controls="mobile-navigation"
            className="-mr-2 rounded-lg p-2 text-ink-700 hover:bg-ink-100 lg:hidden"
          >
            {menuOpen ? <X aria-hidden className="size-5" /> : <Menu aria-hidden className="size-5" />}
            <span className="sr-only">{menuOpen ? 'Close menu' : 'Open menu'}</span>
          </button>
        </div>
      </div>

      {menuOpen && (
        <div
          id="mobile-navigation"
          className="border-t border-ink-200 bg-white lg:hidden"
        >
          <nav aria-label="Primary mobile" className="container-page py-3">
            <ul className="space-y-0.5">
              {NAV_ITEMS.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    aria-current={isActive(item.href) ? 'page' : undefined}
                    className={cn(
                      'block rounded-lg px-3 py-2.5 text-sm font-medium',
                      isActive(item.href)
                        ? 'bg-brand-50 text-brand-800'
                        : 'text-ink-700 hover:bg-ink-100',
                    )}
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>

            <div className="mt-4 grid gap-2 border-t border-ink-200 pt-4">
              <ButtonLink href={publicRoutes.forCustomers} fullWidth>
                Book a service
              </ButtonLink>
              <ButtonLink href={publicRoutes.forWorkers} variant="outline" fullWidth>
                Join as a worker
              </ButtonLink>
            </div>
          </nav>
        </div>
      )}
    </header>
  );
}
