-- =============================================================================
-- 0027 — PROTOTYPE: force gig state + debug diagnostics
-- =============================================================================

do $$
declare
  rec record;
  v_plumbing_id uuid;
  v_worker_id   uuid;
begin
  -- Show all services to understand IDs
  raise notice '=== SERVICES ===';
  for rec in select id, slug, name, is_active from public.services loop
    raise notice 'service: id=% slug=% name=% active=%', rec.id, rec.slug, rec.name, rec.is_active;
  end loop;

  -- Show all workers
  raise notice '=== WORKERS ===';
  for rec in select id, phone, status, availability, latitude, longitude,
                     service_radius_km, is_kyc_verified, is_background_verified
             from public.workers loop
    raise notice 'worker: id=% phone=% status=% avail=% lat=% lng=% radius=% kyc=% bg=%',
      rec.id, rec.phone, rec.status, rec.availability,
      rec.latitude, rec.longitude, rec.service_radius_km,
      rec.is_kyc_verified, rec.is_background_verified;
  end loop;

  -- Show all gigs
  raise notice '=== GIGS ===';
  for rec in select g.id, g.worker_id, g.service_id, g.status, g.title,
                    s.slug as service_slug
             from public.worker_gigs g
             join public.services s on s.id = g.service_id loop
    raise notice 'gig: id=% worker=% service_id=% service_slug=% status=% title=%',
      rec.id, rec.worker_id, rec.service_id, rec.service_slug, rec.status, rec.title;
  end loop;

  -- Get plumbing service id
  select id into v_plumbing_id from public.services where slug = 'plumbing';
  raise notice 'Plumbing service_id = %', v_plumbing_id;

  -- Get the test worker
  select id into v_worker_id from public.workers order by created_at desc limit 1;
  raise notice 'Test worker_id = %', v_worker_id;

  -- Force insert/upsert a plumbing gig that is definitely ACTIVE
  insert into public.worker_gigs (
    worker_id, service_id, title, description,
    price_minor, pricing_unit, currency, estimated_duration_minutes,
    status
  ) values (
    v_worker_id,
    v_plumbing_id,
    'Plumbing Services – Blocked Drain & Leak Fix',
    'Expert plumbing: leaking taps, blocked drains, flush tank, pipe repairs.',
    49900,
    'FIXED',
    'INR',
    60,
    'ACTIVE'
  )
  on conflict do nothing;

  raise notice 'Inserted/verified gig for worker % on plumbing service %', v_worker_id, v_plumbing_id;
end;
$$;
