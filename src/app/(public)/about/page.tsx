import type { Metadata } from 'next';

import { AppCta } from '@/components/public/app-cta';
import { SectionHeading, TextLink } from '@/components/public/marketing';
import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'About',
  description:
    'Why the platform exists: connecting households with skilled, verified home-service professionals, and giving skilled workers recognition and fair access to work.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.about) },
};

/**
 * About.
 *
 * Deliberately contains no figures: no worker count, customer count, cities
 * served, founding year, funding, partnerships or government affiliation. None
 * has been provided, and inventing any of them would undermine the one thing
 * this product is selling, which is trust.
 */
export default function AboutPage() {
  const { brand } = publicEnv();

  const blocks = [
    {
      title: 'The problem',
      body: 'Finding someone to fix a wiring fault or a leaking pipe usually means a phone number passed on by a neighbour. There is rarely a way to know who is coming, whether they are trained for the work, what the job should cost, or what happens if something goes wrong. Meanwhile many skilled workers — including ITI-trained technicians and experienced tradespeople certified through Recognition of Prior Learning — have no way to prove that skill to a stranger.',
    },
    {
      title: 'The solution',
      body: `${brand.name} connects the two with verification at the centre. Workers are checked for identity and background before they can take any job, and for trade qualifications where the work demands it. Customers see those checks, approve costs before they are incurred, and have a structured way to resolve problems.`,
    },
    {
      title: 'Trust',
      body: 'Trust here is a record, not a slogan. Every verification decision records who made it. Every job records who arrived and when, what was bought and at what cost, and what was paid. A dispute is settled against that record.',
    },
    {
      title: 'A skilled workforce',
      body: 'Formal qualifications and experience-based skill certification should count for something with customers. Verified credentials are shown on a worker’s profile and considered when matching them to jobs, so the investment a worker made in their training carries through to the work they are offered.',
    },
    {
      title: 'Technology',
      body: 'Matching, verification decisions, payments and wallet balances are all handled on the server, where the rules cannot be bypassed from an app. Payments are confirmed by the payment gateway, wallet balances are derived from a ledger that cannot be edited, and sensitive documents are held privately with every access recorded.',
    },
    {
      title: 'Customer experience',
      body: 'Booking should be simple: describe the problem, choose a professional, follow the visit, approve materials, pay and rate. The complexity of verification and protection stays behind the scenes until you need it.',
    },
  ];

  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="About"
            title={`Our mission: make it safe to let a skilled professional into your home`}
            description={`${brand.name} exists to connect households with verified skilled workers, and to give those workers the recognition and fair access to work that their skills deserve.`}
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-x-12 gap-y-10 md:grid-cols-2">
          {blocks.map((block) => (
            <div key={block.title}>
              <h2 className="text-xl font-semibold text-ink-900">{block.title}</h2>
              <p className="mt-3 text-base leading-relaxed text-ink-600">{block.body}</p>
            </div>
          ))}
        </div>

        <div className="container-page mt-12 flex flex-wrap gap-6">
          <TextLink href={publicRoutes.verification}>How verification works</TextLink>
          <TextLink href={publicRoutes.contact}>Contact us</TextLink>
        </div>
      </section>

      <section className="pb-16 md:pb-24">
        <div className="container-page space-y-4">
          <AppCta audience="customer" title="Book a service" description="Find a verified professional in the customer app." />
          <AppCta audience="worker" title="Join as a worker" description="Get verified and start receiving jobs in the worker app." />
        </div>
      </section>
    </>
  );
}
