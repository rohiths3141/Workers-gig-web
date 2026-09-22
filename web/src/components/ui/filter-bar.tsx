'use client';

import { useCallback, useEffect, useId, useRef, useState, useTransition } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import { Loader2, Search, X } from 'lucide-react';

import { cn } from '@/lib/utils/cn';

/**
 * Filter and search controls that write to the URL.
 *
 * The URL is the single source of truth for list state, which means a filtered
 * view is shareable, survives a refresh, and can be linked to from an alert or
 * a runbook. The server component reads searchParams and queries accordingly;
 * these controls only navigate.
 */

function useUrlState() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [isPending, startTransition] = useTransition();

  const setParam = useCallback(
    (key: string, value: string | null) => {
      const params = new URLSearchParams(searchParams.toString());

      if (value === null || value === '') {
        params.delete(key);
      } else {
        params.set(key, value);
      }

      // Any filter change invalidates the current page offset.
      params.delete('page');

      const query = params.toString();
      startTransition(() => {
        router.replace(query ? `${pathname}?${query}` : pathname, { scroll: false });
      });
    },
    [pathname, router, searchParams],
  );

  return { setParam, searchParams, isPending };
}

/* ==========================================================================
   Search
   ========================================================================== */

export function SearchInput({
  placeholder = 'Search',
  paramName = 'q',
  label,
  className,
}: {
  placeholder?: string;
  paramName?: string;
  label: string;
  className?: string;
}) {
  const { setParam, searchParams, isPending } = useUrlState();
  const id = useId();
  const initial = searchParams.get(paramName) ?? '';
  const [value, setValue] = useState(initial);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Keep the box in step when the URL changes underneath it — a cleared filter,
  // a back navigation, a link from elsewhere.
  useEffect(() => {
    setValue(searchParams.get(paramName) ?? '');
  }, [searchParams, paramName]);

  // Debounced so typing does not fire a query per keystroke.
  const onChange = (next: string) => {
    setValue(next);
    if (timer.current) clearTimeout(timer.current);
    timer.current = setTimeout(() => setParam(paramName, next.trim() || null), 350);
  };

  useEffect(() => () => { if (timer.current) clearTimeout(timer.current); }, []);

  return (
    <div className={cn('relative', className)}>
      <label htmlFor={id} className="sr-only">
        {label}
      </label>

      <Search
        aria-hidden
        className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-ink-400"
      />

      <input
        id={id}
        type="search"
        value={value}
        onChange={(event) => onChange(event.target.value)}
        placeholder={placeholder}
        className="h-10 w-full rounded-lg border border-ink-300 bg-white pl-9 pr-9 text-sm text-ink-900 placeholder:text-ink-400 focus:border-brand-600 focus:outline-none focus:ring-2 focus:ring-brand-600/20"
      />

      {isPending && (
        <Loader2
          aria-hidden
          className="absolute right-3 top-1/2 size-4 -translate-y-1/2 animate-spin text-ink-400"
        />
      )}

      {!isPending && value && (
        <button
          type="button"
          onClick={() => onChange('')}
          className="absolute right-2 top-1/2 -translate-y-1/2 rounded p-1 text-ink-400 hover:text-ink-700"
        >
          <X aria-hidden className="size-4" />
          <span className="sr-only">Clear search</span>
        </button>
      )}
    </div>
  );
}

/* ==========================================================================
   Select filter
   ========================================================================== */

export function FilterSelect({
  paramName,
  label,
  options,
  allLabel = 'All',
  className,
}: {
  paramName: string;
  label: string;
  options: ReadonlyArray<{ value: string; label: string }>;
  allLabel?: string;
  className?: string;
}) {
  const { setParam, searchParams } = useUrlState();
  const id = useId();
  const current = searchParams.get(paramName) ?? '';

  return (
    <div className={cn('min-w-0', className)}>
      <label htmlFor={id} className="sr-only">
        {label}
      </label>
      <select
        id={id}
        value={current}
        onChange={(event) => setParam(paramName, event.target.value || null)}
        className={cn(
          'h-10 w-full rounded-lg border bg-white px-3 text-sm focus:border-brand-600 focus:outline-none focus:ring-2 focus:ring-brand-600/20',
          current ? 'border-brand-500 text-brand-800' : 'border-ink-300 text-ink-700',
        )}
      >
        <option value="">{allLabel}</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </div>
  );
}

/* ==========================================================================
   Bar
   ========================================================================== */

export function FilterBar({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        'flex flex-wrap items-center gap-2 border-b border-ink-200 px-4 py-3',
        className,
      )}
    >
      {children}
    </div>
  );
}

/** Clears every filter at once. Only rendered when at least one is active. */
export function ClearFilters({ activeCount }: { activeCount: number }) {
  const router = useRouter();
  const pathname = usePathname();

  if (activeCount === 0) return null;

  return (
    <button
      type="button"
      onClick={() => router.replace(pathname, { scroll: false })}
      className="inline-flex h-10 items-center gap-1.5 rounded-lg px-3 text-sm font-medium text-ink-600 hover:bg-ink-100 hover:text-ink-900"
    >
      <X aria-hidden className="size-4" />
      Clear {activeCount} filter{activeCount === 1 ? '' : 's'}
    </button>
  );
}
