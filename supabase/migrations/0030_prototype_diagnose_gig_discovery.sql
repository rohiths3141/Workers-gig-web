-- =============================================================================
-- 0030 — PROTOTYPE: diagnose why customer_find_gigs returns empty
-- Prints actual worker_gigs + worker rows so we can see the mismatch.
-- =============================================================================
do $$
declare
  rec record;
  v_plumbing_id uuid;
begin
  -- What services exist?
  raise notice '=== SERVICES ===';
  for rec in select id, name, is_active from public.services order by name loop
    raise notice 'service: id=% name=% active=%', rec.id, rec.name, rec.is_active;
  end loop;

  -- What workers exist?
  raise notice '=== WORKERS ===';
  for rec in
    select w.id, w.worker_code, w.full_name, w.status, w.availability,
           p.phone, p.account_status
    from public.workers w
    join public.profiles p on p.id = w.profile_id
    order by w.created_at desc limit 5
  loop
    raise notice 'worker: id=% code=% name=% status=% phone=% profile_status=%',
      rec.id, rec.worker_code, rec.full_name, rec.status, rec.phone, rec.account_status;
  end loop;

  -- What gigs exist?
  raise notice '=== WORKER_GIGS ===';
  for rec in
    select g.id, g.worker_id, g.service_id, g.status, g.pricing_unit, g.price_minor, g.title,
           s.name as service_name
    from public.worker_gigs g
    join public.services s on s.id = g.service_id
    order by g.created_at desc limit 10
  loop
    raise notice 'gig: id=% worker_id=% service=% status=% pricing_unit=% title=%',
      rec.id, rec.worker_id, rec.service_name, rec.status, rec.pricing_unit, rec.title;
  end loop;

  -- Get plumbing service ID
  select id into v_plumbing_id from public.services where lower(name) like '%plumb%' limit 1;
  raise notice 'plumbing service_id: %', v_plumbing_id;

  -- How many ACTIVE gigs for plumbing with ACTIVE workers?
  raise notice '=== MATCHING GIGS (what find_gigs would return) ===';
  for rec in
    select g.id, g.status, g.service_id, w.status as worker_status, w.full_name
    from public.worker_gigs g
    join public.workers w on w.id = g.worker_id
    where g.service_id = v_plumbing_id
      and g.status = 'ACTIVE'
      and w.status = 'ACTIVE'
  loop
    raise notice 'match: gig_id=% worker=% w_status=%', rec.id, rec.full_name, rec.worker_status;
  end loop;
end;
$$;
