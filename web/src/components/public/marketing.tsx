import type { ReactNode } from 'react';
import Link from 'next/link';
import { ArrowRight, Check } from 'lucide-react';

import { cn } from '@/lib/utils/cn';

/**
 * Marketing building blocks shared across the public pages.
 *
 * Kept small and typographic on purpose. The design signal this product needs is
 * clarity and credibility, not decoration — so there are no gradients, no glass
 * effects and no oversized animation here.
 */

export function Eyebrow({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <p
      className={cn(
        'text-xs font-semibold uppercase tracking-[0.12em] text-brand-700',
        className,
      )}
    >
      {children}
    </p>
  );
}

export function SectionHeading({
  eyebrow,
  title,
  description,
  align = 'left',
  as: Heading = 'h2',
  className,
}: {
  eyebrow?: string;
  title: ReactNode;
  description?: ReactNode;
  align?: 'left' | 'center';
  as?: 'h1' | 'h2' | 'h3';
  className?: string;
}) {
  return (
    <div
      className={cn(
        'max-w-2xl',
        align === 'center' && 'mx-auto text-center',
        className,
      )}
    >
      {eyebrow && <Eyebrow className="mb-3">{eyebrow}</Eyebrow>}

      <Heading
        className={cn(
          'font-semibold tracking-tight text-ink-900',
          Heading === 'h1' ? 'text-3xl sm:text-4xl lg:text-5xl' : 'text-2xl sm:text-3xl',
        )}
      >
        {title}
      </Heading>

      {description && (
        <div className="mt-4 text-base leading-relaxed text-ink-600">{description}</div>
      )}
    </div>
  );
}

/** A numbered step in a journey, drawn as a connected vertical sequence. */
export function StepList({
  steps,
  className,
}: {
  steps: ReadonlyArray<{ title: string; description: string }>;
  className?: string;
}) {
  return (
    <ol className={cn('relative space-y-0', className)}>
      {steps.map((step, index) => {
        const isLast = index === steps.length - 1;

        return (
          <li key={step.title} className="relative flex gap-5 pb-8 last:pb-0">
            {/* The connector is decorative; the ordered list carries the
                sequence for assistive technology. */}
            {!isLast && (
              <span
                aria-hidden
                className="absolute left-[1.0625rem] top-9 h-[calc(100%-1.5rem)] w-px bg-ink-200"
              />
            )}

            <span className="relative z-10 flex size-9 shrink-0 items-center justify-center rounded-full border border-brand-200 bg-brand-50 text-sm font-semibold text-brand-800">
              {index + 1}
            </span>

            <div className="min-w-0 pt-1">
              <h3 className="text-base font-semibold text-ink-900">{step.title}</h3>
              <p className="mt-1 text-sm leading-relaxed text-ink-600">{step.description}</p>
            </div>
          </li>
        );
      })}
    </ol>
  );
}

export function FeatureCard({
  icon,
  title,
  description,
  className,
}: {
  icon?: ReactNode;
  title: string;
  description: string;
  className?: string;
}) {
  return (
    <div
      className={cn(
        'rounded-xl border border-ink-200 bg-white p-5 transition-shadow hover:shadow-card',
        className,
      )}
    >
      {icon && (
        <div className="mb-3.5 flex size-10 items-center justify-center rounded-lg bg-brand-50 text-brand-700">
          {icon}
        </div>
      )}
      <h3 className="text-base font-semibold text-ink-900">{title}</h3>
      <p className="mt-1.5 text-sm leading-relaxed text-ink-600">{description}</p>
    </div>
  );
}

export function CheckList({
  items,
  className,
}: {
  items: readonly string[];
  className?: string;
}) {
  return (
    <ul className={cn('space-y-2.5', className)}>
      {items.map((item) => (
        <li key={item} className="flex gap-2.5 text-sm leading-relaxed text-ink-700">
          <Check aria-hidden className="mt-0.5 size-4 shrink-0 text-brand-600" />
          {item}
        </li>
      ))}
    </ul>
  );
}

export function TextLink({ href, children }: { href: string; children: ReactNode }) {
  return (
    <Link
      href={href}
      className="inline-flex items-center gap-1 text-sm font-medium text-brand-700 hover:text-brand-800"
    >
      {children}
      <ArrowRight aria-hidden className="size-4" />
    </Link>
  );
}

/**
 * Accordion built on native details/summary.
 *
 * Keyboard accessible and expandable before hydration, which also means the
 * answers are present in the HTML for search engines.
 */
export function Accordion({
  items,
  className,
}: {
  items: ReadonlyArray<{ id: string; question: string; answer: string }>;
  className?: string;
}) {
  return (
    <div className={cn('divide-y divide-ink-200 rounded-xl border border-ink-200 bg-white', className)}>
      {items.map((item) => (
        <details key={item.id} className="group px-5 py-4">
          <summary className="flex cursor-pointer list-none items-center justify-between gap-4 text-sm font-medium text-ink-900 marker:content-['']">
            {item.question}
            <span
              aria-hidden
              className="shrink-0 text-lg leading-none text-ink-400 transition-transform group-open:rotate-45"
            >
              +
            </span>
          </summary>
          <p className="mt-3 text-sm leading-relaxed text-ink-600">{item.answer}</p>
        </details>
      ))}
    </div>
  );
}
