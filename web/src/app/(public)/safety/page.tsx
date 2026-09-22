import type { Metadata } from 'next';
import {
  Camera,
  ClipboardCheck,
  Fingerprint,
  KeyRound,
  LifeBuoy,
  Star,
  UserCheck,
} from 'lucide-react';

import { FeatureCard, SectionHeading, StepList, TextLink } from '@/components/public/marketing';
import { Alert } from '@/components/ui/feedback';
import { publicEnv } from '@/lib/config/env';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Safety and protection',
  description:
    'Worker verification, arrival verification, job evidence, two-way ratings, support and the damage claim process.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.safety) },
};

export default function SafetyPage() {
  const { brand } = publicEnv();

  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="Safety"
            title="Safety is built into the job, not added afterwards"
            description="Who comes to your home is checked before they can work, their arrival is confirmed at your door, and every job leaves a record that disputes are resolved against."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page">
          <SectionHeading title="Before, during and after a job" />
          <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <FeatureCard icon={<Fingerprint aria-hidden className="size-5" />} title="Identity verification" description="Every worker’s identity is checked against a government document before they are eligible for jobs." />
            <FeatureCard icon={<UserCheck aria-hidden className="size-5" />} title="Background verification" description="A current background check is required for every trade, and lapses must be renewed." />
            <FeatureCard icon={<ClipboardCheck aria-hidden className="size-5" />} title="Qualification verification" description="Higher-risk trades require an ITI certificate, diploma or equivalent on file." />
            <FeatureCard icon={<KeyRound aria-hidden className="size-5" />} title="Arrival verification" description="A code you share at the door confirms the matched worker has arrived before work can start." />
            <FeatureCard icon={<Camera aria-hidden className="size-5" />} title="Job evidence" description="Before and after photographs are attached to the job and kept privately with the booking." />
            <FeatureCard icon={<Star aria-hidden className="size-5" />} title="Customer ratings" description="Customers rate every job, and ratings feed into future matching." />
            <FeatureCard icon={<Star aria-hidden className="size-5" />} title="Worker ratings" description="Workers rate customers too, so the platform stays safe for the people doing the work." />
            <FeatureCard icon={<LifeBuoy aria-hidden className="size-5" />} title="Support" description="Open a support ticket about any booking from the app, and follow the conversation there." />
          </div>
        </div>
      </section>

      <section className="section border-y border-ink-200 bg-ink-50">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-5">
            <SectionHeading
              eyebrow="Damage claims"
              title="If something is damaged"
              description="Claims are reviewed by the trust and safety team. No claim is approved or rejected automatically, and every decision records its reasoning."
            />
            <p className="mt-5 text-sm leading-relaxed text-ink-600">
              Where a worker holds insurance, a claim may also be referred to the insurer. The
              insurer’s decision on coverage is separate from, and not determined by, the outcome of
              the claim on this platform.
            </p>
          </div>
          <div className="lg:col-span-7">
            <StepList
              steps={[
                { title: 'Report it from the booking', description: 'Open the job in the customer app and file a damage claim with a description of what happened.' },
                { title: 'Add evidence', description: 'Upload photographs or video. Evidence is stored privately and seen only by the parties and authorised staff.' },
                { title: 'Review', description: 'A reviewer compares your claim with the job record — arrival, before and after evidence, and materials.' },
                { title: 'More information, if needed', description: 'If the reviewer needs something else, you are asked directly on the claim.' },
                { title: 'Decision', description: 'The claim is approved, partially approved or rejected, with the reason recorded and shared with you.' },
              ]}
            />
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container-page max-w-3xl">
          <SectionHeading eyebrow="Emergencies" title="In an emergency" />
          <Alert tone="danger" title="Call emergency services first" className="mt-6">
            If anyone is in immediate danger, call 112 (India’s national emergency number) before
            anything else. Then contact {brand.name} support so the booking can be flagged and the
            worker account reviewed.
          </Alert>
          <p className="mt-4 text-sm leading-relaxed text-ink-600">
            In-app emergency assistance, such as sharing a live job location with a trusted contact,
            is planned but not yet available. Until it is, use the steps above.
          </p>
          <div className="mt-5 flex flex-wrap gap-5">
            <TextLink href={publicRoutes.contact}>Contact support</TextLink>
            <TextLink href={publicRoutes.verification}>How verification works</TextLink>
          </div>
        </div>
      </section>
    </>
  );
}
