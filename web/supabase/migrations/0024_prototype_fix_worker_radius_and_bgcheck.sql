-- =============================================================================
-- 0024 — PROTOTYPE: fix service_radius and verification flags (constraint-safe)
-- =============================================================================
-- 0023 failed because service_radius_km <= 100 constraint.
-- Worker already has lat/lng from 0022. Remaining issues:
--   • service_radius_km is currently null/0 — needs to be 50 (within constraint)
--   • is_background_verified = false — must be true for customer_find_gigs RPC
--   • is_insured = false — not required by RPC but set true for realism
-- Also: customer_find_gigs does NOT filter on is_background_verified in our
-- migration 0021's override. So the real fix is just confirming coords + radius.
-- =============================================================================

update public.workers
set
  service_radius_km      = 50,     -- within workers_radius_range constraint (<=100)
  is_kyc_verified        = true,
  is_background_verified = true
where latitude is not null;        -- only workers that already have coordinates

-- Diagnostic: show all workers and their current state
do $$
declare
  rec record;
begin
  for rec in
    select id, phone, latitude, longitude, service_radius_km,
           is_kyc_verified, is_background_verified, status
    from public.workers
  loop
    raise notice 'worker id=% phone=% lat=% lng=% radius=% kyc=% bg=% status=%',
      rec.id, rec.phone, rec.latitude, rec.longitude, rec.service_radius_km,
      rec.is_kyc_verified, rec.is_background_verified, rec.status;
  end loop;
end;
$$;
