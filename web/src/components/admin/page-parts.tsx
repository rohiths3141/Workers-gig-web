import type { ReactNode } from 'react';
import { Lock } from 'lucide-react';

import { ROLE_LABELS, type Permission } from '@/lib/permissions/permissions';
import { cn } from '@/lib/utils/cn';
import type { AdminRole } from '@/types/domain';

/**
 * Shared pieces of an admin page.
 *
 * PageHeader gives every screen the same anatomy — title, one line of context,
 * and the actions for this screen in a predictable place — so an operator does
 * not have to relearn the layout per section.
 */

export function PageHeader({
  title,
  description,
  actions,
  className,
}: {
  title: string;
  description?: ReactNode;
  actions?: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn('mb-5 flex flex-wrap items-start justify-between gap-3', className)}>
      <div className="min-w-0">
        <h1 className="text-xl font-semibold tracking-tight text-ink-900">{title}</h1>
        {description && <p className="mt-1 max-w-3xl text-sm text-ink-600">{description}</p>}
      </div>

      {actions && <div className="flex shrink-0 flex-wrap items-center gap-2">{actions}</div>}
    </div>
  );
}

/**
 * Shown in place of a page the operator may not open.
 *
 * Names the missing permission and their current role, because "Access denied"
 * on its own sends someone to ask a colleague what went wrong. It reveals
 * nothing sensitive: the permission catalogue is not a secret, and the data
 * behind the page is still unreachable.
 */
export function ForbiddenPanel({
  permission,
  role,
  resource,
}: {
  permission: Permission;
  role?: AdminRole;
  resource?: string;
}) {
  return (
    <div className="mx-auto max-w-lg rounded-xl border border-ink-200 bg-white p-8 text-center shadow-card">
      <div className="mx-auto flex size-11 items-center justify-center rounded-full bg-warning-50 text-warning-600">
        <Lock aria-hidden className="size-5" />
      </div>

      <h1 className="mt-4 text-base font-semibold text-ink-900">
        You do not have access to {resource ?? 'this section'}
      </h1>

      <p className="mt-2 text-sm leading-relaxed text-ink-600">
        Opening it requires the{' '}
        <code className="rounded bg-ink-100 px-1.5 py-0.5 font-mono text-[0.8125rem] text-ink-800">
          {permission}
        </code>{' '}
        permission
        {role ? (
          <>
            , which the <span className="font-medium text-ink-900">{ROLE_LABELS[role]}</span> role
            does not include
          </>
        ) : null}
        .
      </p>

      <p className="mt-3 text-xs text-ink-500">
        A Super Admin can grant this permission individually without changing your role.
      </p>
    </div>
  );
}

/**
 * Conditionally render an action based on a permission.
 *
 * For presentation only. The action it wraps is still refused by the API route
 * and by the database if it is somehow invoked — this decides whether a button
 * appears, not whether it works.
 */
export function PermissionGuard({
  permissions,
  required,
  children,
  fallback = null,
}: {
  permissions: readonly string[];
  required: Permission;
  children: ReactNode;
  fallback?: ReactNode;
}) {
  return <>{permissions.includes(required) ? children : fallback}</>;
}

/** A titled block within a page. */
export function PageSection({
  title,
  description,
  actions,
  children,
  className,
}: {
  title?: string;
  description?: string;
  actions?: ReactNode;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section className={cn('space-y-3', className)}>
      {(title || actions) && (
        <div className="flex flex-wrap items-end justify-between gap-2">
          <div>
            {title && <h2 className="text-sm font-semibold text-ink-900">{title}</h2>}
            {description && <p className="mt-0.5 text-sm text-ink-500">{description}</p>}
          </div>
          {actions && <div className="flex items-center gap-2">{actions}</div>}
        </div>
      )}
      {children}
    </section>
  );
}

/**
 * Dashboard KPI tile.
 *
 * `value` is always a real count from the database. A tile with nothing behind
 * it shows 0, never a placeholder or a plausible-looking figure.
 */
export function StatCard({
  label,
  value,
  hint,
  href,
  tone = 'neutral',
  icon,
}: {
  label: string;
  value: string | number;
  hint?: string;
  href?: string;
  tone?: 'neutral' | 'warning' | 'danger' | 'success';
  icon?: ReactNode;
}) {
  const toneClasses = {
    neutral: 'text-ink-900',
    warning: 'text-warning-700',
    danger: 'text-danger-700',
    success: 'text-success-700',
  }[tone];

  const content = (
    <>
      <div className="flex items-start justify-between gap-2">
        <p className="text-xs font-medium uppercase tracking-wide text-ink-500">{label}</p>
        {icon && <span className="shrink-0 text-ink-400">{icon}</span>}
      </div>

      <p className={cn('mt-2 text-2xl font-semibold tabular', toneClasses)}>{value}</p>
      {hint && <p className="mt-1 text-xs text-ink-500">{hint}</p>}
    </>
  );

  const classes = cn(
    'rounded-xl border border-ink-200 bg-white p-4 shadow-card',
    href && 'transition-colors hover:border-brand-300 hover:bg-brand-50/30',
  );

  if (href) {
    return (
      <a href={href} className={cn(classes, 'block')}>
        {content}
      </a>
    );
  }

  return <div className={classes}>{content}</div>;
}
