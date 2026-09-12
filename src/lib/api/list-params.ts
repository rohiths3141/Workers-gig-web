import { z } from 'zod';

/**
 * List query parameters.
 *
 * Every admin list is paginated by the database. The page size is capped here
 * so a crafted `?pageSize=100000` cannot be used to pull an entire table
 * through the server, and an out-of-range page is clamped rather than rejected.
 */

export const DEFAULT_PAGE_SIZE = 25;
export const MAX_PAGE_SIZE = 100;

export const listParamsSchema = z.object({
  page: z.coerce.number().int().min(1).max(10_000).catch(1),
  pageSize: z.coerce.number().int().min(1).max(MAX_PAGE_SIZE).catch(DEFAULT_PAGE_SIZE),
  q: z.string().trim().max(120).optional(),
  status: z.string().trim().max(60).optional(),
  sort: z.string().trim().max(60).optional(),
  dir: z.enum(['asc', 'desc']).catch('desc'),
});

export type ListParams = z.infer<typeof listParamsSchema>;

export type RawSearchParams = Record<string, string | string[] | undefined>;

/** Normalise Next.js searchParams into a flat string record. */
export function flattenSearchParams(params: RawSearchParams): Record<string, string | undefined> {
  const flat: Record<string, string | undefined> = {};

  for (const [key, value] of Object.entries(params)) {
    flat[key] = Array.isArray(value) ? value[0] : value;
  }

  return flat;
}

export function parseListParams(params: RawSearchParams): ListParams {
  return listParamsSchema.parse(flattenSearchParams(params));
}

/** Inclusive row range for a Supabase `.range()` call. */
export function rangeFor(page: number, pageSize: number): [number, number] {
  const from = (page - 1) * pageSize;
  return [from, from + pageSize - 1];
}

/**
 * Escape a user-supplied search term for a PostgREST `or(...)` filter.
 *
 * PostgREST parses commas, parentheses and dots as filter syntax, so an
 * unescaped term can change the meaning of the query rather than just its
 * value. Stripping them keeps the search a search.
 */
export function sanitiseSearchTerm(term: string | undefined): string | null {
  if (!term) return null;

  const cleaned = term.replace(/[(),.*\\]/g, ' ').trim();
  return cleaned.length > 0 ? cleaned : null;
}

/**
 * Narrow a query-string value to a known enum member.
 *
 * A filter value arrives from the URL, so it is user input. Anything not in the
 * allowed set becomes `undefined` — the filter is dropped rather than passed
 * through to the database — which both satisfies the type checker and stops a
 * crafted value reaching the query.
 */
export function asEnumValue<T extends string>(
  value: string | undefined,
  allowed: Record<string, T>,
): T | undefined {
  if (!value) return undefined;
  const members = Object.values(allowed) as string[];
  return members.includes(value) ? (value as T) : undefined;
}

/** Count how many filters are active, for the "clear filters" control. */
export function countActiveFilters(
  params: Record<string, string | undefined>,
  keys: readonly string[],
): number {
  return keys.filter((key) => Boolean(params[key])).length;
}

/** Build `{ value, label }` options from an enum-like object. */
export function optionsFromEnum(
  source: Record<string, string>,
  labeller: (value: string) => string,
): Array<{ value: string; label: string }> {
  return Object.values(source).map((value) => ({ value, label: labeller(value) }));
}
