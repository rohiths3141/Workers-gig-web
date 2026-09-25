import Link from 'next/link';
import { Mail, Phone } from 'lucide-react';

import { BrandLogo } from '@/components/shared/brand-logo';
import { publicEnv } from '@/lib/config/env';
import { publicRoutes } from '@/lib/config/routes';

/**
 * Public website footer.
 *
 * Contact details come from environment configuration, and a value that has not
 * been provided is simply not rendered. Nothing here invents a phone number, an
 * address, or an app store link.
 *
 * There is deliberately no link to /admin.
 */

const SECTIONS = [
  {
    heading: 'Platform',
    links: [
      { href: publicRoutes.services, label: 'Services' },
      { href: publicRoutes.howItWorks, label: 'How it works' },
      { href: publicRoutes.forCustomers, label: 'For customers' },
      { href: publicRoutes.forWorkers, label: 'For workers' },
      { href: publicRoutes.download, label: 'Download the apps' },
      { href: publicRoutes.verification, label: 'Verification' },
      { href: publicRoutes.safety, label: 'Safety' },
    ],
  },
  {
    heading: 'Company',
    links: [
      { href: publicRoutes.about, label: 'About' },
      { href: publicRoutes.contact, label: 'Contact' },
      { href: publicRoutes.faq, label: 'FAQ' },
    ],
  },
  {
    heading: 'Legal',
    links: [
      { href: publicRoutes.privacy, label: 'Privacy policy' },
      { href: publicRoutes.terms, label: 'Terms of service' },
      { href: publicRoutes.cancellationPolicy, label: 'Cancellation policy' },
      { href: publicRoutes.refundPolicy, label: 'Refund policy' },
    ],
  },
] as const;

export function SiteFooter() {
  const { brand } = publicEnv();
  const year = new Date().getFullYear();

  return (
    <footer className="border-t border-ink-200 bg-ink-50">
      <div className="container-page py-12 md:py-16">
        <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-5">
          <div className="lg:col-span-2">
            <BrandLogo name={brand.name} />

            <p className="mt-3 max-w-sm text-sm leading-relaxed text-ink-600">
              {brand.tagline}. Every professional completes identity and background verification
              before they are eligible for work.
            </p>

            <div className="mt-5 space-y-2 text-sm">
              <a
                href={`mailto:${brand.supportEmail}`}
                className="flex items-center gap-2 text-ink-600 hover:text-brand-700"
              >
                <Mail aria-hidden className="size-4" />
                {brand.supportEmail}
              </a>

              {brand.supportPhone && (
                <a
                  href={`tel:${brand.supportPhone.replace(/\s/g, '')}`}
                  className="flex items-center gap-2 text-ink-600 hover:text-brand-700"
                >
                  <Phone aria-hidden className="size-4" />
                  {brand.supportPhone}
                </a>
              )}
            </div>
          </div>

          {SECTIONS.map((section) => (
            <nav key={section.heading} aria-label={section.heading}>
              <h2 className="text-xs font-semibold uppercase tracking-wide text-ink-900">
                {section.heading}
              </h2>
              <ul className="mt-3.5 space-y-2.5">
                {section.links.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="text-sm text-ink-600 transition-colors hover:text-brand-700"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </nav>
          ))}
        </div>

        <div className="mt-10 flex flex-col gap-3 border-t border-ink-200 pt-6 sm:flex-row sm:items-center sm:justify-between">
          <p className="text-xs text-ink-500">
            &copy; {year} {brand.legalEntityName ?? brand.name}. All rights reserved.
          </p>

          {brand.businessAddress && (
            <p className="text-xs text-ink-500">{brand.businessAddress}</p>
          )}
        </div>

        {brand.grievanceEmail && (
          <p className="mt-3 text-xs text-ink-500">
            Grievance officer:{' '}
            <a href={`mailto:${brand.grievanceEmail}`} className="underline hover:text-brand-700">
              {brand.grievanceEmail}
            </a>
          </p>
        )}
      </div>
    </footer>
  );
}
