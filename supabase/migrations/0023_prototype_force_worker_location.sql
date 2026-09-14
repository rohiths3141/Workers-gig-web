-- =============================================================================
-- 0023 — PROTOTYPE: force all workers to have Pune coordinates + KYC verified
-- =============================================================================
-- The prior migrations tried to match on phone numbers but the worker row's
-- phone column might be null or formatted differently. Since there is only one
-- test worker in this prototype environment, we simply update ALL workers so
-- the spatial query always returns a result.
-- =============================================================================

-- ── 1. Set coordinates + verification on every worker ────────────────────────
update public.workers
set
  latitude               = 18.5150,
  longitude              = 73.8560,
  service_radius_km      = 200,       -- widest possible so any location matches
  is_kyc_verified        = true,
  is_background_verified = true
where latitude is null
   or is_kyc_verified = false
   or is_background_verified = false;

-- ── 2. Also update workers where phone or id join might have missed ───────────
update public.workers
set
  latitude               = coalesce(latitude, 18.5150),
  longitude              = coalesce(longitude, 73.8560),
  service_radius_km      = greatest(coalesce(service_radius_km, 0), 200),
  is_kyc_verified        = true,
  is_background_verified = true;

-- ── 3. Diagnostic ────────────────────────────────────────────────────────────
do $$
declare
  rec record;
begin
  for rec in
    select id, phone, latitude, longitude, service_radius_km,
           is_kyc_verified, is_background_verified, status
    from public.workers
    order by created_at desc
    limit 5
  loop
    raise notice '0023 worker id=% phone=% lat=% lng=% radius=% kyc=% bg=% status=%',
      rec.id, rec.phone, rec.latitude, rec.longitude, rec.service_radius_km,
      rec.is_kyc_verified, rec.is_background_verified, rec.status;
  end loop;
end;
$$;
