import 'server-only';

/**
 * Type escape hatch for calling Postgres functions that exist and are
 * callable by service_role, but are absent from the generated Database
 * types because they carry no grant to anon/authenticated — so
 * `supabase gen types` never lists them as part of the public API surface.
 * `transition_booking` and `confirm_payment` (migrations 0010/0011/0013)
 * are exactly this: internal, service-role-only functions, real and
 * grant-restricted, just not reflected in the generated types.
 *
 * Use only on a serviceClient() call, and only for a function you have
 * confirmed in the migrations — this bypasses the compiler's check that the
 * function name and parameter shape actually exist.
 */
export type SystemRpc = (
  fn: string,
  params?: Record<string, unknown>,
) => Promise<{ data: unknown; error: { message: string } | null }>;
