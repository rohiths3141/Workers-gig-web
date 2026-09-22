import type { Metadata } from 'next';
import Link from 'next/link';
import {
  BadgeCheck,
  ClipboardCheck,
  CreditCard,
  FileCheck2,
  Fingerprint,
  Receipt,
  ShieldCheck,
  UserCheck,
} from 'lucide-react';

import { AppCta } from '@/components/public/app-cta';
import {
  CheckList,
  FeatureCard,
  SectionHeading,
  StepList,
  TextLink,
} from '@/components/public/marketing';
import { ServiceIcon } from '@/components/shared/service-icon';
import { ButtonLink } from '@/components/ui/button';
import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import { getActiveServices } from '@/lib/data/public-content';

export const metadata: Metadata = {
  title: 'Verified electricians, plumbers and technicians for your home',
  description:
    'Book identity-verified and background-checked home service professionals. Transparent quotes, ' +
    'material approval before purchase, live job tracking and digital payment.',
  alternates: { canonical: absolutePublicUrl('/') },
};

/**
 * Homepage.
 *
 * The service grid is read from the database, so the catalogue is never
 * duplicated in JSX. If the catalogue is empty the section simply does not
 * render — the page never falls back to invented services.
 *
 * Every trust claim on this page describes a check the platform actually
 * performs and stores. There are no worker counts, no job counts, no city
 * counts and no ratings averages, because those would be fabrications until
 * there is real data behind them.
 */
