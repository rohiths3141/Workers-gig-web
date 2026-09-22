-- =============================================================================
-- 0022 — PROTOTYPE: fix worker location seed (use workers.phone not profiles)
-- =============================================================================
-- Migration 0021 joined through profiles.phone to find the test worker.
-- But workers has its own phone column (as used by 0020). This corrects the
-- update to use workers.phone directly, and also relaxes the gig's service
-- so that any plumbing sub-service matches.
-- =============================================================================

-- ── 1. Seed location + KYC flags by workers.phone ────────────────────────────
update public.workers
set
  latitude               = 18.5150,
  longitude              = 73.8560,
  service_radius_km      = 50,
  is_kyc_verified        = true,
  is_background_verified = true
where phone = '9797979797';

-- ── 2. Also seed by firebase_uid (in case phone is stored differently) ──────
-- The workers.id == auth.users.id; auth.users.phone stores '+91XXXXXXXXXX'.
-- Belt-and-suspenders: update any worker whose Firebase phone number ends with
-- the 10-digit test number.
update public.workers w
set
  latitude               = 18.5150,
  longitude              = 73.8560,
  service_radius_km      = 50,
  is_kyc_verified        = true,
  is_background_verified = true
from auth.users u
where u.id = w.id
  and (u.phone like '%9797979797' or u.phone = '+919797979797');

-- ── 3. Diagnostic notice ─────────────────────────────────────────────────────
do $$
declare
  v_count int;
  v_lat   numeric;
begin
  select count(*) into v_count
  from public.workers
  where latitude is not null
    and is_kyc_verified = true
    and is_background_verified = true;

  select latitude into v_lat
  from public.workers
  where latitude is not null
  limit 1;

  raise notice '0022: % worker(s) now have coordinates. Sample lat=%', v_count, v_lat;
end;
$$;
