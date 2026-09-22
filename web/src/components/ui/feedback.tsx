import type { ReactNode } from 'react';
import { AlertTriangle, CheckCircle2, Info, Loader2, XCircle } from 'lucide-react';

import { cn } from '@/lib/utils/cn';

/* ==========================================================================
   Loading
   ========================================================================== */

export function Spinner({ className, label = 'Loading' }: { className?: string; label?: string }) {
  return (
    <span role="status" aria-live="polite">
      <Loader2 aria-hidden className={cn('size-5 animate-spin text-ink-400', className)} />
      <span className="sr-only">{label}</span>
    </span>
  );
}

/**
 * Skeleton placeholder. Always sized to roughly match the content it stands in
 * for, so the page does not jump when real data arrives.
 */
export function Skeleton({ className }: { className?: string }) {
  return <div aria-hidden className={cn('animate-pulse rounded-md bg-ink-100', className)} />;
}

export function SkeletonText({ lines = 3, className }: { lines?: number; className?: string }) {
  return (
    <div className={cn('space-y-2', className)} role="status" aria-label="Loading content">
      {Array.from({ length: lines }).map((_, index) => (
        <Skeleton
          key={index}
          className={cn('h-4', index === lines - 1 ? 'w-2/3' : 'w-full')}
        />
      ))}
    </div>
  );
}

export function SkeletonTable({ rows = 8, columns = 5 }: { rows?: number; columns?: number }) {
  return (
    <div className="divide-y divide-ink-200" role="status" aria-label="Loading table">
      {Array.from({ length: rows }).map((_, rowIndex) => (
        <div key={rowIndex} className="flex items-center gap-4 px-4 py-3.5">
          {Array.from({ length: columns }).map((__, colIndex) => (
            <Skeleton
              key={colIndex}
              className={cn('h-4', colIndex === 0 ? 'w-40' : 'flex-1 max-w-32')}
            />
          ))}
        </div>
      ))}
    </div>
  );
}

/* ==========================================================================
   Alert
   ========================================================================== */

type AlertTone = 'info' | 'success' | 'warning' | 'danger';

const ALERT_STYLES: Record<AlertTone, { wrapper: string; icon: typeof Info }> = {
  info: { wrapper: 'border-info-100 bg-info-50 text-info-700', icon: Info },
  success: { wrapper: 'border-success-100 bg-success-50 text-success-700', icon: CheckCircle2 },
  warning: { wrapper: 'border-warning-100 bg-warning-50 text-warning-700', icon: AlertTriangle },
  danger: { wrapper: 'border-danger-100 bg-danger-50 text-danger-700', icon: XCircle },
};

export function Alert({
  tone = 'info',
  title,
  children,
  className,
}: {
  tone?: AlertTone;
  title?: string;
  children?: ReactNode;
  className?: string;
}) {
  const { wrapper, icon: Icon } = ALERT_STYLES[tone];

  return (
    <div
      // Errors interrupt; everything else is announced politely.
      role={tone === 'danger' ? 'alert' : 'status'}
      className={cn('flex gap-3 rounded-lg border p-4 text-sm', wrapper, className)}
    >
      <Icon aria-hidden className="mt-0.5 size-4.5 shrink-0" />
      <div className="min-w-0">
        {title && <p className="font-semibold">{title}</p>}
        {children && <div className={cn(title && 'mt-1', 'text-[0.8125rem] leading-relaxed')}>{children}</div>}
      </div>
    </div>
  );
}

/* ==========================================================================
   Empty and error states
   ========================================================================== */

/**
 * An empty state always says what the operator can do next. "No workers found"
 * on its own leaves someone wondering whether the page is broken.
 */
export function EmptyState({
  title,
  description,
  action,
  icon,
  className,
}: {
  title: string;
  description?: string;
  action?: ReactNode;
  icon?: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn('flex flex-col items-center px-6 py-14 text-center', className)}>
      {icon && (
        <div className="mb-4 flex size-11 items-center justify-center rounded-full bg-ink-100 text-ink-400">
          {icon}
        </div>
      )}
      <p className="text-sm font-semibold text-ink-900">{title}</p>
      {description && <p className="mt-1.5 max-w-sm text-sm text-ink-500">{description}</p>}
      {action && <div className="mt-5">{action}</div>}
    </div>
  );
}

export function ErrorState({
  title = 'Something went wrong',
  description,
  action,
  className,
}: {
  title?: string;
  description?: string;
  action?: ReactNode;
  className?: string;
}) {
  return (
    <div
      role="alert"
      className={cn('flex flex-col items-center px-6 py-14 text-center', className)}
    >
      <div className="mb-4 flex size-11 items-center justify-center rounded-full bg-danger-50 text-danger-600">
        <AlertTriangle aria-hidden className="size-5" />
      </div>
      <p className="text-sm font-semibold text-ink-900">{title}</p>
      {description && <p className="mt-1.5 max-w-md text-sm text-ink-500">{description}</p>}
      {action && <div className="mt-5">{action}</div>}
    </div>
  );
}
