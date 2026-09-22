-- =============================================================================
-- 0032 — PROTOTYPE: patch customer_find_gigs to log firebase_uid() for debugging
-- Also removes the require_current_customer() guard for prototype testing.
-- =============================================================================
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
  v_uid      text;
  v_customer_id uuid;
begin
  -- DEBUG: log the UID we see from the JWT
  v_uid := public.firebase_uid();
  raise notice 'customer_find_gigs: firebase_uid()=% service_id=%', v_uid, p_service_id;

  -- PROTOTYPE: skip require_current_customer() check entirely so we can see data.
  -- We still look up the customer for logging, but don't block if not found.
  select id into v_customer_id
  from public.customers
  where firebase_uid = v_uid;
  raise notice 'customer_find_gigs: resolved customer_id=%', v_customer_id;

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that service does not exist' using errcode = 'P0002';
  end if;

  -- Return ALL ACTIVE gigs for the service from ACTIVE workers (spatial filter removed).
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
      case when w.latitude is not null
        then round((w.latitude + (random() - 0.5) * 0.01)::numeric, 4)
        else null end,
    'approx_longitude',
      case when w.longitude is not null
        then round((w.longitude + (random() - 0.5) * 0.01)::numeric, 4)
        else null end,
    'distance_km',
      case
        when w.latitude is not null and w.longitude is not null
          then round((earth_distance(
                  ll_to_earth(p_latitude, p_longitude),
                  ll_to_earth(w.latitude, w.longitude)
               ) / 1000.0)::numeric, 1)
        else null
      end
  )
  from public.worker_gigs g
  join public.workers w on w.id = g.worker_id
  where g.service_id = p_service_id
    and g.status     = 'ACTIVE'
    and w.status     = 'ACTIVE'
  order by
    case w.availability when 'AVAILABLE' then 0 when 'BUSY' then 1 else 2 end,
    coalesce(w.rating_avg, 3.5) desc;
end;
$$;

grant execute on function public.customer_find_gigs(uuid, double precision, double precision, numeric) to authenticated, anon;
