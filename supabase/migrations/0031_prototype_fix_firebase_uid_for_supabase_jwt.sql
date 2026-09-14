-- =============================================================================
-- 0031 — PROTOTYPE: fix firebase_uid() to work with Supabase Third-Party Auth
-- =============================================================================
-- The current firebase_uid() requires:
--   v_iss like 'https://securetoken.google.com/%'
-- But when using Supabase Third-Party Auth (Firebase), Supabase issues its own
-- JWT. The iss is 'https://<project>.supabase.co/auth/v1', not Google's domain.
-- The sub claim IS the Firebase UID (Supabase maps it from the Firebase token).
--
-- Fix: accept the sub claim from ANY JWT that PostgREST presents, since
-- PostgREST only presents tokens that Supabase's Auth service has validated.
-- The security model relies on Supabase validating the Firebase token before
-- issuing its own JWT, not on the iss check in Postgres.
-- =============================================================================

create or replace function public.firebase_uid()
returns text
language plpgsql
stable
set search_path = public, pg_temp
as $$
declare
  v_claims jsonb;
  v_sub    text;
  v_iss    text;
begin
  -- Read JWT claims set by PostgREST (already validated by Supabase Auth).
  begin
    v_claims := nullif(current_setting('request.jwt.claims', true), '')::jsonb;
  exception when others then
    v_claims := null;
  end;

  if v_claims is not null then
    v_sub := v_claims ->> 'sub';
    v_iss := v_claims ->> 'iss';

    -- Accept Firebase tokens presented directly (worker-app flow).
    if v_sub is not null and v_iss like 'https://securetoken.google.com/%' then
      return v_sub;
    end if;

    -- PROTOTYPE: Also accept Supabase-issued JWTs (Third-Party Auth flow).
    -- Supabase has already validated the Firebase token and maps sub = Firebase UID.
    -- The iss will be the Supabase project URL.
    if v_sub is not null and v_iss like 'https://%supabase.co%' then
      return v_sub;
    end if;

    -- Fallback: accept any non-null sub from a JWT (PostgREST already verified it).
    -- This is safe because PostgREST never presents unvalidated tokens to Postgres.
    if v_sub is not null then
      return v_sub;
    end if;
  end if;

  -- Path 2: trusted backend set firebase_uid GUC directly (server-side calls).
  return nullif(current_setting('request.firebase_uid', true), '');
end;
$$;
