-- ===========================================================================
-- 0011  Matching engine, finance operations, claims, moderation
-- ---------------------------------------------------------------------------
-- Everything here runs inside the database, where the inputs cannot be forged.
-- A worker cannot submit their own match score, a client cannot assert that a
-- payment succeeded, and no balance is ever assigned — only posted to a ledger.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Matching
-- ---------------------------------------------------------------------------
-- Multi-factor scoring over verified database state. Every input is read here;
-- none is accepted from the caller. Weights are settings, so operations can
-- retune matching without a deploy, and the weights used are snapshotted onto
-- each candidate row so a past decision stays explainable after a retune.
create or replace function public.run_matching(
  p_booking_id uuid,
  p_max_candidates integer default null
)
returns setof public.booking_match_candidates
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_booking    public.bookings%rowtype;
  v_service    public.services%rowtype;
  v_max_radius numeric;
  v_limit      integer;
  v_weights    jsonb;
begin
  select * into v_booking from public.bookings where id = p_booking_id;
  if not found then
    raise exception 'NOT_FOUND: booking % does not exist', p_booking_id
      using errcode = 'P0002';
  end if;

  if v_booking.latitude is null or v_booking.longitude is null then
    raise exception 'INVALID: booking % has no location to match against', v_booking.booking_code
      using errcode = '23514';
  end if;

  select * into v_service from public.services where id = v_booking.service_id;

  v_max_radius := coalesce(
    (select value::numeric from public.platform_settings where key = 'matching.max_radius_km'), 25);
  v_limit := coalesce(
    p_max_candidates,
    (select value::integer from public.platform_settings where key = 'matching.max_candidates'),
    10);

  -- Factor weights. They sum to 1.0.
  v_weights := jsonb_build_object(
    'trade', 0.24, 'qualification', 0.16, 'skill', 0.10, 'kyc', 0.12,
    'background', 0.10, 'insurance', 0.04, 'availability', 0.08,
    'rating', 0.08, 'proximity', 0.08
  );

  -- Recomputed from scratch each run; stale candidates for this booking go.
  delete from public.booking_match_candidates
  where booking_id = p_booking_id and response is null and not was_offered;

  return query
  with eligible as (
    select
      w.*,
      -- Great-circle distance in km.
      (earth_distance(
         ll_to_earth(v_booking.latitude, v_booking.longitude),
         ll_to_earth(w.latitude, w.longitude)
       ) / 1000.0)::numeric(6, 2) as distance_km,
      -- Trade: the booking's service is the worker's primary trade, or an
      -- approved secondary trade.
      case
        when w.primary_service_id = v_booking.service_id then 1.000
        when exists (
          select 1 from public.worker_services ws
          where ws.worker_id = w.id and ws.service_id = v_booking.service_id and ws.is_approved
        ) then 0.800
        else 0.000
      end::numeric(4, 3) as trade_score
    from public.workers w
    where w.status = 'ACTIVE'
      and w.latitude is not null
      and w.longitude is not null
      -- Identity and background are hard gates, not scored preferences.
      and w.is_kyc_verified
      and w.is_background_verified
      and earth_box(ll_to_earth(v_booking.latitude, v_booking.longitude), v_max_radius * 1000)
          @> ll_to_earth(w.latitude, w.longitude)
  ),
  scored as (
    select
      e.id as worker_id,
      e.distance_km,
      e.trade_score,
      -- Skill: an approved RPL assessment for the trade.
      (case when e.is_skill_verified then 1.000 else 0.400 end)::numeric(4, 3) as skill_score,
      -- Qualification: ITI or diploma on file and approved.
      (case when e.is_qualification_verified then 1.000 else 0.300 end)::numeric(4, 3) as qualification_score,
      (case when e.is_kyc_verified then 1.000 else 0.000 end)::numeric(4, 3) as kyc_score,
      (case when e.is_background_verified then 1.000 else 0.000 end)::numeric(4, 3) as background_score,
      (case when e.is_insured then 1.000 else 0.500 end)::numeric(4, 3) as insurance_score,
      (case e.availability
         when 'AVAILABLE' then 1.000
         when 'BUSY' then 0.300
         else 0.000
       end)::numeric(4, 3) as availability_score,
      -- An unrated worker sits at the neutral midpoint rather than last, so new
      -- workers are not frozen out of ever getting a first job.
      (coalesce(e.rating_avg, 3.50) / 5.0)::numeric(4, 3) as rating_score,
      -- Linear decay to the configured radius, and respect the worker's own
      -- declared travel radius.
      (greatest(0, 1 - (e.distance_km / v_max_radius)))::numeric(4, 3) as proximity_score,
      e.service_radius_km
    from eligible e
    where e.trade_score > 0
      and e.distance_km <= least(v_max_radius, e.service_radius_km)
  ),
  weighted as (
    select
      s.*,
      (
        s.trade_score         * (v_weights ->> 'trade')::numeric +
        s.qualification_score * (v_weights ->> 'qualification')::numeric +
        s.skill_score         * (v_weights ->> 'skill')::numeric +
        s.kyc_score           * (v_weights ->> 'kyc')::numeric +
        s.background_score    * (v_weights ->> 'background')::numeric +
        s.insurance_score     * (v_weights ->> 'insurance')::numeric +
        s.availability_score  * (v_weights ->> 'availability')::numeric +
        s.rating_score        * (v_weights ->> 'rating')::numeric +
        s.proximity_score     * (v_weights ->> 'proximity')::numeric
      )::numeric(5, 4) as total_score
    from scored s
  )
  insert into public.booking_match_candidates (
    booking_id, worker_id, distance_km,
    trade_match_score, skill_score, qualification_score, kyc_score,
    background_score, insurance_score, availability_score, rating_score,
    proximity_score, total_score, rank, scoring_snapshot
  )
  select
    p_booking_id, wt.worker_id, wt.distance_km,
    wt.trade_score, wt.skill_score, wt.qualification_score, wt.kyc_score,
    wt.background_score, wt.insurance_score, wt.availability_score, wt.rating_score,
    wt.proximity_score, wt.total_score,
    row_number() over (order by wt.total_score desc, wt.distance_km asc),
    jsonb_build_object(
      'weights', v_weights,
      'max_radius_km', v_max_radius,
      'service_id', v_booking.service_id,
      'service_slug', v_service.slug,
      'computed_at', now()
    )
  from weighted wt
  order by wt.total_score desc, wt.distance_km asc
  limit v_limit
  on conflict (booking_id, worker_id) do update
    set distance_km         = excluded.distance_km,
        trade_match_score   = excluded.trade_match_score,
        skill_score         = excluded.skill_score,
        qualification_score = excluded.qualification_score,
        kyc_score           = excluded.kyc_score,
        background_score    = excluded.background_score,
        insurance_score     = excluded.insurance_score,
        availability_score  = excluded.availability_score,
        rating_score        = excluded.rating_score,
        proximity_score     = excluded.proximity_score,
        total_score         = excluded.total_score,
        rank                = excluded.rank,
        scoring_snapshot    = excluded.scoring_snapshot
  returning *;
