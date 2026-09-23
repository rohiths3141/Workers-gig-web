import { forwardRef, type ButtonHTMLAttributes } from 'react';
import Link from 'next/link';
import { Loader2 } from 'lucide-react';

import { cn } from '@/lib/utils/cn';

type Variant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger' | 'success';
type Size = 'sm' | 'md' | 'lg';

const VARIANTS: Record<Variant, string> = {
  primary:
    'bg-brand-700 text-white hover:bg-brand-800 active:bg-brand-900 disabled:bg-brand-700/50',
  secondary:
    'bg-ink-900 text-white hover:bg-ink-800 active:bg-ink-950 disabled:bg-ink-900/50',
  outline:
    'border border-ink-300 bg-white text-ink-800 hover:bg-ink-50 active:bg-ink-100 disabled:text-ink-400',
  ghost: 'text-ink-700 hover:bg-ink-100 active:bg-ink-200 disabled:text-ink-400',
  danger:
    'bg-danger-600 text-white hover:bg-danger-700 active:bg-danger-700 disabled:bg-danger-600/50',
  success:
    'bg-success-600 text-white hover:bg-success-700 active:bg-success-700 disabled:bg-success-600/50',
};

const SIZES: Record<Size, string> = {
  sm: 'h-8 px-3 text-sm gap-1.5',
  md: 'h-10 px-4 text-sm gap-2',
  lg: 'h-12 px-6 text-base gap-2',
};

const BASE =
  'inline-flex items-center justify-center rounded-lg font-medium transition-colors ' +
  'disabled:cursor-not-allowed focus-visible:outline-2 focus-visible:outline-offset-2 ' +
  'focus-visible:outline-brand-600 whitespace-nowrap';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
  /**
   * Shows a spinner and disables the button. Always drive this from real
   * pending state — a button that stays clickable during a mutation invites a
   * double submission.
   */
  loading?: boolean;
  fullWidth?: boolean;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = 'primary', size = 'md', loading = false, fullWidth, className, children, disabled, ...props },
  ref,
) {
  return (
    <button
      ref={ref}
      className={cn(BASE, VARIANTS[variant], SIZES[size], fullWidth && 'w-full', className)}
      disabled={disabled || loading}
      // Tells assistive technology the control is busy rather than broken.
      aria-busy={loading || undefined}
      {...props}
    >
      {loading && <Loader2 aria-hidden className="size-4 animate-spin" />}
      {children}
    </button>
  );
});

export interface ButtonLinkProps {
  href: string;
  variant?: Variant;
  size?: Size;
  fullWidth?: boolean;
  className?: string;
  children: React.ReactNode;
  /** Set for links leaving the site; adds the security rel and a new tab. */
  external?: boolean;
  /**
   * Set for a file to save rather than a page to visit; the value is the name
   * it is saved under. Renders a plain anchor — next/link would try to route to
   * the file as if it were a page.
   */
  download?: string;
}

/** A link styled as a button. Stays an anchor, so it keeps link semantics. */
export function ButtonLink({
  href,
  variant = 'primary',
  size = 'md',
  fullWidth,
  className,
  children,
  external,
  download,
}: ButtonLinkProps) {
  const classes = cn(BASE, VARIANTS[variant], SIZES[size], fullWidth && 'w-full', className);

  if (download) {
    return (
      <a href={href} download={download} className={classes}>
        {children}
      </a>
    );
  }

  if (external) {
    return (
      <a href={href} className={classes} target="_blank" rel="noopener noreferrer">
        {children}
      </a>
    );
  }

  return (
    <Link href={href} className={classes}>
      {children}
    </Link>
  );
}
