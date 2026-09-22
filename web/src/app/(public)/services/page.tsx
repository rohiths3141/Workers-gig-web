import type { Metadata } from 'next';
import Link from 'next/link';
import { ShieldCheck } from 'lucide-react';

import { AppCta } from '@/components/public/app-cta';
import { SectionHeading } from '@/components/public/marketing';
import { ServiceIcon } from '@/components/shared/service-icon';
import { EmptyState } from '@/components/ui/feedback';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import { getActiveServices } from '@/lib/data/public-content';
import { humaniseEnum } from '@/lib/utils/format';

export const metadata: Metadata = {
  title: 'Home services',
  description:
    'Electrical, plumbing, AC service, appliance repair, carpentry, painting, cleaning and more — booked with verified professionals.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.services) },
};

// The catalogue changes rarely; regenerate at most every 10 minutes.
export const revalidate = 600;

const VERIFICATION_SHORT: Record<string, string> = {
  IDENTITY_KYC: 'Identity',
  BACKGROUND_CHECK: 'Background',
  ITI_CERTIFICATE: 'ITI certificate',
  DIPLOMA: 'Diploma',
  RPL_SKILL: 'RPL skill',
  INSURANCE: 'Insurance',
};

/**
 * Service catalogue.
 *
 * Rendered from public.services. Each card lists the checks that trade
 * requires, straight from the service's required_verifications column, so the
 * page cannot promise a check the platform does not enforce for that trade.
 */
export default async function ServicesPage() {
  const services = await getActiveServices();

  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="Services"
            title="Home services, with verification that fits the work"
            description="Every trade requires identity and background verification. Trades that carry more risk, such as electrical and AC work, also require a trade qualification."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page">
          {services.length === 0 ? (
            <EmptyState
              title="The service catalogue is not available right now"
              description="Please check back shortly, or contact support if you need help booking."
            />
          ) : (
            <ul className="grid gap-5 md:grid-cols-2">
              {services.map((service) => (
                <li key={service.id}>
                  <Link
                    href={publicRoutes.service(service.slug)}
                    className="group flex h-full gap-4 rounded-xl border border-ink-200 bg-white p-6 transition-all hover:border-brand-300 hover:shadow-card"
                  >
                    <span className="flex size-12 shrink-0 items-center justify-center rounded-xl bg-brand-50 text-brand-700 group-hover:bg-brand-100">
                      <ServiceIcon iconKey={service.icon_key} className="size-6" />
                    </span>

                    <div className="min-w-0">
                      <h2 className="text-lg font-semibold text-ink-900">{service.name}</h2>
                      <p className="mt-1.5 text-sm leading-relaxed text-ink-600">
                        {service.short_description}
                      </p>

                      <div className="mt-4 flex flex-wrap items-center gap-1.5">
                        <ShieldCheck aria-hidden className="size-3.5 text-brand-600" />
                        <span className="sr-only">Required checks:</span>
                        {service.required_verifications.map((check) => (
                          <span
                            key={check}
                            className="rounded-full bg-ink-100 px-2 py-0.5 text-xs text-ink-700"
                          >
                            {VERIFICATION_SHORT[check] ?? humaniseEnum(check)}
                          </span>
                        ))}
                      </div>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>

      <section className="pb-16 md:pb-24">
        <div className="container-page">
          <AppCta
            audience="customer"
            title="Ready to book?"
            description="Choose your service in the customer app and get matched with suitable verified professionals nearby."
          />
        </div>
      </section>
    </>
  );
}