export default async function HomePage() {
  const { brand } = publicEnv();
  const services = await getActiveServices();

  return (
    <>
      {/* ================================================================
          Hero
          ================================================================ */}
      <section className="border-b border-ink-200 bg-gradient-to-b from-brand-50/60 to-white">
        <div className="container-page py-16 md:py-24">
          <div className="grid items-start gap-12 lg:grid-cols-12">
            <div className="lg:col-span-7">
              <span className="inline-flex items-center gap-2 rounded-full border border-brand-200 bg-white px-3 py-1 text-xs font-medium text-brand-800">
                <ShieldCheck aria-hidden className="size-3.5" />
                Identity and background checked before any job
              </span>

              <h1 className="mt-5 text-4xl font-semibold tracking-tight text-ink-900 sm:text-5xl lg:text-[3.5rem] lg:leading-[1.05]">
                Skilled professionals for your home, verified before they arrive.
              </h1>

              <p className="mt-5 max-w-xl text-lg leading-relaxed text-ink-600">
                Electricians, plumbers, AC and appliance technicians who have passed identity and
                background verification, and hold the trade qualification their work requires. You
                see the quote before the job, and approve any material before it is bought.
              </p>

              <div className="mt-8 flex flex-wrap gap-3">
                <ButtonLink href={publicRoutes.forCustomers} size="lg">
                  Book a service
                </ButtonLink>
                <ButtonLink href={publicRoutes.forWorkers} variant="outline" size="lg">
                  Join as a worker
                </ButtonLink>
              </div>

              <p className="mt-4 text-sm text-ink-500">
                Booking happens in the {brand.name} customer app.{' '}
                <Link href={publicRoutes.howItWorks} className="underline hover:text-brand-700">
                  See how it works
                </Link>
                .
              </p>
            </div>

            {/* A plain summary of what verification means, rather than a stock
                photograph. It is the actual product differentiator. */}
            <div className="lg:col-span-5">
              <div className="rounded-2xl border border-ink-200 bg-white p-6 shadow-card">
                <h2 className="text-sm font-semibold text-ink-900">
                  What we check before a worker is eligible
                </h2>

                <dl className="mt-5 space-y-4">
                  {[
                    {
                      icon: Fingerprint,
                      term: 'Identity',
                      detail: 'A government identity document, checked against the person.',
                      required: true,
                    },
                    {
                      icon: UserCheck,
                      term: 'Background',
                      detail: 'A background verification that is renewed before it lapses.',
                      required: true,
                    },
                    {
                      icon: FileCheck2,
                      term: 'Qualification',
                      detail: 'ITI certificate or diploma, where the trade requires one.',
                      required: false,
                    },
                    {
                      icon: BadgeCheck,
                      term: 'Skill',
                      detail: 'Recognition of Prior Learning assessment, where applicable.',
                      required: false,
                    },
                  ].map(({ icon: Icon, term, detail, required }) => (
                    <div key={term} className="flex gap-3.5">
                      <span className="mt-0.5 flex size-8 shrink-0 items-center justify-center rounded-lg bg-brand-50 text-brand-700">
                        <Icon aria-hidden className="size-4" />
                      </span>
                      <div className="min-w-0">
                        <dt className="flex items-center gap-2 text-sm font-medium text-ink-900">
                          {term}
                          <span
                            className={
                              required
                                ? 'rounded-full bg-brand-50 px-1.5 py-0.5 text-[0.625rem] font-semibold uppercase tracking-wide text-brand-700'
                                : 'rounded-full bg-ink-100 px-1.5 py-0.5 text-[0.625rem] font-semibold uppercase tracking-wide text-ink-600'
                            }
                          >
                            {required ? 'All trades' : 'Where applicable'}
                          </span>
                        </dt>
                        <dd className="mt-0.5 text-sm leading-relaxed text-ink-600">{detail}</dd>
                      </div>
                    </div>
                  ))}
                </dl>

                <p className="mt-5 border-t border-ink-200 pt-4 text-xs leading-relaxed text-ink-500">
                  A profile shows only the checks that worker has actually passed and that are
                  still current. Nothing is implied beyond them.
                </p>

                <div className="mt-3">
                  <TextLink href={publicRoutes.verification}>How verification works</TextLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ================================================================
          Services
          ================================================================ */}
      {services.length > 0 && (
        <section className="section">
          <div className="container-page">
            <div className="flex flex-wrap items-end justify-between gap-4">
              <SectionHeading
                eyebrow="Services"
                title="What you can book"
                description="Each trade carries its own verification requirements, set by the work involved."
              />
              <TextLink href={publicRoutes.services}>All services</TextLink>
            </div>

            <ul className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
              {services.map((service) => (
                <li key={service.id}>
                  <Link
                    href={publicRoutes.service(service.slug)}
                    className="group flex h-full flex-col rounded-xl border border-ink-200 bg-white p-5 transition-all hover:border-brand-300 hover:shadow-card"
                  >
                    <span className="flex size-10 items-center justify-center rounded-lg bg-brand-50 text-brand-700 transition-colors group-hover:bg-brand-100">
                      <ServiceIcon iconKey={service.icon_key} />
                    </span>

                    <h3 className="mt-3.5 text-base font-semibold text-ink-900">{service.name}</h3>
                    <p className="mt-1.5 flex-1 text-sm leading-relaxed text-ink-600">
                      {service.short_description}
                    </p>

                    <span className="mt-4 text-sm font-medium text-brand-700">
                      Learn more
                      <span aria-hidden> →</span>
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </section>
      )}

      {/* ================================================================
          How it works
          ================================================================ */}
      <section className="section border-y border-ink-200 bg-ink-50">
        <div className="container-page">
          <div className="grid gap-12 lg:grid-cols-12">
            <div className="lg:col-span-5">
              <SectionHeading
                eyebrow="How it works"
                title="From a problem to a finished job"
                description="Eight steps, and you keep control of the money at every one of them."
              />

              <div className="mt-7">
                <ButtonLink href={publicRoutes.howItWorks} variant="outline">
                  See the full process
                </ButtonLink>
              </div>
            </div>

            <div className="lg:col-span-7">
              <StepList
                steps={[
                  {
                    title: 'Tell us what is wrong',
                    description:
                      'Choose the service and describe the problem. Add photographs if they help.',
                  },
                  {
                    title: 'Get matched with suitable professionals',
                    description:
                      'The platform scores nearby workers on trade, qualification, verification, availability and distance, and shows you the shortlist.',
                  },
                  {
                    title: 'Choose a worker and confirm',
                    description:
                      'You pick from the shortlist and confirm the visit. You are never assigned someone without seeing them first.',
                  },
                  {
                    title: 'Track the visit and verify arrival',
                    description:
                      'Follow the job from travel to arrival. A short code confirms the right person reached your address before work starts.',
                  },
                  {
                    title: 'Approve materials before they are bought',
                    description:
                      'If parts are needed, you see the estimate and decide. Nothing is purchased without your approval, and the receipt is recorded against the job.',
                  },
                  {
                    title: 'Approve the work, pay and rate',
                    description:
                      'Review what was done, pay through the app, and rate the professional. If the work is not right, send it back instead of approving it.',
                  },
                ]}
              />
            </div>
          </div>
        </div>
      </section>

      {/* ================================================================
          Protections
          ================================================================ */}
      <section className="section">
        <div className="container-page">
          <SectionHeading
            eyebrow="Protection"
            title="What happens when something goes wrong"
            description="Every job carries a record — who attended, when they arrived, what was done, what was bought and what was paid. That record is what a dispute is resolved against."
            align="center"
          />

          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <FeatureCard
              icon={<ClipboardCheck aria-hidden className="size-5" />}
              title="Job evidence"
              description="Before and after photographs are attached to the job, so the state of the work is not a matter of recollection."
            />
            <FeatureCard
              icon={<Receipt aria-hidden className="size-5" />}
              title="Material receipts"
              description="Materials are billed at their recorded actual cost with a receipt on file, not at the estimate."
            />
            <FeatureCard
              icon={<ShieldCheck aria-hidden className="size-5" />}
              title="Damage claims"
              description="File a claim with evidence. A person reviews it against the job record. Claims are never decided automatically."
            />
            <FeatureCard
              icon={<CreditCard aria-hidden className="size-5" />}
              title="Verified payments"
              description="A payment is recorded as successful only when the payment gateway confirms it, never on the word of the app."
            />
          </div>

          <div className="mt-8 text-center">
            <TextLink href={publicRoutes.safety}>Read about safety and protection</TextLink>
          </div>
        </div>
      </section>

      {/* ================================================================
          For workers
          ================================================================ */}
      <section className="section border-t border-ink-200 bg-ink-900">
        <div className="container-page">
          <div className="grid items-center gap-10 lg:grid-cols-2">
            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.12em] text-brand-300">
                For workers
              </p>
              <h2 className="mt-3 text-3xl font-semibold tracking-tight text-white">
                Your skill, recognised and documented.
              </h2>
              <p className="mt-4 text-base leading-relaxed text-ink-300">
                Get your qualification verified once and carry it on every job. Build a digital work
                history, receive jobs suited to your trade and location, and track exactly what you
                have earned.
              </p>

              <div className="mt-7">
                <ButtonLink href={publicRoutes.forWorkers} size="lg">
                  Become a worker
                </ButtonLink>
              </div>
            </div>

            <div className="rounded-2xl border border-ink-700 bg-ink-800 p-6">
              <h3 className="text-sm font-semibold text-white">What you get</h3>
              <CheckList
                className="mt-4 [&_li]:text-ink-300 [&_svg]:text-brand-400"
                items={[
                  'A verified profile that shows the checks you have passed',
                  'Jobs matched to your trade, qualification and travel radius',
                  'A digital record of every job you complete',
                  'Earnings tracked per job, with payouts you request yourself',
                  'Ratings that build a reputation you own',
                  'Support when a job or a customer goes wrong',
                ]}
              />
            </div>
          </div>
        </div>
      </section>

      {/* ================================================================
          App downloads
          ================================================================ */}
      <section className="section">
        <div className="container-page space-y-4">
          <AppCta
            audience="customer"
            title="Book from the customer app"
            description="Raise a request, choose your professional, track the visit, approve materials and pay — all in one place."
          />
          <AppCta
            audience="worker"
            title="Work from the worker app"
            description="Submit your documents once, receive matched jobs, record your work and manage your earnings."
          />
        </div>
      </section>

      {/* ================================================================
          Structured data
          ================================================================ */}
      <script
        type="application/ld+json"
        // Describes the organisation and the services offered. Contains only
        // facts the platform can stand behind — no ratings, no review counts.
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            '@context': 'https://schema.org',
            '@type': 'Organization',
            name: brand.name,
            url: absolutePublicUrl('/'),
            description: brand.tagline,
            contactPoint: {
              '@type': 'ContactPoint',
              contactType: 'Customer support',
              email: brand.supportEmail,
              ...(brand.supportPhone ? { telephone: brand.supportPhone } : {}),
            },
            ...(services.length > 0
              ? {
                  makesOffer: services.map((service) => ({
                    '@type': 'Offer',
                    itemOffered: {
                      '@type': 'Service',
                      name: service.name,
                      description: service.short_description,
                      url: absolutePublicUrl(publicRoutes.service(service.slug)),
                    },
                  })),
                }
              : {}),
          }),
        }}
      />
    </>
  );
}
