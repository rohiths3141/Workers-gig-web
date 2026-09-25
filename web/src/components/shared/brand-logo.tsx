import Image from 'next/image';

import { cn } from '@/lib/utils/cn';

/**
 * The brand logo, cut from the master artwork into transparent PNGs in
 * public/images/brand. Intrinsic sizes below are those files' pixel sizes.
 *
 *   horizontal — mark beside the wordmark, for headers and footers
 *   stacked    — mark above the wordmark, the master lockup
 *   mark       — the symbol alone
 *
 * The wordmark is navy, so it is for light backgrounds only. On a dark surface
 * use the mark on a light tile and set the name as text.
 */

const MARK = { src: '/images/brand/wervexa-mark.png', width: 249, height: 176 };
const WORDMARK = { src: '/images/brand/wervexa-wordmark.png', width: 397, height: 70 };
const STACKED = { src: '/images/brand/wervexa-logo.png', width: 401, height: 266 };

type Variant = 'horizontal' | 'stacked' | 'mark';

export function BrandLogo({
  name,
  variant = 'horizontal',
  className,
  priority,
}: {
  /** The brand name, used as the accessible name of the logo. */
  name: string;
  variant?: Variant;
  className?: string;
  /** Set for a logo visible on first paint, such as the site header. */
  priority?: boolean;
}) {
  if (variant === 'horizontal') {
    return (
      <span className={cn('inline-flex items-center gap-2', className)}>
        <Image {...MARK} alt="" priority={priority} className="h-8 w-auto" />
        <Image {...WORDMARK} alt={name} priority={priority} className="h-5 w-auto" />
      </span>
    );
  }

  const image = variant === 'stacked' ? STACKED : MARK;
  return <Image {...image} alt={name} priority={priority} className={cn('w-auto', className)} />;
}
