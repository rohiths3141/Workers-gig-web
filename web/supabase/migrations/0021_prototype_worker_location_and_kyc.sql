-- =============================================================================
-- 0021 — PROTOTYPE: seed test worker location + verification flags
-- =============================================================================
-- Purpose:
--   customer_find_gigs() requires the worker to have:
--     • latitude / longitude NOT NULL   (spatial proximity check)
--     • is_kyc_verified = true
--     • is_background_verified = true
--   The test worker (9797979797) has none of these. This migration seeds
--   plausible Pune coordinates and sets the verification flags, so that the
--   customer-side gig-discovery flow finds at least one result in testing.
--
--   Also overrides customer_find_gigs() to loosen the KYC filter to a simple
--   coalesce(true) bypass for prototype builds — mirroring what 0019 did for
--   the worker-side eligibility.
-- =============================================================================

-- ── 1. Seed test worker with coordinates near Wadgaon / Pune ─────────────────
--    HXV7+F5J (where the customer pin landed) ≈ 18.5130°N, 73.8540°E (Pune)
--    We place the test worker 2 km away so it falls within the default 5 km UI
--    radius and within a generous service_radius_km.
update public.workers
set
  latitude             = 18.5150,
  longitude            = 73.8560,
  service_radius_km    = 50,   -- wide radius so any Pune customer matches
  is_kyc_verified      = true,
  is_background_verified = true
where id in (
  -- Resolve by the Firebase UID stored on the linked auth user.
  -- The workers.id is a UUID FK to auth.users; we match by phone via profiles.
  select w.id
  from   public.workers w
  join   public.profiles p on p.id = w.id
  where  p.phone = '9797979797'
);

-- ── 2. Override customer_find_gigs to bypass KYC gate for prototype builds ───
--    Remove the hard `and w.is_kyc_verified and w.is_background_verified`
--    filter so any worker with coordinates and ACTIVE status shows up.
--    We keep the real proximity check so the spatial logic is still exercised.
create or replace function public.customer_find_gigs(
  p_service_id  uuid,
  p_latitude    double precision,
  p_longitude   double precision,
  p_radius_km   numeric default 25
)
returns setof jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_max_km   numeric;
begin
  v_customer := public.require_current_customer();

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that service does not exist' using errcode = 'P0002';
  end if;

  v_max_km := least(
    greatest(coalesce(p_radius_km, 25), 1),
    coalesce(
      (select value::numeric from public.platform_settings where key = 'matching.max_radius_km'),
      200   -- raise platform cap to 200 km for prototype so a Pune worker always shows
    )
  );

  return query
  select jsonb_build_object(
    'gig_id',          g.id,
    'title',           g.title,
    'description',     g.description,
    'price_minor',     g.price_minor,
    'pricing_unit',    g.pricing_unit,
    'currency',        'INR',
    'estimated_duration_minutes', g.estimated_duration_minutes,
    'worker_id',       w.id,
    'worker_code',     w.worker_code,
    'worker_name',     w.full_name,
    'worker_rating',   w.rating_avg,
    'worker_rating_count', w.rating_count,
    'worker_jobs_completed', w.jobs_completed,
    'is_kyc_verified', w.is_kyc_verified,
    'is_background_verified', w.is_background_verified,
    'is_insured',      w.is_insured,
    'experience_years', w.experience_years,
    'bio',             w.bio,
    'city',            w.city,
    'approx_latitude',
      round((w.latitude + (random() - 0.5) * 0.01)::numeric, 4),
    'approx_longitude',
      round((w.longitude + (random() - 0.5) * 0.01)::numeric, 4),
    'distance_km',
      round((earth_distance(
        ll_to_earth(p_latitude, p_longitude),
        ll_to_earth(w.latitude, w.longitude)
      ) / 1000.0)::numeric, 1)
  )
  from public.worker_gigs g
  join public.workers w on w.id = g.worker_id
  where g.service_id  = p_service_id
    and g.status      = 'ACTIVE'
    and w.status      = 'ACTIVE'
    -- PROTOTYPE: KYC/background check bypassed via UPDATE above, but we do NOT
    -- filter on those flags so even un-verified workers appear in discovery.
    and w.latitude    is not null
    and w.longitude   is not null
    and earth_box(ll_to_earth(p_latitude, p_longitude), v_max_km * 1000)
        @> ll_to_earth(w.latitude, w.longitude)
    and (earth_distance(
           ll_to_earth(p_latitude, p_longitude),
           ll_to_earth(w.latitude, w.longitude)
         ) / 1000.0) <= least(v_max_km, w.service_radius_km)
  order by
    case w.availability when 'AVAILABLE' then 0 when 'BUSY' then 1 else 2 end,
    coalesce(w.rating_avg, 3.5) desc,
    earth_distance(
      ll_to_earth(p_latitude, p_longitude),
      ll_to_earth(w.latitude, w.longitude)
    );
end;
$$;

grant execute on function public.customer_find_gigs(uuid, double precision, double precision, numeric) to authenticated;
