-- ===========================================================================
-- 0063  admin_approve_worker_all: clear every admin gate in one action
-- ---------------------------------------------------------------------------
-- Getting a new worker to the point where they can take jobs meant an
-- operator approving identity, waiting for the background check to open,
-- approving that, approving each trade and pending service, and finally
-- activating the account — five screens for one decision.
--
-- This does all of it in one transaction, for operators who have already
-- decided to trust this worker:
--
--   1. IDENTITY_KYC and BACKGROUND_CHECK are approved, created if the worker
--      never submitted them. Identity goes first so the 0046 trigger that
--      opens the background check has run before it is approved.
--   2. Every other case the worker has submitted and is waiting on (PENDING,
--      UNDER_REVIEW, MORE_INFO_REQUIRED) is approved.
--   3. Every requested trade is approved. Matching only offers a job to a
--      worker whose worker_services row for that trade is approved.
--   4. Every service awaiting review goes live.
--   5. A REGISTERED or VERIFICATION_PENDING account becomes ACTIVE.
--
-- It does not touch an account that has been restricted, suspended,
-- deactivated or rejected: that was a deliberate decision, and reversing it is
-- the Reinstate action, with its own reason. Nor can it do the worker's own
-- steps (trade, service area, a published service); the eligibility it
-- returns says which of those are still missing.
--
-- Requires both verification.approve and workers.restrict, the permissions
-- of the individual actions it replaces. Each step writes its usual audit
-- row, plus one summary row carrying the reason.
-- ===========================================================================

create or replace function public.admin_approve_worker_all(
  p_worker_id uuid,
  p_reason    text
)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id   uuid;
  v_worker     public.workers%rowtype;
  v_case       public.worker_verifications%rowtype;
  v_gig        public.worker_gigs%rowtype;
  v_approved   text[] := '{}';
  v_trades     integer;
  v_gigs       integer := 0;
  v_old_status public.worker_status;
begin
  v_admin_id := public.require_permission('verification.approve');
  perform public.require_permission('workers.restrict');

  if p_reason is null or length(btrim(p_reason)) < 10 then
    raise exception 'INVALID: approving everything for a worker requires a reason of at least 10 characters'
      using errcode = '23514';
  end if;

  select * into v_worker from public.workers where id = p_worker_id for update;
  if not found then
    raise exception 'NOT_FOUND: worker % does not exist', p_worker_id using errcode = 'P0002';
  end if;

  if v_worker.firebase_uid = public.firebase_uid() then
    raise exception 'FORBIDDEN: a worker may not approve their own account'
      using errcode = '42501';
  end if;

  if v_worker.status in ('RESTRICTED', 'SUSPENDED', 'DEACTIVATED', 'REJECTED') then
    raise exception 'CONFLICT: this worker is %; reinstate them before approving', v_worker.status
      using errcode = '23505';
  end if;

  v_old_status := v_worker.status;

  -- 1 & 2. The two required checks always exist after this, so the loop below
  -- can treat them like any other case.
  insert into public.worker_verifications (worker_id, type, status)
  values (p_worker_id, 'IDENTITY_KYC', 'NOT_SUBMITTED'),
         (p_worker_id, 'BACKGROUND_CHECK', 'NOT_SUBMITTED')
  on conflict (worker_id, type) do nothing;

  for v_case in
    select *
    from public.worker_verifications
    where worker_id = p_worker_id
      and (
        (type in ('IDENTITY_KYC', 'BACKGROUND_CHECK')
          and not (status = 'APPROVED' and (expires_at is null or expires_at > now())))
        or status in ('PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED')
      )
    -- Identity first: approving it opens the background check (0046).
    order by (type = 'IDENTITY_KYC') desc, type
    for update
  loop
    update public.worker_verifications
    set status           = 'APPROVED',
        submitted_at     = coalesce(submitted_at, now()),
        reviewed_by      = v_admin_id,
        reviewed_at      = now(),
        decision_note    = btrim(p_reason),
        rejection_reason = null,
        info_requested   = null,
        expires_at       = null
    where id = v_case.id;

    perform public.write_audit_log(
      'verification.approve',
      'worker_verification',
      v_case.id::text,
      jsonb_build_object('status', v_case.status, 'expires_at', v_case.expires_at),
      jsonb_build_object('status', 'APPROVED', 'expires_at', null),
      btrim(p_reason)
    );

    v_approved := v_approved || v_case.type::text;
  end loop;

  -- 3. Trades.
  update public.worker_services
  set is_approved = true,
      approved_by = v_admin_id,
      approved_at = now()
  where worker_id = p_worker_id and not is_approved;
  get diagnostics v_trades = row_count;

  -- 4. Services waiting for review.
  for v_gig in
    select * from public.worker_gigs
    where worker_id = p_worker_id and status = 'PENDING_REVIEW'
    for update
  loop
    update public.worker_gigs
    set status           = 'ACTIVE',
        reviewed_by      = v_admin_id,
        reviewed_at      = now(),
        rejection_reason = null
    where id = v_gig.id;

    perform public.write_audit_log(
      'gig.approve',
      'worker_gig',
      v_gig.id::text,
      jsonb_build_object('status', 'PENDING_REVIEW'),
      jsonb_build_object('status', 'ACTIVE'),
      btrim(p_reason)
    );
    v_gigs := v_gigs + 1;
  end loop;

  -- 5. The account.
  if v_old_status in ('REGISTERED', 'VERIFICATION_PENDING') then
    update public.workers
    set status = 'ACTIVE'
    where id = p_worker_id;

    perform public.write_audit_log(
      'worker.status_changed', 'worker', p_worker_id::text,
      jsonb_build_object('status', v_old_status),
      jsonb_build_object('status', 'ACTIVE'),
      btrim(p_reason)
    );
  end if;

  perform public.write_audit_log(
    'worker.approve_all', 'worker', p_worker_id::text,
    jsonb_build_object('status', v_old_status),
    jsonb_build_object(
      'status', case when v_old_status in ('REGISTERED', 'VERIFICATION_PENDING')
                     then 'ACTIVE' else v_old_status::text end,
      'verifications', to_jsonb(v_approved),
      'trades', v_trades,
      'gigs', v_gigs),
    btrim(p_reason)
  );

  return jsonb_build_object(
    'approved_verifications', to_jsonb(v_approved),
    'approved_trades', v_trades,
    'approved_gigs', v_gigs,
    -- Read after the changes above, so what remains is the worker's own.
    'eligibility', public.worker_eligibility(p_worker_id)
  );
end;
$$;

revoke all on function public.admin_approve_worker_all(uuid, text) from public, anon;
grant execute on function public.admin_approve_worker_all(uuid, text) to authenticated;
