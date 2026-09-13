import type { Metadata } from 'next';
import {
  BadgeCheck,
  CreditCard,
  LifeBuoy,
  MapPin,
  Package,
  Radar,
  ShieldCheck,
  Star,
  UserCheck,
} from 'lucide-react';

import { AppCta } from '@/components/public/app-cta';
import { FeatureCard, SectionHeading, TextLink } from '@/components/public/marketing';
import { ButtonLink } from '@/components/ui/button';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'For customers',
  description:
    'Find verified skilled workers nearby, approve materials before purchase, track the job and pay digitally.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.forCustomers) },
};

export default function ForCustomersPage() {
  return (
    <>
      <section className="border-b border-ink-200 bg-gradient-to-b from-brand-50/60 to-white">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="For customers"
            title="Book a skilled professional without the guesswork"
            description="Know who is coming, what they are qualified to do, what you will pay for, and what happens if something goes wrong."
          />
          <div className="mt-8 flex flex-wrap gap-3">
            <ButtonLink href="#get-the-app" size="lg">
              Book a service
            </ButtonLink>
            <ButtonLink href={publicRoutes.howItWorks} variant="outline" size="lg">
              How it works
            </ButtonLink>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container-page">
          <SectionHeading title="What you get" align="center" />

          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <FeatureCard icon={<UserCheck aria-hidden className="size-5" />} title="Skilled workers" description="Professionals for electrical, plumbing, AC, appliance, carpentry, painting and cleaning work." />
            <FeatureCard icon={<BadgeCheck aria-hidden className="size-5" />} title="Verified profiles" description="Every profile shows exactly which checks the worker has passed and whether they are current." />
            <FeatureCard icon={<MapPin aria-hidden className="size-5" />} title="Nearby matching" description="Workers are shortlisted by trade, verification, availability, rating and distance from your address." />
            <FeatureCard icon={<Radar aria-hidden className="size-5" />} title="Job status tracking" description="Follow acceptance, travel and arrival, and confirm arrival with a short code before work starts." />
            <FeatureCard icon={<Package aria-hidden className="size-5" />} title="Material approval" description="See the estimate for any part before it is bought. You are billed the recorded actual cost, with a receipt." />
            <FeatureCard icon={<CreditCard aria-hidden className="size-5" />} title="Digital payments" description="Pay in the app after you approve the work. Payment is confirmed by the gateway, not by the app." />
            <FeatureCard icon={<Star aria-hidden className="size-5" />} title="Ratings" description="Rate every job. Ratings shape future matching, so good work is rewarded." />
            <FeatureCard icon={<LifeBuoy aria-hidden className="size-5" />} title="Support" description="Raise a support ticket about any booking, payment or account problem from the app." />
            <FeatureCard icon={<ShieldCheck aria-hidden className="size-5" />} title="Protection and claims" description="File a damage claim with evidence. Every claim is reviewed by a person against the job record." />
          </div>

          <div className="mt-8 text-center">
            <TextLink href={publicRoutes.safety}>Read about safety and protection</TextLink>
          </div>
        </div>
      </section>

      <section id="get-the-app" className="scroll-mt-24 pb-16 md:pb-24">
        <div className="container-page">
          <AppCta
            audience="customer"
            title="Book a service"
            description="Download the customer app to describe your problem and choose a verified professional."
          />
        </div>
      </section>
    </>
  );
}
