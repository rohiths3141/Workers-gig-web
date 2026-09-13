import type { Metadata } from 'next';

import { Accordion, SectionHeading, TextLink } from '@/components/public/marketing';
import { EmptyState } from '@/components/ui/feedback';
import { absolutePublicUrl, publicRoutes } from '@/lib/config/routes';
import { getGeneralFaqs } from '@/lib/data/public-content';

export const metadata: Metadata = {
  title: 'Frequently asked questions',
  description:
    'Answers about booking, payments, materials, worker verification, safety, damage claims, insurance and accounts.',
  alternates: { canonical: absolutePublicUrl(publicRoutes.faq) },
};

export const revalidate = 600;

function anchorFor(category: string): string {
  return category.toLowerCase().replace(/[^a-z0-9]+/g, '-');
}

/** FAQs are read from public.faqs and grouped by category. */
export default async function FaqPage() {
  const groups = await getGeneralFaqs();

  return (
    <>
      <section className="border-b border-ink-200 bg-ink-50">
        <div className="container-page py-14 md:py-20">
          <SectionHeading
            as="h1"
            eyebrow="FAQ"
            title="Frequently asked questions"
            description="If your question is not answered here, contact support."
          />
        </div>
      </section>

      <section className="section">
        <div className="container-page grid gap-10 lg:grid-cols-12">
          {groups.length === 0 ? (
            <div className="lg:col-span-12">
              <EmptyState
                title="FAQs are not available right now"
                description="Please try again shortly, or contact support with your question."
              />
            </div>
          ) : (
            <>
              <nav aria-label="FAQ categories" className="lg:col-span-3">
                <ul className="flex flex-wrap gap-2 lg:sticky lg:top-24 lg:flex-col lg:gap-1">
                  {groups.map((group) => (
                    <li key={group.category}>
                      <a
                        href={`#${anchorFor(group.category)}`}
                        className="block rounded-lg px-3 py-2 text-sm text-ink-600 hover:bg-ink-100 hover:text-ink-900"
                      >
                        {group.category}
                      </a>
                    </li>
                  ))}
                </ul>
              </nav>

              <div className="space-y-10 lg:col-span-9">
                {groups.map((group) => (
                  <section key={group.category} id={anchorFor(group.category)} className="scroll-mt-24">
                    <h2 className="text-xl font-semibold text-ink-900">{group.category}</h2>
                    <Accordion
                      className="mt-4"
                      items={group.items.map((faq) => ({ id: faq.id, question: faq.question, answer: faq.answer }))}
                    />
                  </section>
                ))}

                <TextLink href={publicRoutes.contact}>Still have a question? Contact support</TextLink>
              </div>
            </>
          )}
        </div>
      </section>

      {groups.length > 0 && (
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              '@context': 'https://schema.org',
              '@type': 'FAQPage',
              mainEntity: groups.flatMap((group) =>
                group.items.map((faq) => ({
                  '@type': 'Question',
                  name: faq.question,
                  acceptedAnswer: { '@type': 'Answer', text: faq.answer },
                })),
              ),
            }),
          }}
        />
      )}
    </>
  );
}
