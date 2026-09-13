import type { Metadata } from 'next';

import { AppCta } from '@/components/public/app-cta';
import { SectionHeading, StepList, TextLink } from '@/components/public/marketing';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'How it works',
  description:
    'From describing the problem to rating the job: how matching, arrival verification, material approval and payment work.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.howItWorks) },
};

const CUSTOMER_STEPS = [
  {
    title: '1. Choose a service',
    description: 'Pick the trade you need — electrical, plumbing, AC service, appliance repair and more.',
  },
  {
    title: '2. Tell us what you need',
    description:
      'Describe the problem, confirm the address and a preferred time. Photographs help the professional arrive prepared.',
  },
  {
    title: '3. Get matched with suitable workers',
    description:
      'The matching engine considers trade, qualification, identity and background verification, availability, rating and distance. Workers without the checks your trade requires are never shortlisted.',
  },
  {
    title: '4. Select a worker',
    description:
      'You see the shortlist with each worker’s verified checks and rating, and choose who you want. Nobody is assigned without your say.',
  },
  {
    title: '5. Track the job',
    description:
      'Follow the job as the worker accepts, travels and arrives. A short arrival code confirms the right person reached your door before work starts.',
  },
  {
    title: '6. Approve materials if required',
    description:
      'If parts are needed the worker raises a material request with an estimate. You approve or reject it. The actual cost is recorded with a receipt.',
  },
  {
    title: '7. Complete payment',
    description:
      'Approve the finished work and pay in the app. The payment is confirmed only when the payment gateway verifies it.',
  },
  {
    title: '8. Rate the service',
    description:
      'Rate the professional. Workers rate customers too, which keeps the platform fair for both sides.',
  },
] as const;

/**
 * How it works.
 *
 * Describes the booking lifecycle as the platform actually enforces it — the
 * same sequence as public.booking_transitions. It does not describe features
 * that are not built.
 */
export default function HowItWorksPage() {
  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="How it works"
            title="Eight steps from a problem to a finished job"
            description="You stay in control at the moments that matter: who comes to your home, what gets bought, and when you pay."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-7">
            <StepList steps={CUSTOMER_STEPS} />
          </div>

          <aside className="space-y-4 lg:col-span-5">
            <div className="rounded-2xl border border-ink-200 bg-white p-6">
              <h2 className="text-base font-semibold text-ink-900">If the work is not right</h2>
              <p className="mt-2 text-sm leading-relaxed text-ink-600">
                When the worker marks the job complete you can send it back for more work instead of
                approving it, or raise a dispute. Payment is not requested until you approve.
              </p>
            </div>

            <div className="rounded-2xl border border-ink-200 bg-white p-6">
              <h2 className="text-base font-semibold text-ink-900">If something is damaged</h2>
              <p className="mt-2 text-sm leading-relaxed text-ink-600">
                File a damage claim with photographs. A person reviews it against the job record —
                arrival time, before and after evidence, and materials used.
              </p>
              <div className="mt-3">
                <TextLink href={publicRoutes.safety}>Safety and claims</TextLink>
              </div>
            </div>

            <div className="rounded-2xl border border-ink-200 bg-white p-6">
              <h2 className="text-base font-semibold text-ink-900">Are you a skilled worker?</h2>
              <p className="mt-2 text-sm leading-relaxed text-ink-600">
                The worker journey — registration, verification, receiving jobs and payouts — is
                described separately.
              </p>
              <div className="mt-3">
                <TextLink href={publicRoutes.forWorkers}>For workers</TextLink>
              </div>
            </div>
          </aside>
        </div>
      </section>

      <section className="pb-16 md:pb-24">
        <div className="container-page">
          <AppCta
            audience="customer"
            title="Start with the customer app"
            description="Every step above happens in the app, from describing the problem to rating the job."
          />
        </div>
      </section>
    </>
  );
}