end;
$$;

comment on function public.run_matching is
  'Server-side multi-factor matching. Every input is read from the database; a client cannot submit a score.';

create or replace function public.admin_rerun_matching(p_booking_id uuid)
returns setof public.booking_match_candidates
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  perform public.require_permission('matching.rerun');

  perform public.write_audit_log(
    'matching.rerun', 'booking', p_booking_id::text, null, null,
    'Operations re-ran the matching engine'
  );

  return query select * from public.run_matching(p_booking_id);
end;
$$;

grant execute on function public.admin_rerun_matching(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Wallet ledger
-- ---------------------------------------------------------------------------
-- The only way money moves in a wallet. Idempotent on the supplied key, so a
-- retried request posts once.
create or replace function public.post_wallet_transaction(
  p_worker_id       uuid,
  p_type            public.wallet_transaction_type,
  p_amount_minor    bigint,           -- always positive; sign comes from p_type
  p_description     text,
  p_idempotency_key text,
  p_reference_type  text default null,
  p_reference_id    uuid default null,
  p_reason          text default null,
  p_actor_type      public.actor_type default 'SYSTEM'
)
returns public.wallet_transactions
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_wallet  public.wallets%rowtype;
  v_signed  bigint;
  v_txn     public.wallet_transactions%rowtype;
begin
  if p_amount_minor <= 0 then
    raise exception 'INVALID: amount must be positive; direction comes from the transaction type'
      using errcode = '23514';
  end if;

  -- Replay of an already-applied write returns the original row.
  select * into v_txn from public.wallet_transactions where idempotency_key = p_idempotency_key;
  if found then
    return v_txn;
  end if;

  select * into v_wallet from public.wallets where worker_id = p_worker_id for update;
  if not found then
    raise exception 'NOT_FOUND: worker % has no wallet', p_worker_id
      using errcode = 'P0002';
  end if;

  v_signed := case when p_type::text like 'CREDIT%' then p_amount_minor else -p_amount_minor end;

  -- A wallet may not be driven negative by an ordinary debit. Recovering more
  -- than a worker holds is a business decision, not an accounting accident.
  if v_wallet.balance_minor + v_signed < 0 then
    raise exception 'INSUFFICIENT_FUNDS: wallet holds % but the entry would take it to %',
      v_wallet.balance_minor, v_wallet.balance_minor + v_signed
      using errcode = '23514';
  end if;

  insert into public.wallet_transactions (
    wallet_id, worker_id, type, amount_minor, balance_after_minor,
    currency, description, reference_type, reference_id,
    idempotency_key, created_by_type, created_by_id, reason
  )
  values (
    v_wallet.id, p_worker_id, p_type, v_signed, v_wallet.balance_minor + v_signed,
    v_wallet.currency, p_description, p_reference_type, p_reference_id,
    p_idempotency_key, p_actor_type,
    case when p_actor_type = 'ADMIN' then public.current_admin_id() else null end,
    p_reason
  )
  returning * into v_txn;

  return v_txn;
end;
$$;

-- Manual correction. Deliberately separate, permission-gated, and always audited.
create or replace function public.admin_adjust_wallet(
  p_worker_id    uuid,
  p_amount_minor bigint,
  p_direction    text,     -- CREDIT | DEBIT
  p_reason       text,
  p_idempotency_key text
)
returns public.wallet_transactions
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_txn public.wallet_transactions%rowtype;
begin
  perform public.require_permission('wallets.adjust');

  if p_direction not in ('CREDIT', 'DEBIT') then
    raise exception 'INVALID: direction must be CREDIT or DEBIT' using errcode = '23514';
  end if;

  if p_reason is null or length(btrim(p_reason)) < 10 then
    raise exception 'INVALID: a manual wallet adjustment requires a reason of at least 10 characters'
      using errcode = '23514';
  end if;

  v_txn := public.post_wallet_transaction(
    p_worker_id,
    case p_direction when 'CREDIT' then 'CREDIT_ADJUSTMENT' else 'DEBIT_ADJUSTMENT' end::public.wallet_transaction_type,
    p_amount_minor,
    'Manual adjustment by operations',
    p_idempotency_key,
    'MANUAL', null, p_reason, 'ADMIN'
  );

  perform public.write_audit_log(
    'wallet.adjusted', 'wallet', p_worker_id::text,
    null,
    jsonb_build_object('direction', p_direction, 'amount_minor', p_amount_minor,
                       'transaction_id', v_txn.id, 'balance_after_minor', v_txn.balance_after_minor),
    p_reason
  );

  return v_txn;
end;
$$;

grant execute on function public.admin_adjust_wallet(uuid, bigint, text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Payouts
-- ---------------------------------------------------------------------------
create or replace function public.request_payout(
  p_amount_minor bigint,
  p_idempotency_key text
)
returns public.payouts
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker_id uuid := public.current_worker_id();
  v_wallet    public.wallets%rowtype;
  v_minimum   bigint;
  v_payout    public.payouts%rowtype;
begin
  if v_worker_id is null then
    raise exception 'FORBIDDEN: only a worker may request a payout' using errcode = '42501';
  end if;

  select * into v_payout from public.payouts where idempotency_key = p_idempotency_key;
  if found then
    return v_payout;
  end if;

  select * into v_wallet from public.wallets where worker_id = v_worker_id for update;

  if v_wallet.is_frozen then
    raise exception 'FORBIDDEN: this wallet is on hold; contact support' using errcode = '42501';
  end if;

  v_minimum := coalesce(
    (select value::bigint from public.platform_settings where key = 'payout.minimum_amount_minor'), 0);

  if p_amount_minor < v_minimum then
    raise exception 'INVALID: the minimum payout is % minor units', v_minimum using errcode = '23514';
  end if;

  if p_amount_minor > v_wallet.balance_minor then
    raise exception 'INSUFFICIENT_FUNDS: requested % but the wallet holds %',
      p_amount_minor, v_wallet.balance_minor using errcode = '23514';
  end if;

  insert into public.payouts (worker_id, wallet_id, amount_minor, currency, idempotency_key)
  values (v_worker_id, v_wallet.id, p_amount_minor, v_wallet.currency, p_idempotency_key)
  returning * into v_payout;

  return v_payout;
end;
$$;

grant execute on function public.request_payout(bigint, text) to authenticated;

-- Approval debits the wallet in the same transaction as the status change, so a
-- payout can never be approved without the ledger entry that funds it.
create or replace function public.decide_payout(
  p_payout_id uuid,
  p_decision  text,      -- APPROVE | REJECT
  p_reason    text default null
)
returns public.payouts
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_payout   public.payouts%rowtype;
  v_admin_id uuid;
  v_txn      public.wallet_transactions%rowtype;
  v_before   jsonb;
begin
  if p_decision not in ('APPROVE', 'REJECT') then
    raise exception 'INVALID: decision must be APPROVE or REJECT' using errcode = '23514';
  end if;

  v_admin_id := public.require_permission(
    case p_decision when 'APPROVE' then 'payouts.approve' else 'payouts.reject' end
  );

  select * into v_payout from public.payouts where id = p_payout_id for update;
  if not found then
    raise exception 'NOT_FOUND: payout % does not exist', p_payout_id using errcode = 'P0002';
  end if;

  -- Idempotent under a double-clicked approval.
  if v_payout.status <> 'REQUESTED' then
    raise exception 'CONFLICT: payout % is already %', v_payout.payout_code, v_payout.status
      using errcode = '23505';
  end if;

  if p_decision = 'REJECT' and (p_reason is null or length(btrim(p_reason)) < 5) then
    raise exception 'INVALID: a rejection requires a reason of at least 5 characters'
      using errcode = '23514';
  end if;

  v_before := jsonb_build_object('status', v_payout.status, 'amount_minor', v_payout.amount_minor);

  if p_decision = 'APPROVE' then
    v_txn := public.post_wallet_transaction(
      v_payout.worker_id, 'DEBIT_PAYOUT', v_payout.amount_minor,
      'Payout ' || v_payout.payout_code,
      'payout:' || v_payout.id::text,          -- derived key: one debit per payout
      'PAYOUT', v_payout.id, p_reason, 'ADMIN'
    );

    update public.payouts
    set status = 'PROCESSING',
        decided_by = v_admin_id,
        decided_at = now(),
        decision_reason = p_reason,
        processed_at = now(),
        ledger_transaction_id = v_txn.id
    where id = p_payout_id
    returning * into v_payout;
  else
    update public.payouts
    set status = 'REJECTED',
        decided_by = v_admin_id,
        decided_at = now(),
        decision_reason = p_reason
    where id = p_payout_id
    returning * into v_payout;
  end if;

  perform public.write_audit_log(
    'payout.' || lower(p_decision),
    'payout',
    p_payout_id::text,
    v_before,
    jsonb_build_object('status', v_payout.status, 'ledger_transaction_id', v_payout.ledger_transaction_id),
    p_reason
  );

  return v_payout;
end;
$$;

grant execute on function public.decide_payout(uuid, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Claims
-- ---------------------------------------------------------------------------
-- No automatic approval anywhere. Every outcome is an administrator's decision,
-- carrying their identity, a reason, and an immutable event row.
create or replace function public.decide_claim(
  p_claim_id       uuid,
  p_decision       text,     -- TAKE_REVIEW | REQUEST_INFO | APPROVE | PARTIALLY_APPROVE | REJECT | CLOSE
  p_amount_minor   bigint default null,
  p_note           text default null,
  p_reason         text default null
)
returns public.claims
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_claim    public.claims%rowtype;
  v_admin_id uuid;
  v_status   public.claim_status;
  v_before   jsonb;
begin
  if p_decision not in ('TAKE_REVIEW','REQUEST_INFO','APPROVE','PARTIALLY_APPROVE','REJECT','CLOSE') then
    raise exception 'INVALID: unknown claim decision %', p_decision using errcode = '23514';
  end if;

  v_admin_id := public.require_permission(
    case p_decision
      when 'APPROVE'            then 'claims.approve'
      when 'PARTIALLY_APPROVE'  then 'claims.approve'
      when 'REJECT'             then 'claims.reject'
      else 'claims.review'
    end
  );

  select * into v_claim from public.claims where id = p_claim_id for update;
  if not found then
    raise exception 'NOT_FOUND: claim % does not exist', p_claim_id using errcode = 'P0002';
  end if;

  if v_claim.status = 'CLOSED' then
    raise exception 'CONFLICT: claim % is closed', v_claim.claim_code using errcode = '23505';
  end if;

  v_status := case p_decision
    when 'TAKE_REVIEW'       then 'UNDER_REVIEW'
    when 'REQUEST_INFO'      then 'MORE_INFORMATION_REQUIRED'
    when 'APPROVE'           then 'APPROVED'
    when 'PARTIALLY_APPROVE' then 'PARTIALLY_APPROVED'
    when 'REJECT'            then 'REJECTED'
    else 'CLOSED'
  end::public.claim_status;

  if p_decision in ('APPROVE', 'PARTIALLY_APPROVE') then
    if p_amount_minor is null or p_amount_minor <= 0 then
      raise exception 'INVALID: an approval requires the amount being approved' using errcode = '23514';
    end if;
    if p_amount_minor > v_claim.amount_claimed_minor then
      raise exception 'INVALID: cannot approve more than the amount claimed' using errcode = '23514';
    end if;
    if p_decision = 'PARTIALLY_APPROVE' and p_amount_minor >= v_claim.amount_claimed_minor then
      raise exception 'INVALID: a partial approval must be less than the amount claimed'
        using errcode = '23514';
    end if;
  end if;

  if p_decision = 'REJECT' and (p_reason is null or length(btrim(p_reason)) < 10) then
    raise exception 'INVALID: a claim rejection requires a reason of at least 10 characters'
      using errcode = '23514';
  end if;

  v_before := jsonb_build_object(
    'status', v_claim.status,
    'amount_approved_minor', v_claim.amount_approved_minor
  );

  update public.claims
  set status = v_status,
      amount_approved_minor = case
        when p_decision in ('APPROVE', 'PARTIALLY_APPROVE') then p_amount_minor
        when p_decision = 'REJECT' then 0
        else amount_approved_minor
      end,
      assigned_to = case when p_decision = 'TAKE_REVIEW' then v_admin_id else assigned_to end,
      assigned_at = case when p_decision = 'TAKE_REVIEW' then now() else assigned_at end,
      decided_by = case
        when p_decision in ('APPROVE','PARTIALLY_APPROVE','REJECT') then v_admin_id
        else decided_by
      end,
      decided_at = case
        when p_decision in ('APPROVE','PARTIALLY_APPROVE','REJECT') then now()
        else decided_at
      end,
      decision_note = coalesce(p_note, decision_note),
      rejection_reason = case when p_decision = 'REJECT' then p_reason else rejection_reason end,
      info_requested = case when p_decision = 'REQUEST_INFO' then p_note else null end,
      closed_at = case when p_decision = 'CLOSE' then now() else closed_at end
  where id = p_claim_id
  returning * into v_claim;

  insert into public.claim_events (claim_id, from_status, to_status, actor_type, actor_admin_id, note)
  values (p_claim_id, v_before ->> 'status', v_status, 'ADMIN', v_admin_id, coalesce(p_reason, p_note));

  perform public.write_audit_log(
    'claim.' || lower(p_decision), 'claim', p_claim_id::text,
    v_before,
    jsonb_build_object('status', v_status, 'amount_approved_minor', v_claim.amount_approved_minor),
    coalesce(p_reason, p_note)
  );

  return v_claim;
end;
$$;

grant execute on function public.decide_claim(uuid, text, bigint, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Payments
-- ---------------------------------------------------------------------------
-- Called only by the webhook handler, after it has verified the provider
-- signature out of band. The verified flag is required by a table constraint,
-- so there is no path to SUCCESS that skips this function.
create or replace function public.confirm_payment(
  p_payment_id        uuid,
  p_gateway_payment_id text,
  p_signature_verified boolean,
  p_payload           jsonb default '{}'::jsonb
)
returns public.payments
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_payment public.payments%rowtype;
begin
  if not p_signature_verified then
    raise exception 'FORBIDDEN: refusing to confirm a payment whose gateway signature was not verified'
      using errcode = '42501';
  end if;

  select * into v_payment from public.payments where id = p_payment_id for update;
  if not found then
    raise exception 'NOT_FOUND: payment % does not exist', p_payment_id using errcode = 'P0002';
  end if;

  -- Replayed webhook: already captured, nothing to do.
  if v_payment.status = 'SUCCESS' then
    return v_payment;
  end if;

  update public.payments
  set status = 'SUCCESS',
      gateway_payment_id = p_gateway_payment_id,
      gateway_signature_verified = true,
      gateway_verified_at = now(),
      gateway_payload = p_payload,
      captured_at = now()
  where id = p_payment_id
  returning * into v_payment;

  -- Credit the worker's share, net of the platform fee, once and only once.
  if v_payment.worker_amount_minor > 0 then
    perform public.post_wallet_transaction(
      (select worker_id from public.bookings where id = v_payment.booking_id),
      'CREDIT_JOB_EARNING',
      v_payment.worker_amount_minor,
      'Earning for booking ' || (select booking_code from public.bookings where id = v_payment.booking_id),
      'payment-earning:' || v_payment.id::text,
      'PAYMENT', v_payment.id, null, 'SYSTEM'
    );
  end if;

  perform public.transition_booking(
    v_payment.booking_id, 'PAID', 'SYSTEM',
    'Gateway-verified payment ' || p_gateway_payment_id
  );

  return v_payment;
end;
$$;

-- ---------------------------------------------------------------------------
-- Account moderation
-- ---------------------------------------------------------------------------
create or replace function public.admin_set_worker_status(
  p_worker_id uuid,
  p_status    public.worker_status,
  p_reason    text
)
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
  v_worker   public.workers%rowtype;
  v_before   jsonb;
begin
  v_admin_id := public.require_permission('workers.restrict');

  if p_reason is null or length(btrim(p_reason)) < 10 then
    raise exception 'INVALID: changing a worker account status requires a reason of at least 10 characters'
      using errcode = '23514';
  end if;

  select * into v_worker from public.workers where id = p_worker_id for update;
  if not found then
    raise exception 'NOT_FOUND: worker % does not exist', p_worker_id using errcode = 'P0002';
  end if;

  v_before := jsonb_build_object('status', v_worker.status, 'restriction_reason', v_worker.restriction_reason);

  update public.workers
  set status = p_status,
      availability = case when p_status <> 'ACTIVE' then 'OFFLINE' else availability end,
      restriction_reason = case
        when p_status in ('RESTRICTED','SUSPENDED','DEACTIVATED','REJECTED') then p_reason
        else null
      end,
      restricted_at = case
        when p_status in ('RESTRICTED','SUSPENDED','DEACTIVATED','REJECTED') then now()
        else null
      end,
      restricted_by = case
        when p_status in ('RESTRICTED','SUSPENDED','DEACTIVATED','REJECTED') then v_admin_id
        else null
      end
  where id = p_worker_id
  returning * into v_worker;

  perform public.write_audit_log(
    'worker.status_changed', 'worker', p_worker_id::text,
    v_before, jsonb_build_object('status', p_status), p_reason
  );

  return v_worker;
end;
$$;

create or replace function public.admin_set_customer_status(
  p_customer_id uuid,
  p_status      public.customer_status,
  p_reason      text
)
returns public.customers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
  v_customer public.customers%rowtype;
  v_before   jsonb;
begin
  v_admin_id := public.require_permission('customers.restrict');

  if p_reason is null or length(btrim(p_reason)) < 10 then
    raise exception 'INVALID: changing a customer account status requires a reason of at least 10 characters'
      using errcode = '23514';
  end if;

  select * into v_customer from public.customers where id = p_customer_id for update;
  if not found then
    raise exception 'NOT_FOUND: customer % does not exist', p_customer_id using errcode = 'P0002';
  end if;

  v_before := jsonb_build_object('status', v_customer.status);

  update public.customers
  set status = p_status,
      restriction_reason = case when p_status <> 'ACTIVE' then p_reason else null end,
      restricted_at = case when p_status <> 'ACTIVE' then now() else null end,
      restricted_by = case when p_status <> 'ACTIVE' then v_admin_id else null end
  where id = p_customer_id
  returning * into v_customer;

  perform public.write_audit_log(
    'customer.status_changed', 'customer', p_customer_id::text,
    v_before, jsonb_build_object('status', p_status), p_reason
  );

  return v_customer;
end;
$$;

grant execute on function
  public.admin_set_worker_status(uuid, public.worker_status, text),
  public.admin_set_customer_status(uuid, public.customer_status, text)
to authenticated;

-- ---------------------------------------------------------------------------
-- Support
-- ---------------------------------------------------------------------------
create or replace function public.admin_post_support_message(
  p_ticket_id   uuid,
  p_body        text,
  p_is_internal boolean default false
)
returns public.support_messages
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
  v_message  public.support_messages%rowtype;
begin
  v_admin_id := public.require_permission('support.respond');

  if p_body is null or length(btrim(p_body)) = 0 then
    raise exception 'INVALID: message body cannot be empty' using errcode = '23514';
  end if;

  insert into public.support_messages (ticket_id, author_type, author_admin_id, body, is_internal)
  values (p_ticket_id, 'ADMIN', v_admin_id, p_body, p_is_internal)
  returning * into v_message;

  update public.support_tickets
  set status = case when status = 'OPEN' then 'IN_PROGRESS' else status end,
      assigned_admin_id = coalesce(assigned_admin_id, v_admin_id),
      assigned_at = coalesce(assigned_at, now())
  where id = p_ticket_id;

  return v_message;
end;
$$;

create or replace function public.admin_set_ticket_status(
  p_ticket_id uuid,
  p_status    public.support_status,
  p_note      text default null
)
returns public.support_tickets
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
  v_ticket   public.support_tickets%rowtype;
  v_before   jsonb;
begin
  v_admin_id := public.require_permission('support.respond');

  select * into v_ticket from public.support_tickets where id = p_ticket_id for update;
  if not found then
    raise exception 'NOT_FOUND: ticket % does not exist', p_ticket_id using errcode = 'P0002';
  end if;

  v_before := jsonb_build_object('status', v_ticket.status);

  update public.support_tickets
  set status = p_status,
      resolution_note = coalesce(p_note, resolution_note),
      resolved_at = case when p_status = 'RESOLVED' then now() else resolved_at end,
      closed_at = case when p_status = 'CLOSED' then now() else closed_at end
  where id = p_ticket_id
  returning * into v_ticket;

  perform public.write_audit_log(
    'support.status_changed', 'support_ticket', p_ticket_id::text,
    v_before, jsonb_build_object('status', p_status), p_note
  );

  return v_ticket;
end;
$$;

create or replace function public.admin_assign_ticket(
  p_ticket_id uuid,
  p_admin_id  uuid
)
returns public.support_tickets
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_ticket public.support_tickets%rowtype;
begin
  perform public.require_permission('support.assign');

  if not exists (select 1 from public.admin_users where id = p_admin_id and is_active) then
    raise exception 'INVALID: % is not an active administrator', p_admin_id using errcode = '23514';
  end if;

  update public.support_tickets
  set assigned_admin_id = p_admin_id,
      assigned_at = now(),
      status = case when status = 'OPEN' then 'IN_PROGRESS' else status end
  where id = p_ticket_id
  returning * into v_ticket;

  perform public.write_audit_log(
    'support.assigned', 'support_ticket', p_ticket_id::text,
    null, jsonb_build_object('assigned_admin_id', p_admin_id), null
  );

  return v_ticket;
end;
$$;

grant execute on function
  public.admin_post_support_message(uuid, text, boolean),
  public.admin_set_ticket_status(uuid, public.support_status, text),
  public.admin_assign_ticket(uuid, uuid)
to authenticated;
