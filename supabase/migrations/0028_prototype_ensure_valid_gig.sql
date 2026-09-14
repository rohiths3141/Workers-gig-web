-- =============================================================================
-- 0028 — PROTOTYPE: ensure valid gig exists for test worker
-- =============================================================================
-- pricing_unit must be in ('PER_JOB', 'PER_HOUR', 'PER_DAY', 'PER_UNIT', 'PER_SQFT')
-- We use PER_JOB for a fixed-price service job.
-- Also set all worker_gigs for this worker to ACTIVE on the plumbing service.
-- =============================================================================

do $$
declare
  v_plumbing_id uuid;
  v_worker_id   uuid;
  v_gig_count   int;
  rec           record;
begin
  -- Plumbing service id
  select id into v_plumbing_id from public.services where slug = 'plumbing';
  raise notice 'plumbing_id=%', v_plumbing_id;

  -- Most recently created worker (our test worker)
  select id into v_worker_id from public.workers order by created_at desc limit 1;
  raise notice 'worker_id=%', v_worker_id;

  -- Fix any existing gig to be ACTIVE and on plumbing
  update public.worker_gigs
  set service_id = v_plumbing_id,
      status     = 'ACTIVE'
  where worker_id = v_worker_id;

  get diagnostics v_gig_count = row_count;
  raise notice 'Updated % existing gig(s) to ACTIVE', v_gig_count;

  -- Count gigs on plumbing after update
  select count(*) into v_gig_count
  from public.worker_gigs
  where worker_id = v_worker_id and service_id = v_plumbing_id and status = 'ACTIVE';
  raise notice 'Active plumbing gigs after update: %', v_gig_count;

  -- If still none, insert one
  if v_gig_count = 0 then
    insert into public.worker_gigs (
      worker_id, service_id, title, description,
      price_minor, pricing_unit, currency, estimated_duration_minutes,
      status
    ) values (
      v_worker_id,
      v_plumbing_id,
      'Plumbing Services – Drain & Leak Expert',
      'Expert plumbing: leaking taps, blocked drains, flush tank, pipe repairs.',
      49900,
      'PER_JOB',
      'INR',
      60,
      'ACTIVE'
    );
    raise notice 'Inserted new ACTIVE gig for worker %', v_worker_id;
  end if;

  -- Final state
  for rec in
    select g.id, g.service_id, g.status, g.title, g.pricing_unit
    from public.worker_gigs g
    where g.worker_id = v_worker_id
  loop
    raise notice 'Final gig: id=% service=% status=% unit=% title=%',
      rec.id, rec.service_id, rec.status, rec.pricing_unit, rec.title;
  end loop;
end;
$$;
