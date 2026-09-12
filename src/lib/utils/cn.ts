import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

/**
 * Merge class names, letting later Tailwind utilities win over earlier ones.
 *
 * Without this, `cn('px-4', 'px-6')` would emit both and leave the outcome to
 * stylesheet order. With it, the caller's override reliably applies.
 */
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
