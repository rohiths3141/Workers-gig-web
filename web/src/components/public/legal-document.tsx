import type { ReactNode } from 'react';
import { AlertTriangle } from 'lucide-react';

import { publicEnv } from '@/lib/config/env';

/**
 * Legal document layout.
 *
 * Every legal page carries a visible "draft pending legal review" notice until
 * `reviewed` is set. The text is a structural starting point written to match
 * how the platform actually works; it has not been approved by a lawyer and
 * must not be presented as though it had.
 */

export interface LegalSection {
  heading: string;
  body: ReactNode;
}

export function LegalDocument({
  title,
  summary,
  lastUpdated,
  sections,
  reviewed = false,
}: {
  title: string;
  summary: string;
  lastUpdated: string;
  sections: LegalSection[];
  reviewed?: boolean;
}) {
  const { brand } = publicEnv();
  const entity = brand.legalEntityName ?? brand.name;

  return (
    <article className="section">
      <div className="container-page max-w-3xl">
        <header className="border-b border-ink-200 pb-8">
          <h1 className="text-3xl font-semibold tracking-tight text-ink-900 sm:text-4xl">{title}</h1>
          <p className="mt-3 text-base leading-relaxed text-ink-600">{summary}</p>
          <p className="mt-3 text-sm text-ink-500">
            {entity} · Last updated {lastUpdated}
          </p>
        </header>

        {!reviewed && (
          <div role="note" className="mt-8 flex gap-3 rounded-lg border border-warning-100 bg-warning-50 p-4 text-sm text-warning-700">
            <AlertTriangle aria-hidden className="mt-0.5 size-4 shrink-0" />
            <p>
              <strong className="font-semibold">Draft — pending final legal review.</strong> This
              document describes how the platform operates but has not yet been approved by legal
              counsel. It will be replaced by the reviewed version before launch.
            </p>
          </div>
        )}

        <nav aria-label="Contents" className="mt-8 rounded-lg bg-ink-50 p-5">
          <p className="text-xs font-semibold uppercase tracking-wide text-ink-500">Contents</p>
          <ol className="mt-3 list-decimal space-y-1 pl-5 text-sm">
            {sections.map((section, index) => (
              <li key={section.heading}>
                <a href={`#section-${index + 1}`} className="text-ink-700 hover:text-brand-700">
                  {section.heading}
                </a>
              </li>
            ))}
          </ol>
        </nav>

        <div className="mt-10 space-y-10">
          {sections.map((section, index) => (
            <section key={section.heading} id={`section-${index + 1}`} className="scroll-mt-24">
              <h2 className="text-lg font-semibold text-ink-900">
                {index + 1}. {section.heading}
              </h2>
              <div className="mt-3 space-y-3 text-[0.9375rem] leading-relaxed text-ink-700 [&_li]:ml-5 [&_ul]:list-disc [&_ul]:space-y-1.5">
                {section.body}
              </div>
            </section>
          ))}
        </div>

        <footer className="mt-12 border-t border-ink-200 pt-6 text-sm text-ink-600">
          Questions about this document can be sent to{' '}
          <a href={`mailto:${brand.grievanceEmail ?? brand.supportEmail}`} className="font-medium text-brand-700 hover:underline">
            {brand.grievanceEmail ?? brand.supportEmail}
          </a>
          .
        </footer>
      </div>
    </article>
  );
}
