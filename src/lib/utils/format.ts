/**
 * Formatting helpers.
 *
 * Money is stored and passed around as integer minor units (paise). It is only
 * ever divided by 100 here, at the point of display, so no arithmetic anywhere
 * else in the application can accumulate a floating-point error.
 */

const DEFAULT_LOCALE = 'en-IN';

/** Format integer minor units as currency. `null` renders as an em dash. */
export function formatMoney(
  amountMinor: number | null | undefined,
  currency = 'INR',
  options: { showZero?: boolean } = {},
): string {
  if (amountMinor === null || amountMinor === undefined) return '—';
  if (amountMinor === 0 && options.showZero === false) return '—';

  return new Intl.NumberFormat(DEFAULT_LOCALE, {
    style: 'currency',
    currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(amountMinor / 100);
}

/** Compact form for dashboard tiles: ₹1.2L, ₹45.0K. */
export function formatMoneyCompact(amountMinor: number | null | undefined, currency = 'INR'): string {
  if (amountMinor === null || amountMinor === undefined) return '—';

  return new Intl.NumberFormat(DEFAULT_LOCALE, {
    style: 'currency',
    currency,
    notation: 'compact',
    maximumFractionDigits: 1,
  }).format(amountMinor / 100);
}

export function formatNumber(value: number | null | undefined): string {
  if (value === null || value === undefined) return '—';
  return new Intl.NumberFormat(DEFAULT_LOCALE).format(value);
}

export function formatDate(value: string | Date | null | undefined): string {
  if (!value) return '—';
  const date = typeof value === 'string' ? new Date(value) : value;
  if (Number.isNaN(date.getTime())) return '—';

  return new Intl.DateTimeFormat(DEFAULT_LOCALE, {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  }).format(date);
}

export function formatDateTime(value: string | Date | null | undefined): string {
  if (!value) return '—';
  const date = typeof value === 'string' ? new Date(value) : value;
  if (Number.isNaN(date.getTime())) return '—';

  return new Intl.DateTimeFormat(DEFAULT_LOCALE, {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(date);
}

/** "3 hours ago", "in 2 days". Falls back to an absolute date beyond a month. */
export function formatRelativeTime(value: string | Date | null | undefined): string {
  if (!value) return '—';
  const date = typeof value === 'string' ? new Date(value) : value;
  if (Number.isNaN(date.getTime())) return '—';

  const diffMs = date.getTime() - Date.now();
  const diffSeconds = Math.round(diffMs / 1000);
  const absSeconds = Math.abs(diffSeconds);

  if (absSeconds > 60 * 60 * 24 * 30) {
    return formatDate(date);
  }

  const formatter = new Intl.RelativeTimeFormat(DEFAULT_LOCALE, { numeric: 'auto' });

  const divisions: Array<[number, Intl.RelativeTimeFormatUnit]> = [
    [60, 'second'],
    [60, 'minute'],
    [24, 'hour'],
    [30, 'day'],
  ];

  let duration = diffSeconds;
  for (const [amount, unit] of divisions) {
    if (Math.abs(duration) < amount) {
      return formatter.format(Math.round(duration), unit);
    }
    duration /= amount;
  }

  return formatDate(date);
}

/**
 * Turn an enum member into a readable label: IN_PROGRESS -> "In progress".
 * Used wherever a status has no bespoke copy of its own.
 */
export function humaniseEnum(value: string | null | undefined): string {
  if (!value) return '—';
  const lower = value.toLowerCase().replace(/_/g, ' ');
  return lower.charAt(0).toUpperCase() + lower.slice(1);
}

/**
 * Mask a phone number for surfaces where the full number is not needed.
 * Operators who need the real number have it on the detail page, behind the
 * permission that governs that record.
 */
export function maskPhone(phone: string | null | undefined): string {
  if (!phone) return '—';
  if (phone.length <= 4) return '•'.repeat(phone.length);
  return `${'•'.repeat(Math.max(0, phone.length - 4))}${phone.slice(-4)}`;
}

/** Initials for an avatar fallback. */
export function initialsOf(name: string | null | undefined): string {
  if (!name) return '?';
  const parts = name.trim().split(/\s+/).slice(0, 2);
  return parts.map((p) => p.charAt(0).toUpperCase()).join('') || '?';
}

export function formatDistanceKm(km: number | null | undefined): string {
  if (km === null || km === undefined) return '—';
  if (km < 1) return `${Math.round(km * 1000)} m`;
  return `${km.toFixed(1)} km`;
}

/** A 0..1 factor score as a percentage, for the matching console. */
export function formatScore(score: number | null | undefined): string {
  if (score === null || score === undefined) return '—';
  return `${Math.round(score * 100)}%`;
}
