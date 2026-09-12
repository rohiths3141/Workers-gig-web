import type { ReactNode } from 'react';
import Link from 'next/link';

import { cn } from '@/lib/utils/cn';

/**
 * Data table.
 *
 * A server component. Rows arrive already paginated by the database — the
 * browser never receives a full table and slices it locally, which is what
 * keeps an admin list usable once there are fifty thousand bookings.
 *
 * On a narrow screen the table scrolls inside its own container rather than
 * widening the page, so the admin layout stays intact on a tablet or phone.
 */

export interface Column<T> {
  /** Stable key, also used as the React key for the cell. */
  key: string;
  header: ReactNode;
  /** Cell renderer. Receives the whole row so a cell can combine fields. */
  cell: (row: T) => ReactNode;
  /** Hide below the given breakpoint to keep narrow screens readable. */
  hideBelow?: 'sm' | 'md' | 'lg' | 'xl';
  align?: 'left' | 'right' | 'center';
  /** Fixed column width, e.g. 'w-40'. */
  width?: string;
  /** Numeric columns get tabular figures so digits line up. */
  numeric?: boolean;
}

const HIDE_CLASSES = {
  sm: 'hidden sm:table-cell',
  md: 'hidden md:table-cell',
  lg: 'hidden lg:table-cell',
  xl: 'hidden xl:table-cell',
} as const;

const ALIGN_CLASSES = {
  left: 'text-left',
  right: 'text-right',
  center: 'text-center',
} as const;

export interface DataTableProps<T> {
  columns: ReadonlyArray<Column<T>>;
  rows: readonly T[];
  rowKey: (row: T) => string;
  /** Makes the whole row a link to the detail page. */
  rowHref?: (row: T) => string;
  /** Rendered in place of the table body when there are no rows. */
  empty: ReactNode;
  caption?: string;
  className?: string;
}

export function DataTable<T>({
  columns,
  rows,
  rowKey,
  rowHref,
  empty,
  caption,
  className,
}: DataTableProps<T>) {
  if (rows.length === 0) {
    return <div className={cn('border-t border-ink-200', className)}>{empty}</div>;
  }

  return (
    <div className={cn('scroll-x border-t border-ink-200', className)}>
      <table className="w-full min-w-max border-collapse text-sm">
        {caption && <caption className="sr-only">{caption}</caption>}

        <thead>
          <tr className="border-b border-ink-200 bg-ink-50/60">
            {columns.map((column) => (
              <th
                key={column.key}
                scope="col"
                className={cn(
                  'px-4 py-2.5 text-xs font-semibold uppercase tracking-wide text-ink-600',
                  ALIGN_CLASSES[column.align ?? 'left'],
                  column.hideBelow && HIDE_CLASSES[column.hideBelow],
                  column.width,
                )}
              >
                {column.header}
              </th>
            ))}
          </tr>
        </thead>

        <tbody className="divide-y divide-ink-100">
          {rows.map((row) => {
            const href = rowHref?.(row);

            return (
              <tr
                key={rowKey(row)}
                className={cn('bg-white transition-colors', href && 'hover:bg-brand-50/40')}
              >
                {columns.map((column, index) => {
                  const content = column.cell(row);

                  return (
                    <td
                      key={column.key}
                      className={cn(
                        'px-4 py-3 align-middle text-ink-700',
                        ALIGN_CLASSES[column.align ?? 'left'],
                        column.hideBelow && HIDE_CLASSES[column.hideBelow],
                        column.numeric && 'tabular',
                      )}
                    >
                      {/* Only the first cell becomes the link. Wrapping every
                          cell would give a screen reader one link per column
                          for the same destination. */}
                      {href && index === 0 ? (
                        <Link
                          href={href}
                          className="block font-medium text-ink-900 hover:text-brand-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand-600"
                        >
                          {content}
                        </Link>
                      ) : (
                        content
                      )}
                    </td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

/** Two-line cell: a primary value with supporting context beneath it. */
export function CellStack({
  primary,
  secondary,
}: {
  primary: ReactNode;
  secondary?: ReactNode;
}) {
  return (
    <div className="min-w-0">
      <div className="truncate text-ink-900">{primary}</div>
      {secondary && <div className="truncate text-xs text-ink-500">{secondary}</div>}
    </div>
  );
}
