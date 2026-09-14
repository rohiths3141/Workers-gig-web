-- =============================================================================
-- 0026 — PROTOTYPE: ensure test worker gig is on the correct plumbing service
-- =============================================================================
-- The customer picks services by slug 'plumbing' (ID 8d222063-...).
-- The test worker's gig must have that exact service_id.
-- Also: verify the gig is ACTIVE and the worker is ACTIVE/AVAILABLE.
-- =============================================================================

do $$
declare
  v_service_id  uuid;
  v_worker_id   uuid;
  v_gig_id      uuid;
  v_gig_count   int;
begin
  -- The plumbing service ID the customer app uses.
  select id into v_service_id from public.services where slug = 'plumbing';
  if not found then
    raise exception '0026: plumbing service not found';
  end if;
  raise notice '0026: plumbing service_id = %', v_service_id;

  -- Find the test worker (any worker in this prototype DB).
  select id into v_worker_id from public.workers order by created_at desc limit 1;
  if not found then
    raise exception '0026: no workers found';
  end if;
  raise notice '0026: test worker_id = %', v_worker_id;

  -- Count their gigs.
  select count(*) into v_gig_count from public.worker_gigs where worker_id = v_worker_id;
  raise notice '0026: worker has % gig(s)', v_gig_count;

  -- If the worker has a gig but it's on the wrong service, fix it.
  update public.worker_gigs
  set service_id = v_service_id,
      status = 'ACTIVE'
  where worker_id = v_worker_id
    and service_id <> v_service_id;

  -- If worker has no gig at all, create one.
  if v_gig_count = 0 then
    insert into public.worker_gigs (
      worker_id, service_id, title, description,
      price_minor, pricing_unit, currency, estimated_duration_minutes,
      status
    ) values (
      v_worker_id,
      v_service_id,
      'Plumbing Services – Leak Fix & Drain Unblock',
      'Expert plumbing services: leaking taps, blocked drains, pipe repairs.',
      49900,   -- ₹499.00
      'FIXED',
      'INR',
      60,
      'ACTIVE'
    );
    raise notice '0026: created new gig for worker %', v_worker_id;
  end if;

  -- Show final state.
  for v_gig_id in
    select id from public.worker_gigs where worker_id = v_worker_id
  loop
    raise notice '0026: gig id=% service_id=% status=%',
      v_gig_id,
      (select service_id from public.worker_gigs where id = v_gig_id),
      (select status     from public.worker_gigs where id = v_gig_id);
  end loop;
end;
$$;
