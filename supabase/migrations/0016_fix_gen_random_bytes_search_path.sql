-- ===========================================================================
-- 0016  Fix gen_random_bytes being unreachable from SECURITY DEFINER functions
-- ===========================================================================
-- pgcrypto is installed (0001), but Supabase-hosted projects install it into
-- the `extensions` schema, not `public`. Every SECURITY DEFINER function that
-- generates a random code — booking codes, payout codes, dispute codes,
-- referral codes, support ticket flows, and more, across 0003, 0004, 0005,
-- 0006 and 0014 — runs with `set search_path = public, pg_temp` so it cannot
-- be intercepted into doing something unsafe. That same restriction means
-- `gen_random_bytes()` was never resolvable in any of them: every one of
-- these functions has been failing with
-- "function gen_random_bytes(integer) does not exist" since it was first
-- called for real, which is why creating a booking or a support ticket both
-- failed on-device.
--
-- A thin wrapper in `public` — already on every affected function's
-- search_path — fixes all of them at once without editing each function.
create or replace function public.gen_random_bytes(integer)
returns bytea
language sql
stable
as $$
  select extensions.gen_random_bytes($1);
$$;

comment on function public.gen_random_bytes(integer) is
  'Wrapper so SECURITY DEFINER functions (search_path = public, pg_temp) can reach pgcrypto''s gen_random_bytes(), which Supabase installs into the extensions schema rather than public.';
