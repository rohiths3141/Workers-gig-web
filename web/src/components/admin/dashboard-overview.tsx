import Link from 'next/link';
import { ArrowUpRight, ChevronRight, CircleCheck, type LucideIcon } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Card, CardHeader } from '@/components/ui/card';
import { formatNumber } from '@/lib/utils/format';
import { cn } from '@/lib/utils/cn';

/**
 * Dashboard building blocks.
 *
 * Two kinds of number, shown two different ways:
 *
 *   KpiCard       — how the platform is doing. A headline figure with the
 *                   figures that explain it, one card per area.
 *   AttentionPanel — work waiting on an operator. Only queues that have
 *                   something in them get a row, most urgent first; empty
 *                   queues collapse into a single "all clear" line.
 */

/* ==========================================================================
   KPI card
   ========================================================================== */

export interface Kpi {
  key: string;
  label: string;
  icon: LucideIcon;
  href: string;
  value: number;
  /** Printed after the value, e.g. "of 14". */
  suffix?: string;
  /** Share of a whole, 0–1, drawn as a bar under the value. */
  ratio?: number;
  detail?: string;
}

export function KpiCard({ kpi }: { kpi: Kpi }) {
  const Icon = kpi.icon;

  return (
    <Link
      href={kpi.href}
      className="group flex flex-col rounded-xl border border-ink-200 bg-white p-4 shadow-card transition-colors hover:border-brand-300 sm:p-5"
    >
      <div className="flex items-center justify-between">
        <span className="flex size-9 items-center justify-center rounded-lg bg-brand-50 text-brand-700">
          <Icon aria-hidden className="size-4.5" />
        </span>
        <ArrowUpRight
          aria-hidden
          className="size-4 text-ink-300 transition-colors group-hover:text-brand-600"
        />
      </div>

      <p className="mt-3 text-sm font-medium text-ink-600 sm:mt-4">{kpi.label}</p>
      <p className="mt-1 flex items-baseline gap-1.5">
        <span className="tabular text-2xl font-semibold tracking-tight text-ink-900 sm:text-3xl">
          {formatNumber(kpi.value)}
        </span>
        {kpi.suffix && <span className="text-sm text-ink-500">{kpi.suffix}</span>}
      </p>

      {kpi.ratio !== undefined && (
        // Decorative: the value and suffix above already say the same thing.
        <div aria-hidden className="mt-3 h-1.5 overflow-hidden rounded-full bg-ink-100">
          <div
            className="h-full rounded-full bg-success-500"
            style={{ width: `${Math.round(Math.min(Math.max(kpi.ratio, 0), 1) * 100)}%` }}
          />
        </div>
      )}

      {kpi.detail && <p className="mt-2 text-sm text-ink-500">{kpi.detail}</p>}
    </Link>
  );
}

/* ==========================================================================
   Needs attention
   ========================================================================== */

export interface AttentionItem {
  key: string;
  label: string;
  hint?: string;
  icon: LucideIcon;
  href: string;
  count: number;
  /** Shown instead of a row when the count is zero, e.g. "No open claims". */
  clearLabel: string;
  /** danger: something failed or is disputed. warning: a queue to work through. */
  tone: 'warning' | 'danger';
}

const TONE = {
  warning: { tile: 'bg-warning-50 text-warning-700', count: 'text-warning-700' },
  danger: { tile: 'bg-danger-50 text-danger-700', count: 'text-danger-700' },
} as const;

export function AttentionPanel({ items }: { items: AttentionItem[] }) {
  // Failures before queues, then the longest queue first.
  const open = items
    .filter((item) => item.count > 0)
    .sort((a, b) => (a.tone === b.tone ? b.count - a.count : a.tone === 'danger' ? -1 : 1));
  const clear = items.filter((item) => item.count === 0);

  return (
    <Card>
      <CardHeader
        title={
          <span className="flex items-center gap-2">
            Needs attention
            {open.length > 0 && <Badge tone="warning">{open.length}</Badge>}
          </span>
        }
        description={
          open.length > 0
            ? 'Work waiting on an operator, most urgent first.'
            : 'Nothing is waiting on an operator right now.'
        }
      />

      {open.length > 0 && (
        <ul className="grid gap-3 p-3 sm:p-4 md:grid-cols-2">
          {open.map((item) => {
            const Icon = item.icon;
            return (
              <li key={item.key}>
                <Link
                  href={item.href}
                  className="group flex h-full items-center gap-3 rounded-lg border border-ink-200 p-3 transition-colors hover:border-brand-300 hover:bg-ink-50 sm:gap-4 sm:p-4"
                >
                  <span
                    className={cn(
                      'flex size-10 shrink-0 items-center justify-center rounded-lg',
                      TONE[item.tone].tile,
                    )}
                  >
                    <Icon aria-hidden className="size-5" />
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="block text-sm font-semibold text-ink-900">{item.label}</span>
                    {item.hint && (
                      <span className="mt-0.5 block text-sm text-ink-500">{item.hint}</span>
                    )}
                  </span>
                  <span className={cn('tabular text-2xl font-semibold', TONE[item.tone].count)}>
                    {formatNumber(item.count)}
                  </span>
                  <ChevronRight
                    aria-hidden
                    className="size-4 shrink-0 text-ink-300 transition-colors group-hover:text-ink-500"
                  />
                </Link>
              </li>
            );
          })}
        </ul>
      )}

      {clear.length > 0 && (
        <div
          className={cn(
            'flex flex-wrap items-center gap-x-2 gap-y-1 px-5 py-3.5 text-sm text-ink-600',
            open.length > 0 && 'border-t border-ink-200',
          )}
        >
          <span className="inline-flex items-center gap-1.5 font-medium text-success-700">
            <CircleCheck aria-hidden className="size-4" />
            All clear
          </span>
          {clear.map((item, index) => (
            <span key={item.key}>
              {index > 0 && <span className="mr-2 text-ink-300">·</span>}
              {item.clearLabel}
            </span>
          ))}
        </div>
      )}
    </Card>
  );
}
