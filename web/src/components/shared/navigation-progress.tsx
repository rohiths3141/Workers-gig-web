'use client';

import { useEffect, useRef, useState } from 'react';
import { usePathname, useSearchParams } from 'next/navigation';

/**
 * A thin bar across the top of the window while a page is on its way.
 *
 * Every admin page is rendered on the server per request, so clicking a link
 * left the old page on screen, unchanged, until the new one arrived — it read
 * as a click that had not registered. This starts on the click itself and
 * finishes when the URL actually changes.
 *
 * Only clicks that will navigate within the app start it: a modified click,
 * a new tab, a download, an external link or a link to the page already
 * showing does not.
 */
export function NavigationProgress() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [state, setState] = useState<'idle' | 'loading' | 'done'>('idle');
  const [progress, setProgress] = useState(0);
  const tick = useRef<ReturnType<typeof setInterval> | null>(null);
  const safety = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    const clearTimers = () => {
      if (tick.current) clearInterval(tick.current);
      if (safety.current) clearTimeout(safety.current);
      tick.current = null;
      safety.current = null;
    };

    const onClick = (event: MouseEvent) => {
      if (
        event.defaultPrevented ||
        event.button !== 0 ||
        event.metaKey ||
        event.ctrlKey ||
        event.shiftKey ||
        event.altKey
      ) {
        return;
      }

      const anchor = (event.target as Element | null)?.closest?.('a');
      if (!anchor || !anchor.href) return;
      if (anchor.target && anchor.target !== '_self') return;
      if (anchor.hasAttribute('download')) return;

      const url = new URL(anchor.href, window.location.href);
      if (url.origin !== window.location.origin) return;

      // Same page, or only the #fragment differs: nothing will load.
      const here = window.location;
      if (url.pathname === here.pathname && url.search === here.search) return;

      clearTimers();
      setProgress(8);
      setState('loading');

      // Creeps towards, but never reaches, the end until the page arrives.
      tick.current = setInterval(() => {
        setProgress((p) => (p < 80 ? p + (80 - p) * 0.12 : p));
      }, 200);

      // A navigation the router abandons (a redirect back to the same URL, an
      // error) must not leave the bar up for good.
      safety.current = setTimeout(() => {
        clearTimers();
        setState('done');
      }, 15000);
    };

    document.addEventListener('click', onClick, true);
    return () => {
      document.removeEventListener('click', onClick, true);
      clearTimers();
    };
  }, []);

  // The URL changed: the new page has been committed.
  useEffect(() => {
    if (tick.current) clearInterval(tick.current);
    if (safety.current) clearTimeout(safety.current);
    tick.current = null;
    safety.current = null;
    setState((s) => (s === 'loading' ? 'done' : s));
  }, [pathname, searchParams]);

  useEffect(() => {
    if (state !== 'done') return;
    setProgress(100);
    const hide = setTimeout(() => {
      setState('idle');
      setProgress(0);
    }, 300);
    return () => clearTimeout(hide);
  }, [state]);

  if (state === 'idle') return null;

  return (
    <div
      role="progressbar"
      aria-label="Loading page"
      aria-valuemin={0}
      aria-valuemax={100}
      aria-valuenow={Math.round(progress)}
      className="pointer-events-none fixed inset-x-0 top-0 z-[100] h-[3px]"
    >
      <div
        className="h-full bg-brand-500 shadow-[0_0_8px_var(--color-brand-500)] transition-[width] duration-200 ease-out"
        style={{ width: `${progress}%` }}
      />
    </div>
  );
}
