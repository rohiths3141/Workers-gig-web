-- ===========================================================================
-- 0020  Prototype: seed approved worker_service + disable gig review gate
-- ===========================================================================
-- Publishing a gig requires two things that block the prototype:
--
--   1. worker_upsert_gig() rejects the call unless the worker has an approved
--      worker_services row (or the service matches primary_service_id).
--      New workers have neither.
--
--   2. The platform_settings key 'gigs.require_review' defaults to true
--      (coalesce(value::boolean, true) in the function), which means every
--      submitted gig lands in PENDING_REVIEW.  worker_eligibility() only counts
--      ACTIVE gigs, so "Go available" would still be blocked even after the
--      worker published something.
--
-- This migration:
--   a) Inserts an approved worker_services row for the test worker (Plumbing)
--      and sets that as the worker's primary_service_id.
--   b) Sets gigs.require_review = false so new gigs go straight to ACTIVE.
--
-- REVERT for production: drop this migration data, re-enable require_review,
-- and let the real skills / admin-approval workflow take over.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- a) Approved trade for the test worker
-- ---------------------------------------------------------------------------
do $$
declare
  v_worker_id  uuid;
  v_service_id uuid;
begin
  -- Look up test worker by phone.
  select id into v_worker_id from public.workers where phone = '9797979797';
  if not found then
    raise notice '0020: test worker 9797979797 not found, skipping';
    return;
  end if;

  -- Use Plumbing as the prototype trade (lowest verification bar).
  select id into v_service_id from public.services where slug = 'plumbing';
  if not found then
    raise notice '0020: plumbing service not found, skipping';
    return;
  end if;

  -- Upsert an approved worker_services row.
  insert into public.worker_services (worker_id, service_id, is_approved, approved_at)
  values (v_worker_id, v_service_id, true, now())
  on conflict (worker_id, service_id)
    do update set is_approved = true, approved_at = now();

  -- Set primary_service_id so the worker satisfies the trade blocker in
  -- worker_eligibility() even if worker_services is queried differently.
  update public.workers
  set primary_service_id = v_service_id
  where id = v_worker_id
    and primary_service_id is null;

  raise notice '0020: test worker % approved for service % (plumbing)', v_worker_id, v_service_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- b) Disable gig review gate for the prototype
-- ---------------------------------------------------------------------------
-- worker_upsert_gig() reads this key; when false, p_submit=true creates a gig
-- directly as ACTIVE.  worker_eligibility() counts only ACTIVE gigs, so this
-- is required for "Go available" to become unblocked after gig creation.
insert into public.platform_settings (key, value, description, is_public)
values (
  'gigs.require_review',
  'false'::jsonb,
  'PROTOTYPE: skip ops review for new gigs so they go live immediately. Re-enable before launch.',
  false
)
on conflict (key) do update set value = excluded.value, updated_at = now();
