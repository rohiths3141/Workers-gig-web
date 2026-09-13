import type { Metadata } from 'next';
import {
  Award,
  BadgeCheck,
  FileCheck2,
  Fingerprint,
  GraduationCap,
  ShieldCheck,
  UserCheck,
} from 'lucide-react';

import { SectionHeading, TextLink } from '@/components/public/marketing';
import { Badge } from '@/components/ui/badge';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';

export const metadata: Metadata = {
  title: 'Worker verification',
  description:
    'How identity, ITI and diploma qualification, RPL skill, background and insurance checks work, and what each verification status means.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.verification) },
};

const CHECKS = [
  { icon: Fingerprint, title: 'Identity verification', scope: 'All trades', body: 'A government identity document is submitted and checked by a verification reviewer against the person registering. The document is stored privately and never shown publicly.' },
  { icon: GraduationCap, title: 'ITI certificate', scope: 'Where the trade requires it', body: 'Industrial Training Institute trade certificates are checked for trade, institute and year. Electrical and AC trades require a trade qualification.' },
  { icon: FileCheck2, title: 'Diploma', scope: 'Where applicable', body: 'Diploma certificates in a relevant discipline are accepted as a trade qualification.' },
  { icon: Award, title: 'Skill / RPL', scope: 'Where applicable', body: 'Recognition of Prior Learning assessment certificates record skill for experienced workers without formal training.' },
  { icon: UserCheck, title: 'Background verification', scope: 'All trades', body: 'A background check is required before a worker can receive jobs. It carries an expiry date and must be renewed.' },
  { icon: ShieldCheck, title: 'Insurance / protection', scope: 'Where held', body: 'Where a worker holds a policy with an insurer, the policy and its validity are recorded. Coverage decisions belong to the insurer, not to the platform.' },
] as const;

const STATUSES = [
  { label: 'Verified', tone: 'success' as const, body: 'The check was reviewed and approved, and has not expired.' },
  { label: 'Pending', tone: 'warning' as const, body: 'Documents have been submitted and are awaiting or under review.' },
  { label: 'Not yet verified', tone: 'neutral' as const, body: 'The worker has not submitted this check, or a previous approval has expired.' },
  { label: 'Not applicable', tone: 'neutral' as const, body: 'The check is not required for this worker’s trade.' },
];

/**
 * Verification explainer.
 *
 * No verification statistics appear here — no percentage of verified workers,
 * no count of checks performed. Those would need real data and would change
 * daily; a static figure on this page would be a fabrication.
 */
export default function VerificationPage() {
  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="Verification"
            title="What “verified” means on this platform"
            description="Verification is a set of individual checks, each reviewed by a person and each with its own status. A profile shows exactly which checks a worker holds — nothing is implied beyond them."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page">
          <SectionHeading title="The checks" />
          <ul className="mt-8 grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {CHECKS.map(({ icon: Icon, title, scope, body }) => (
              <li key={title} className="rounded-xl border border-ink-200 bg-white p-5">
                <div className="flex items-center justify-between gap-3">
                  <span className="flex size-10 items-center justify-center rounded-lg bg-brand-50 text-brand-700">
                    <Icon aria-hidden className="size-5" />
                  </span>
                  <Badge tone={scope === 'All trades' ? 'brand' : 'neutral'}>{scope}</Badge>
                </div>
                <h3 className="mt-3.5 text-base font-semibold text-ink-900">{title}</h3>
                <p className="mt-1.5 text-sm leading-relaxed text-ink-600">{body}</p>
              </li>
            ))}
          </ul>
        </div>
      </section>

      <section className="section border-y border-ink-200 bg-ink-50">
        <div className="container-page grid gap-10 lg:grid-cols-12">
          <div className="lg:col-span-5">
            <SectionHeading
              title="Reading a verification status"
              description="Every check on a worker profile is in one of these states."
            />
          </div>
          <dl className="grid gap-3 lg:col-span-7">
            {STATUSES.map((status) => (
              <div key={status.label} className="flex gap-4 rounded-xl border border-ink-200 bg-white p-4">
                <dt className="w-36 shrink-0">
                  <Badge tone={status.tone} dot>
                    {status.label}
                  </Badge>
                </dt>
                <dd className="text-sm leading-relaxed text-ink-600">{status.body}</dd>
              </div>
            ))}
          </dl>
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-8 lg:grid-cols-3">
          <div className="rounded-2xl border border-ink-200 bg-white p-6">
            <BadgeCheck aria-hidden className="size-6 text-brand-700" />
            <h2 className="mt-3 text-base font-semibold text-ink-900">Reviewed by people</h2>
            <p className="mt-2 text-sm leading-relaxed text-ink-600">
              No verification is approved automatically. Every decision records who made it, and a
              worker can never approve their own documents.
            </p>
          </div>
          <div className="rounded-2xl border border-ink-200 bg-white p-6">
            <ShieldCheck aria-hidden className="size-6 text-brand-700" />
            <h2 className="mt-3 text-base font-semibold text-ink-900">Documents stay private</h2>
            <p className="mt-2 text-sm leading-relaxed text-ink-600">
              Identity and qualification documents are held in private storage. Staff access is
              permission-controlled, time-limited and recorded.
            </p>
          </div>
          <div className="rounded-2xl border border-ink-200 bg-white p-6">
            <FileCheck2 aria-hidden className="size-6 text-brand-700" />
            <h2 className="mt-3 text-base font-semibold text-ink-900">Checks expire</h2>
            <p className="mt-2 text-sm leading-relaxed text-ink-600">
              Background checks and time-limited certificates lapse. When one expires it stops
              counting until it is renewed.
            </p>
            <div className="mt-3">
              <TextLink href={publicRoutes.forWorkers}>Getting verified as a worker</TextLink>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
