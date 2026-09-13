import type { Metadata } from 'next';
import {
  Award,
  BadgeCheck,
  Briefcase,
  FileClock,
  LifeBuoy,
  ShieldCheck,
  Star,
  Users,
  Wallet,
} from 'lucide-react';

import { AppCta } from '@/components/public/app-cta';
import { FeatureCard, SectionHeading, StepList, TextLink } from '@/components/public/marketing';
import { ButtonLink } from '@/components/ui/button';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'For workers',
  description:
    'Register, verify your identity and ITI/diploma or RPL qualification, receive suitable jobs, and track your earnings and payouts.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.forWorkers) },
};

const JOURNEY = [
  { title: 'Register', description: 'Sign up in the worker app with your mobile number or Google account.' },
  { title: 'Submit KYC', description: 'Upload a government identity document. It is stored privately and seen only by authorised verification staff.' },
  { title: 'Submit qualifications', description: 'Add your ITI certificate, diploma or RPL skill certificate where you have one. Some trades require a qualification.' },
  { title: 'Complete verification', description: 'Each document is reviewed by a person. If something needs correcting you are told exactly what, in the app.' },
  { title: 'Build your profile', description: 'Set your trade, experience, and how far you are willing to travel.' },
  { title: 'Become available', description: 'Switch to available when you are ready to take work.' },
  { title: 'Receive suitable jobs', description: 'Jobs are offered to you based on your trade, verification, location and availability.' },
  { title: 'Complete jobs', description: 'Record arrival, before and after evidence, and any materials used.' },
  { title: 'Earn money', description: 'Your share of each paid job is credited to your wallet, with a line for every entry.' },
  { title: 'Request payout', description: 'Withdraw your balance to your bank account whenever it clears the holding period.' },
] as const;

export default function ForWorkersPage() {
  return (
    <>
      <section className="border-b border-ink-800 bg-ink-900">
        <div className="container-page py-14 md:py-20">
          <p className="text-xs font-semibold uppercase tracking-[0.12em] text-brand-300">For workers</p>
          <h1 className="mt-3 max-w-3xl text-3xl font-semibold tracking-tight text-white sm:text-4xl lg:text-5xl">
            Your skill, verified once and recognised on every job.
          </h1>
          <p className="mt-5 max-w-2xl text-lg leading-relaxed text-ink-300">
            Get your identity and qualification verified, receive jobs suited to your trade and
            location, and see exactly what you have earned.
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <ButtonLink href="#get-the-app" size="lg">
              Become a worker
            </ButtonLink>
            <ButtonLink href={publicRoutes.verification} variant="outline" size="lg" className="border-ink-600 bg-transparent text-white hover:bg-ink-800">
              What verification involves
            </ButtonLink>
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-6">
            <SectionHeading eyebrow="The journey" title="From registration to your first payout" />
            <StepList className="mt-8" steps={JOURNEY} />
          </div>

          <div className="lg:col-span-6">
            <SectionHeading eyebrow="Benefits" title="What you get" />
            <div className="mt-8 grid gap-4 sm:grid-cols-2">
              <FeatureCard icon={<Users aria-hidden className="size-5" />} title="Access to customers" description="Customers nearby who need your trade." />
              <FeatureCard icon={<BadgeCheck aria-hidden className="size-5" />} title="Verified profile" description="Your passed checks are shown on your profile." />
              <FeatureCard icon={<Award aria-hidden className="size-5" />} title="Skill recognition" description="ITI, diploma and RPL credentials are recorded and displayed." />
              <FeatureCard icon={<Briefcase aria-hidden className="size-5" />} title="Job opportunities" description="Jobs offered to you by trade, location and availability." />
              <FeatureCard icon={<Wallet aria-hidden className="size-5" />} title="Earnings tracking" description="Every credit and payout recorded in your wallet." />
              <FeatureCard icon={<FileClock aria-hidden className="size-5" />} title="Digital job history" description="A record of every job you complete." />
              <FeatureCard icon={<Star aria-hidden className="size-5" />} title="Ratings" description="Build a reputation that follows your work." />
              <FeatureCard icon={<LifeBuoy aria-hidden className="size-5" />} title="Support" description="Help when a job, payment or customer goes wrong." />
              <FeatureCard icon={<ShieldCheck aria-hidden className="size-5" />} title="Protection" description="Insurance is recorded on your profile where you hold a policy." className="sm:col-span-2" />
            </div>
            <p className="mt-4 text-xs leading-relaxed text-ink-500">
              The platform does not itself provide insurance. Where a worker holds a policy with an
              insurer, it is recorded and its validity is shown.
            </p>
            <div className="mt-4">
              <TextLink href={publicRoutes.faq}>Worker FAQs</TextLink>
            </div>
          </div>
        </div>
      </section>

      <section id="get-the-app" className="scroll-mt-24 pb-16 md:pb-24">
        <div className="container-page">
          <AppCta
            audience="worker"
            title="Become a worker"
            description="Register in the worker app and submit your documents to start verification."
          />
        </div>
      </section>
    </>
  );
}
