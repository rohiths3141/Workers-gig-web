import type { Metadata } from 'next';
import { notFound } from 'next/navigation';
import { ShieldCheck } from 'lucide-react';

import { AppCta } from '@/components/public/app-cta';
import {
  Accordion,
  CheckList,
  SectionHeading,
  StepList,
  TextLink,
} from '@/components/public/marketing';
import { ServiceIcon } from '@/components/shared/service-icon';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import { publicEnv } from '@/lib/config/env';
import {
  getActiveServices,
  getFaqsForService,
  getServiceBySlug,
  getServiceProblems,
} from '@/lib/data/public-content';

export const revalidate = 600;

const VERIFICATION_COPY: Record<string, string> = {
  IDENTITY_KYC: 'Identity verified against a government document',
  BACKGROUND_CHECK: 'Background verification completed and current',
  ITI_CERTIFICATE: 'ITI trade certificate checked',
  DIPLOMA: 'Diploma checked',
  RPL_SKILL: 'Recognition of Prior Learning skill assessment',
  INSURANCE: 'Insurance policy on record',
};

/** Pre-render one page per active service. Unknown slugs 404. */
export async function generateStaticParams() {
  const services = await getActiveServices();
  return services.map((service) => ({ slug: service.slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const service = await getServiceBySlug(slug);

  if (!service) return { title: 'Service not found', robots: { index: false } };

  const title = service.seo_title ?? `${service.name} services`;
  const description = service.seo_description ?? service.short_description;
  const url = absolutePublicUrl(publicRoutes.service(service.slug));

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url, type: 'website' },
    twitter: { title, description },
  };
}

/**
 * Service detail.
 *
 * Content is the service's own record plus its problems and FAQs. There is no
 * "N professionals available" figure: availability depends on the customer's
 * location and time, and a static number here would be invented.
 */
export default async function ServiceDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const service = await getServiceBySlug(slug);

  if (!service) notFound();

  const [problems, faqs] = await Promise.all([
    getServiceProblems(service.id),
    getFaqsForService(service.id),
  ]);

  const { brand } = publicEnv();

  return (
    <>
      <section className="border-b border-ink-200 bg-gradient-to-b from-brand-50/60 to-white">
        <div className="container-page py-14 md:py-20">
          <nav aria-label="Breadcrumb" className="mb-6 text-sm text-ink-500">
            <ol className="flex items-center gap-1.5">
              <li>
                <a href={publicRoutes.services} className="hover:text-brand-700">
                  Services
                </a>
              </li>
              <li aria-hidden>/</li>
              <li aria-current="page" className="text-ink-900">
                {service.name}
              </li>
            </ol>
          </nav>

          <div className="flex items-start gap-5">
            <span className="hidden size-14 shrink-0 items-center justify-center rounded-2xl bg-brand-700 text-white sm:flex">
              <ServiceIcon iconKey={service.icon_key} className="size-7" />
            </span>
            <SectionHeading
              as="h1"
              title={service.name}
              description={service.description ?? service.short_description}
            />
          </div>
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="space-y-12 lg:col-span-7">
            {problems.length > 0 && (
              <div>
                <h2 className="text-xl font-semibold text-ink-900">Common problems we handle</h2>
                <ul className="mt-5 grid gap-3 sm:grid-cols-2">
                  {problems.map((problem) => (
                    <li key={problem.id} className="rounded-xl border border-ink-200 bg-white p-4">
                      <h3 className="text-sm font-semibold text-ink-900">{problem.title}</h3>
                      {problem.description && (
                        <p className="mt-1.5 text-sm leading-relaxed text-ink-600">
                          {problem.description}
                        </p>
                      )}
                    </li>
                  ))}
                </ul>
              </div>
            )}

            <div>
              <h2 className="text-xl font-semibold text-ink-900">How a {service.name.toLowerCase()} job works</h2>
              <StepList
                className="mt-6"
                steps={[
                  { title: 'Describe the problem', description: 'Tell us what is wrong in the app, with photographs if they help the professional prepare.' },
                  { title: 'Choose from matched professionals', description: `Only workers who hold the checks required for ${service.name.toLowerCase()} work are shortlisted.` },
                  { title: 'Diagnosis and quote', description: 'The professional inspects the problem and quotes before any work begins.' },
                  { title: 'Approve materials', description: 'If parts are needed you see the estimate first. Nothing is bought without your approval.' },
                  { title: 'Approve, pay and rate', description: 'Review the completed work, pay in the app, and rate the job.' },
                ]}
              />
            </div>

            {faqs.length > 0 && (
              <div>
                <h2 className="text-xl font-semibold text-ink-900">Questions about {service.name.toLowerCase()}</h2>
                <Accordion
                  className="mt-5"
                  items={faqs.map((faq) => ({ id: faq.id, question: faq.question, answer: faq.answer }))}
                />
              </div>
            )}
          </div>

          <aside className="lg:col-span-5">
            <div className="rounded-2xl border border-ink-200 bg-white p-6 shadow-card lg:sticky lg:top-24">
              <div className="flex items-center gap-2 text-brand-800">
                <ShieldCheck aria-hidden className="size-5" />
                <h2 className="text-sm font-semibold">Required for every {service.name.toLowerCase()} professional</h2>
              </div>

              <CheckList
                className="mt-4"
                items={service.required_verifications.map(
                  (check) => VERIFICATION_COPY[check] ?? check,
                )}
              />

              <p className="mt-5 border-t border-ink-200 pt-4 text-xs leading-relaxed text-ink-500">
                These are the minimum checks for this trade. A professional&apos;s profile shows
                every check they hold and when it expires.
              </p>

              <div className="mt-3 flex flex-col gap-2">
                <TextLink href={publicRoutes.verification}>How verification works</TextLink>
                <TextLink href={publicRoutes.safety}>Safety and damage claims</TextLink>
              </div>
            </div>
          </aside>
        </div>
      </section>

      <section className="pb-16 md:pb-24">
        <div className="container-page">
          <AppCta
            audience="customer"
            title={`Book ${service.name.toLowerCase()} with ${brand.name}`}
            description="Describe the problem in the customer app and choose from suitable verified professionals nearby."
          />
        </div>
      </section>

      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            '@context': 'https://schema.org',
            '@type': 'Service',
            name: service.name,
            description: service.description ?? service.short_description,
            serviceType: service.name,
            provider: { '@type': 'Organization', name: brand.name, url: absolutePublicUrl('/') },
            url: absolutePublicUrl(publicRoutes.service(service.slug)),
            areaServed: { '@type': 'Country', name: 'India' },
          }),
        }}
      />

      {faqs.length > 0 && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              '@context': 'https://schema.org',
              '@type': 'FAQPage',
              mainEntity: faqs.map((faq) => ({
                '@type': 'Question',
                name: faq.question,
                acceptedAnswer: { '@type': 'Answer', text: faq.answer },
              })),
            }),
          }}
        />
      )}
    </>
  );
}
