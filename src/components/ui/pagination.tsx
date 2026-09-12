import Link from 'next/link';
import { ChevronLeft, ChevronRight } from 'lucide-react';

import { cn } from '@/lib/utils/cn';
import { formatNumber } from '@/lib/utils/format';

/**
 * Server-side pagination controls.
 *
 * Rendered as links rather than buttons, so pages are shareable, the browser
 * back button behaves, and the control works before hydration.
 */

export interface PaginationProps {
  page: number;
  pageSize: number;
  total: number;
  /** Current query string, so filters and search survive a page change. */
  searchParams: Record<string, string | undefined>;
  basePath: string;
}

function buildHref(
  basePath: string,
  searchParams: Record<string, string | undefined>,
  page: number,
): string {
  const params = new URLSearchParams();

  for (const [key, value] of Object.entries(searchParams)) {
    if (value && key !== 'page') params.set(key, value);
  }

  if (page > 1) params.set('page', String(page));

  const query = params.toString();
  return query ? `${basePath}?${query}` : basePath;
}

export function Pagination({ page, pageSize, total, searchParams, basePath }: PaginationProps) {
  const totalPages = Math.max(1, Math.ceil(total / pageSize));

  if (total === 0) return null;

  const first = (page - 1) * pageSize + 1;
  const last = Math.min(page * pageSize, total);

  const hasPrevious = page > 1;
  const hasNext = page < totalPages;

  const linkClasses =
    'inline-flex h-9 items-center gap-1 rounded-lg border border-ink-300 bg-white px-3 text-sm ' +
    'font-medium text-ink-700 transition-colors hover:bg-ink-50';
  const disabledClasses =
    'inline-flex h-9 cursor-not-allowed items-center gap-1 rounded-lg border border-ink-200 ' +
    'bg-ink-50 px-3 text-sm font-medium text-ink-400';

  return (
    <nav
      aria-label="Pagination"
      className="flex flex-wrap items-center justify-between gap-3 border-t border-ink-200 px-4 py-3"
    >
      <p className="text-sm text-ink-600">
        Showing <span className="font-medium text-ink-900">{formatNumber(first)}</span> to{' '}
        <span className="font-medium text-ink-900">{formatNumber(last)}</span> of{' '}
        <span className="font-medium text-ink-900">{formatNumber(total)}</span>
      </p>

      <div className="flex items-center gap-2">
        {hasPrevious ? (
          <Link href={buildHref(basePath, searchParams, page - 1)} className={linkClasses} rel="prev">
            <ChevronLeft aria-hidden className="size-4" />
            Previous
          </Link>
        ) : (
          <span className={disabledClasses} aria-disabled="true">
            <ChevronLeft aria-hidden className="size-4" />
            Previous
          </span>
        )}

        <span className="px-1 text-sm text-ink-500" aria-current="page">
          Page {page} of {totalPages}
        </span>

        {hasNext ? (
          <Link href={buildHref(basePath, searchParams, page + 1)} className={linkClasses} rel="next">
            Next
            <ChevronRight aria-hidden className="size-4" />
          </Link>
        ) : (
          <span className={cn(disabledClasses)} aria-disabled="true">
            Next
            <ChevronRight aria-hidden className="size-4" />
          </span>
        )}
      </div>
    </nav>
  );
}
