import type { ReactNode } from 'react';

import { cn } from '@/lib/utils/cn';

export function Card({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <section className={cn('rounded-xl border border-ink-200 bg-white shadow-card', className)}>
      {children}
    </section>
  );
}

export function CardHeader({
  title,
  description,
  actions,
  className,
}: {
  title: ReactNode;
  description?: ReactNode;
  actions?: ReactNode;
  className?: string;
}) {
  return (
    <header
      className={cn(
        'flex flex-wrap items-start justify-between gap-3 border-b border-ink-200 px-5 py-4',
        className,
      )}
    >
      <div className="min-w-0">
        <h2 className="text-base font-semibold text-ink-900">{title}</h2>
        {description && <p className="mt-0.5 text-sm text-ink-500">{description}</p>}
      </div>
      {actions && <div className="flex shrink-0 items-center gap-2">{actions}</div>}
    </header>
  );
}

export function CardBody({ className, children }: { className?: string; children: ReactNode }) {
  return <div className={cn('px-5 py-4', className)}>{children}</div>;
}

export function CardFooter({ className, children }: { className?: string; children: ReactNode }) {
  return (
    <footer className={cn('border-t border-ink-200 bg-ink-50/60 px-5 py-3', className)}>
      {children}
    </footer>
  );
}

/**
 * A labelled value, the workhorse of every admin detail page.
 * Renders as a definition pair so the label/value relationship survives for a
 * screen reader.
 */
export function Field({
  label,
  value,
  className,
}: {
  label: string;
  value: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn('min-w-0', className)}>
      <dt className="text-xs font-medium uppercase tracking-wide text-ink-500">{label}</dt>
      <dd className="mt-1 break-words text-sm text-ink-900">{value ?? '—'}</dd>
    </div>
  );
}

export function FieldGrid({
  columns = 3,
  children,
  className,
}: {
  columns?: 2 | 3 | 4;
  children: ReactNode;
  className?: string;
}) {
  const cols = {
    2: 'sm:grid-cols-2',
    3: 'sm:grid-cols-2 lg:grid-cols-3',
    4: 'sm:grid-cols-2 lg:grid-cols-4',
  }[columns];

  return <dl className={cn('grid grid-cols-1 gap-x-6 gap-y-4', cols, className)}>{children}</dl>;
}
