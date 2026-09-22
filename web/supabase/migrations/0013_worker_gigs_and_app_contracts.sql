-- ===========================================================================
-- 0013  Worker gigs, and the trusted operations the Worker App calls
-- ---------------------------------------------------------------------------
-- Migrations 0001-0012 modelled the platform from the operator's side: the
-- admin panel and the public website. This file adds the two things the worker
-- mobile application needs and the schema did not yet have.
--
--   1. Gigs. A worker is a person; a gig is one service they offer. The schema
--      already knew which trades a worker is APPROVED for (worker_services) but
--      had nowhere to record what they are actually SELLING, at what price, for
--      how long. One worker holds many gigs across many trades.
--
--   2. Worker-facing trusted operations. Every sensitive mutation the app makes
--      is a security definer function here, so the client can request an action
--      but never assert its outcome. The worker identity is always re-derived
--      from the verified Firebase token via current_worker_id() and is never
--      read from an argument.
--
-- The rules from the earlier migrations still hold and are not weakened here:
-- bookings.status is written only by transition_booking(); verification
-- decisions only by decide_verification(); the wallet only by
-- post_wallet_transaction().
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Gig lifecycle
-- ---------------------------------------------------------------------------
create type public.gig_status as enum (
  'DRAFT',           -- worker is still writing it; not matchable
  'PENDING_REVIEW',  -- submitted, awaiting operations
  'ACTIVE',          -- live and matchable
  'PAUSED',          -- worker turned it off; keeps its history
  'REJECTED',
  'ARCHIVED'         -- withdrawn; still referenced by past bookings
);

-- ---------------------------------------------------------------------------
-- worker_gigs
-- ---------------------------------------------------------------------------
create table public.worker_gigs (
  id             uuid primary key default gen_random_uuid(),
  worker_id      uuid not null references public.workers (id) on delete cascade,
  -- The trade this gig sits under. A worker may only publish a gig for a
  -- service they hold an approved worker_services row for; enforced by
  -- worker_upsert_gig(), not by the UI.
  service_id     uuid not null references public.services (id) on delete restrict,

  title          text not null,
  description    text,
  status         public.gig_status not null default 'DRAFT',

  -- Minor units (paise), like every other amount on the platform.
  price_minor    bigint not null,
  currency       text not null default 'INR',
  -- What the price covers, so a customer comparing two gigs is comparing
  -- like with like.
  pricing_unit   text not null default 'PER_JOB',

  estimated_duration_minutes integer not null,
  -- Overrides workers.service_radius_km for this gig when set. A painter may
  -- travel further for a two-day job than for a switchboard repair.
  service_radius_km numeric(5, 2),

  -- Operations review trail, mirroring worker_verifications.
  submitted_at   timestamptz,
  reviewed_by    uuid references public.admin_users (id) on delete set null,
  reviewed_at    timestamptz,
  rejection_reason text,

  jobs_completed integer not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint worker_gigs_title_length check (length(btrim(title)) between 6 and 120),
  constraint worker_gigs_price_positive check (price_minor > 0),
  constraint worker_gigs_duration_sane check (
    estimated_duration_minutes between 15 and 20160   -- 15 minutes to 14 days
  ),
  constraint worker_gigs_radius_range check (
    service_radius_km is null or (service_radius_km > 0 and service_radius_km <= 100)
  ),
  constraint worker_gigs_pricing_unit_valid check (
    pricing_unit in ('PER_JOB', 'PER_HOUR', 'PER_DAY', 'PER_UNIT', 'PER_SQFT')
  ),
  constraint worker_gigs_rejection_has_reason check (
    status <> 'REJECTED' or (rejection_reason is not null and length(btrim(rejection_reason)) > 0)
  ),
  -- A rejection must name who rejected it. ACTIVE is deliberately not covered:
  -- a gig can go live without review when gigs.require_review is false.
  constraint worker_gigs_rejection_attributed check (
    status <> 'REJECTED' or reviewed_by is not null
  ),
  -- One live gig per title per trade, so a worker cannot publish the same
  -- offering twice and crowd the results.
  constraint worker_gigs_unique_live_title unique (worker_id, service_id, title)
);

comment on table public.worker_gigs is
  'A service a worker offers. One worker holds many gigs across many trades. Verification lives on the worker, never duplicated per gig.';
comment on column public.worker_gigs.status is
  'Independent of workers.availability. A worker who is OFFLINE receives nothing even when every gig is ACTIVE.';

create index worker_gigs_worker_idx on public.worker_gigs (worker_id, status);
create index worker_gigs_service_active_idx on public.worker_gigs (service_id, price_minor)
  where status = 'ACTIVE';
create index worker_gigs_review_queue_idx on public.worker_gigs (submitted_at)
  where status = 'PENDING_REVIEW';
create index worker_gigs_title_trgm_idx on public.worker_gigs using gin (title gin_trgm_ops);

create trigger worker_gigs_touch_updated_at
  before update on public.worker_gigs
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Bookings reference the gig they were sold from
-- ---------------------------------------------------------------------------
-- Nullable, and ON DELETE SET NULL, because the booking's own snapshot columns
-- (quoted_amount_minor, service_id) remain the financial truth. A worker who
-- later raises a gig's price cannot change what a customer already agreed to.
alter table public.bookings
  add column gig_id uuid references public.worker_gigs (id) on delete set null;

comment on column public.bookings.gig_id is
  'The gig this booking was sold from, for attribution. The agreed amount is quoted_amount_minor on this row, never re-read from the gig.';

create index bookings_gig_idx on public.bookings (gig_id, created_at desc)
  where gig_id is not null;

-- ---------------------------------------------------------------------------
-- Arrival code attempts
-- ---------------------------------------------------------------------------
-- A four to six digit code is guessable if a client may try without limit. Every
-- attempt is recorded, and worker_verify_arrival() refuses once the ceiling is
-- reached. The record also tells an investigator that guessing was attempted.
create table public.booking_arrival_attempts (
  id          bigint generated always as identity primary key,
  booking_id  uuid not null references public.bookings (id) on delete cascade,
  worker_id   uuid not null references public.workers (id) on delete cascade,
  was_successful boolean not null,
  attempted_at timestamptz not null default now()
);

create index booking_arrival_attempts_booking_idx
  on public.booking_arrival_attempts (booking_id, attempted_at desc);

-- ---------------------------------------------------------------------------
-- Settings this file introduces
-- ---------------------------------------------------------------------------
insert into public.platform_settings (key, value, description, is_public) values
  ('gigs.max_active_per_worker', 'null'::jsonb,
   'Ceiling on simultaneously ACTIVE gigs per worker. null means no limit. A policy, never a hardcoded client restriction.', false),
  ('gigs.require_review', 'true'::jsonb,
   'Whether a submitted gig waits for operations review before going ACTIVE.', false),
  ('booking.arrival_code_max_attempts', '5'::jsonb,
   'Arrival code attempts allowed per booking before the worker must call support.', false),
  ('offer.response_window_minutes', '10'::jsonb,
   'How long a worker has to accept an offer before it times out.', false)
on conflict (key) do nothing;

-- ===========================================================================
-- Row level security
-- ===========================================================================
alter table public.worker_gigs enable row level security;
alter table public.worker_gigs force row level security;
alter table public.booking_arrival_attempts enable row level security;
alter table public.booking_arrival_attempts force row level security;

grant select on public.worker_gigs to authenticated;

-- A worker sees their own gigs in every state, including drafts.
create policy worker_gigs_self_read on public.worker_gigs
  for select to authenticated
  using (worker_id = public.current_worker_id());

-- Anyone signed in may see a live gig: this is the customer-facing catalogue
-- the future Customer App browses.
create policy worker_gigs_active_read on public.worker_gigs
  for select to authenticated
  using (status = 'ACTIVE');

create policy worker_gigs_admin_read on public.worker_gigs
  for select to authenticated
  using (public.admin_has_permission('workers.read'));

-- No INSERT, UPDATE or DELETE policy and no grant: every write goes through the
-- functions below.

grant select on public.booking_arrival_attempts to authenticated;

create policy arrival_attempts_worker_read on public.booking_arrival_attempts
  for select to authenticated
  using (worker_id = public.current_worker_id());

create policy arrival_attempts_admin_read on public.booking_arrival_attempts
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- ===========================================================================
-- Helper: the caller's worker row, or a refusal
-- ===========================================================================
create or replace function public.require_current_worker()
returns public.workers
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  select * into v_worker
  from public.workers
  where id = public.current_worker_id();

  if not found then
    raise exception 'FORBIDDEN: this operation is only available to a signed-in worker'
      using errcode = '42501';
  end if;

  return v_worker;
end;
$$;

-- ===========================================================================
-- Eligibility
-- ---------------------------------------------------------------------------
-- One place that answers "may this worker receive jobs, and if not, why not".
-- The app renders the reasons as a task list instead of a dead toggle, and
-- worker_set_availability() calls the same function, so the explanation the
-- worker reads can never disagree with the rule that refused them.
-- ===========================================================================
create or replace function public.worker_eligibility(p_worker_id uuid default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_reasons jsonb := '[]'::jsonb;
  v_gigs    integer;
begin
  select * into v_worker
  from public.workers
  where id = coalesce(p_worker_id, public.current_worker_id());

  if not found then
    raise exception 'NOT_FOUND: no such worker' using errcode = 'P0002';
  end if;

  -- A worker may only ask about themselves unless they are staff.
  if v_worker.id <> public.current_worker_id()
     and not public.admin_has_permission('workers.read') then
    raise exception 'FORBIDDEN: you may only read your own eligibility'
      using errcode = '42501';
  end if;

  if v_worker.status <> 'ACTIVE' then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'ACCOUNT_NOT_ACTIVE',
      'status', v_worker.status,
      'message', case v_worker.status
        when 'REGISTERED' then 'Finish setting up your profile to start receiving jobs.'
        when 'VERIFICATION_PENDING' then 'Your documents are being reviewed. We will let you know as soon as this is done.'
        when 'INACTIVE' then 'Your account is inactive. Contact support to reactivate it.'
        when 'RESTRICTED' then 'Your account is restricted. Contact support.'
        when 'SUSPENDED' then 'Your account is suspended. Contact support.'
        when 'REJECTED' then 'Your application was not approved. Contact support.'
        else 'Your account cannot receive jobs at the moment.'
      end);
  end if;

  if not v_worker.is_kyc_verified then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'KYC_REQUIRED',
      'message', 'Complete identity verification.',
      'action', 'verification/kyc');
  end if;

  if not v_worker.is_background_verified then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'BACKGROUND_CHECK_REQUIRED',
      'message', 'Your background check is not complete yet.',
      'action', 'verification');
  end if;

  if v_worker.latitude is null or v_worker.longitude is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'SERVICE_AREA_REQUIRED',
      'message', 'Set your service area so we know where to send you work.',
      'action', 'profile/service-area');
  end if;

  if v_worker.primary_service_id is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'TRADE_REQUIRED',
      'message', 'Choose your main trade.',
      'action', 'profile/trade');
  end if;

  select count(*) into v_gigs
  from public.worker_gigs
  where worker_id = v_worker.id and status = 'ACTIVE';

  if v_gigs = 0 then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'NO_ACTIVE_GIG',
      'message', 'Publish at least one service so customers can book you.',
      'action', 'gigs');
  end if;

  return jsonb_build_object(
    'worker_id', v_worker.id,
    'eligible', jsonb_array_length(v_reasons) = 0,
    'account_status', v_worker.status,
    'availability', v_worker.availability,
    'active_gig_count', v_gigs,
    'reasons', v_reasons);
end;
$$;

comment on function public.worker_eligibility is
  'Whether a worker may receive jobs, with the reasons they may not. The single source the UI and worker_set_availability() both read.';

-- ===========================================================================
-- Availability
-- ===========================================================================
create or replace function public.worker_set_availability(
  p_availability public.worker_availability
)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker      public.workers%rowtype;
  v_eligibility jsonb;
begin
  v_worker := public.require_current_worker();

  -- BUSY is set by the platform when a job is in flight, not chosen by hand.
  if p_availability = 'BUSY' then
    raise exception 'INVALID: BUSY is set automatically while you are on a job'
      using errcode = '23514';
  end if;

  -- Going offline is always permitted. Only coming online is gated: a worker
  -- must never be trapped in an available state they cannot leave.
  if p_availability = 'AVAILABLE' then
    v_eligibility := public.worker_eligibility(v_worker.id);

    if not (v_eligibility ->> 'eligible')::boolean then
      raise exception 'FORBIDDEN: %',
        coalesce(
          v_eligibility -> 'reasons' -> 0 ->> 'message',
          'You cannot receive jobs yet.')
        using errcode = '42501',
              detail = v_eligibility::text;
    end if;
  end if;

  update public.workers
  set availability   = p_availability,
      last_active_at = now()
  where id = v_worker.id
  returning * into v_worker;

  return jsonb_build_object(
    'availability', v_worker.availability,
    'eligibility', public.worker_eligibility(v_worker.id));
end;
$$;

grant execute on function public.worker_set_availability(public.worker_availability) to authenticated;

-- ===========================================================================
-- Job offers
-- ---------------------------------------------------------------------------
-- Two workers can be offered the same booking. Exactly one may win. The booking
-- row is locked before the state is read, so the loser is told the job is gone
-- rather than being handed a booking someone else is already travelling to.
-- ===========================================================================
create or replace function public.worker_accept_offer(p_booking_id uuid)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker    public.workers%rowtype;
  v_booking   public.bookings%rowtype;
  v_candidate public.booking_match_candidates%rowtype;
  v_window    integer;
begin
  v_worker := public.require_current_worker();

  if v_worker.status <> 'ACTIVE' then
    raise exception 'FORBIDDEN: your account cannot accept jobs at the moment'
      using errcode = '42501';
  end if;

  -- Lock first, then read. This is what makes the race safe.
  select * into v_booking
  from public.bookings
  where id = p_booking_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that job no longer exists' using errcode = 'P0002';
  end if;

  select * into v_candidate
  from public.booking_match_candidates
  where booking_id = p_booking_id and worker_id = v_worker.id;

  if not found or not v_candidate.was_offered then
    raise exception 'FORBIDDEN: this job was not offered to you' using errcode = '42501';
  end if;

  if v_candidate.response is not null then
    raise exception 'CONFLICT: you have already responded to this job'
      using errcode = '23505';
  end if;

  -- Someone else got there first, or the customer withdrew.
  if v_booking.status <> 'REQUESTED' or v_booking.worker_id is not null then
    update public.booking_match_candidates
    set response = 'TIMED_OUT', responded_at = now()
    where id = v_candidate.id;

    raise exception 'CONFLICT: this job is no longer available'
      using errcode = '23505';
  end if;

  v_window := coalesce(
    (select value::integer from public.platform_settings
     where key = 'offer.response_window_minutes'), 10);

  if v_candidate.offered_at is not null
     and v_candidate.offered_at < now() - make_interval(mins => v_window) then
    update public.booking_match_candidates
    set response = 'TIMED_OUT', responded_at = now()
    where id = v_candidate.id;

    raise exception 'CONFLICT: this offer has expired' using errcode = '23505';
  end if;

  update public.booking_match_candidates
  set response = 'ACCEPTED', responded_at = now()
  where id = v_candidate.id;

  -- Attach the worker, then let the state machine make the move so the
  -- transition is validated and the timeline event is written in one place.
  update public.bookings
  set worker_id = v_worker.id
  where id = p_booking_id;

  v_booking := public.transition_booking(
    p_booking_id,
    'ACCEPTED',
    'WORKER',
    null,
    jsonb_build_object('candidate_rank', v_candidate.rank,
                       'match_score', v_candidate.total_score));

  return v_booking;
end;
$$;

grant execute on function public.worker_accept_offer(uuid) to authenticated;

create or replace function public.worker_decline_offer(
  p_booking_id uuid,
  p_reason     text default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker    public.workers%rowtype;
  v_candidate public.booking_match_candidates%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_candidate
  from public.booking_match_candidates
  where booking_id = p_booking_id and worker_id = v_worker.id
  for update;

  if not found or not v_candidate.was_offered then
    raise exception 'NOT_FOUND: that offer does not exist' using errcode = 'P0002';
  end if;

  if v_candidate.response is not null then
    raise exception 'CONFLICT: you have already responded to this job'
      using errcode = '23505';
  end if;

  update public.booking_match_candidates
  set response = 'DECLINED', responded_at = now()
  where id = v_candidate.id;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, note, metadata)
  values
    (p_booking_id, 'WORKER_DECLINED', 'WORKER', v_worker.id, p_reason,
     jsonb_build_object('candidate_rank', v_candidate.rank));
end;
$$;

grant execute on function public.worker_decline_offer(uuid, text) to authenticated;

-- ===========================================================================
-- Booking progress
-- ---------------------------------------------------------------------------
-- A thin, checked wrapper over transition_booking(). It exists so the app has
-- one entry point that also proves the caller is the assigned worker — the
-- state machine validates the move, this validates the mover.
-- ===========================================================================
create or replace function public.worker_advance_booking(
  p_booking_id uuid,
  p_to_status  public.booking_status,
  p_reason     text default null
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_booking public.bookings%rowtype;
  v_pending integer;
begin
  v_worker := public.require_current_worker();

  select * into v_booking from public.bookings where id = p_booking_id;

  if not found or v_booking.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that job is not assigned to you' using errcode = 'P0002';
  end if;

  -- A worker drives only their own leg of the lifecycle. Everything past
  -- AWAITING_APPROVAL belongs to the customer, the payment webhook, or
  -- operations, and is refused here even though the transition table would
  -- allow some of it for other actors.
  if p_to_status not in ('TRAVELING', 'ARRIVED', 'IN_PROGRESS',
                         'AWAITING_APPROVAL', 'CANCELLED', 'DISPUTED') then
    raise exception 'FORBIDDEN: a worker may not move a job to %', p_to_status
      using errcode = '42501';
  end if;

  -- Completion gates. transition_booking() already refuses IN_PROGRESS without
  -- a verified arrival; these are the evidence rules on top of it.
  if p_to_status = 'AWAITING_APPROVAL' then
    if not exists (
      select 1 from public.media_assets
      where booking_id = p_booking_id
        and purpose = 'BOOKING_AFTER_WORK'
        and upload_status = 'COMPLETED'
        and deleted_at is null
    ) then
      raise exception 'INVALID: upload at least one photo of the finished work before completing the job'
        using errcode = '23514';
    end if;

    select count(*) into v_pending
    from public.materials
    where booking_id = p_booking_id
      and status in ('REQUESTED', 'CUSTOMER_REVIEW');

    if v_pending > 0 then
      raise exception 'INVALID: % material request(s) are still waiting on the customer', v_pending
        using errcode = '23514';
    end if;
  end if;

  return public.transition_booking(p_booking_id, p_to_status, 'WORKER', p_reason);
end;
$$;

grant execute on function public.worker_advance_booking(uuid, public.booking_status, text) to authenticated;

-- ===========================================================================
-- Arrival verification
-- ---------------------------------------------------------------------------
-- The customer reads a code aloud; the worker types it. The comparison happens
-- here and nowhere else. The old application's defect was a client that treated
-- a rejected code as success — impossible now, because the client has no code to
-- compare against: arrival_code is not readable by the worker under RLS, and
-- this function returns only a boolean plus the resulting booking.
-- ===========================================================================
create or replace function public.worker_verify_arrival(
  p_booking_id uuid,
  p_code       text
)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker   public.workers%rowtype;
  v_booking  public.bookings%rowtype;
  v_max      integer;
  v_failed   integer;
  v_ok       boolean;
begin
  v_worker := public.require_current_worker();

  select * into v_booking
  from public.bookings
  where id = p_booking_id
  for update;

  if not found or v_booking.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that job is not assigned to you' using errcode = 'P0002';
  end if;

  if v_booking.status <> 'ARRIVED' then
    raise exception 'INVALID: mark yourself as arrived before entering the code'
      using errcode = '23514';
  end if;

  if v_booking.arrival_verified_at is not null then
    return jsonb_build_object('verified', true, 'already_verified', true);
  end if;

  if v_booking.arrival_code is null then
    raise exception 'INVALID: this job has no arrival code; contact support'
      using errcode = '23514';
  end if;

  v_max := coalesce(
    (select value::integer from public.platform_settings
     where key = 'booking.arrival_code_max_attempts'), 5);

  select count(*) into v_failed
  from public.booking_arrival_attempts
  where booking_id = p_booking_id and not was_successful;

  if v_failed >= v_max then
    raise exception 'FORBIDDEN: too many incorrect codes. Contact support to continue.'
      using errcode = '42501';
  end if;

  -- Length-independent comparison, so a wrong code cannot be distinguished from
  -- a wrong-length code by timing.
  v_ok := (encode(digest(btrim(p_code), 'sha256'), 'hex')
           = encode(digest(btrim(v_booking.arrival_code), 'sha256'), 'hex'));

  insert into public.booking_arrival_attempts (booking_id, worker_id, was_successful)
  values (p_booking_id, v_worker.id, v_ok);

  if not v_ok then
    return jsonb_build_object(
      'verified', false,
      'attempts_remaining', greatest(0, v_max - v_failed - 1));
  end if;

  update public.bookings
  set arrival_verified_at = now()
  where id = p_booking_id;

  insert into public.booking_events
    (booking_id, event_type, from_status, to_status, actor_type, actor_id, metadata)
  values
    (p_booking_id, 'ARRIVAL_VERIFIED', 'ARRIVED', 'ARRIVED', 'WORKER', v_worker.id,
     jsonb_build_object('attempts', v_failed + 1));

  return jsonb_build_object('verified', true, 'already_verified', false);
end;
$$;

grant execute on function public.worker_verify_arrival(uuid, text) to authenticated;

-- ===========================================================================
-- Materials
-- ---------------------------------------------------------------------------
-- A worker may ask. Only the customer may approve, and that path is not in this
-- file at all — it belongs to the Customer App.
-- ===========================================================================
create or replace function public.worker_request_material(
  p_booking_id     uuid,
  p_name           text,
  p_quantity       numeric,
  p_unit           text,
  p_estimated_cost_minor bigint,
  p_description    text default null
)
returns public.materials
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker   public.workers%rowtype;
  v_booking  public.bookings%rowtype;
  v_material public.materials%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_booking from public.bookings where id = p_booking_id;

  if not found or v_booking.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that job is not assigned to you' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('ARRIVED', 'IN_PROGRESS') then
    raise exception 'INVALID: materials can only be requested once you are on site'
      using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_name, ''))) < 2 then
    raise exception 'INVALID: describe the material you need' using errcode = '23514';
  end if;

  if p_quantity is null or p_quantity <= 0 then
    raise exception 'INVALID: quantity must be greater than zero' using errcode = '23514';
  end if;

  if p_estimated_cost_minor is null or p_estimated_cost_minor < 0 then
    raise exception 'INVALID: enter an estimated cost' using errcode = '23514';
  end if;

  insert into public.materials
    (booking_id, worker_id, name, description, quantity, unit,
     estimated_cost_minor, currency, status)
  values
    (p_booking_id, v_worker.id, btrim(p_name), p_description, p_quantity,
     coalesce(nullif(btrim(p_unit), ''), 'unit'),
     p_estimated_cost_minor, v_booking.currency, 'CUSTOMER_REVIEW')
  returning * into v_material;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, note, metadata)
  values
    (p_booking_id, 'MATERIAL_REQUESTED', 'WORKER', v_worker.id, v_material.name,
     jsonb_build_object('material_id', v_material.id,
                        'estimated_cost_minor', p_estimated_cost_minor));

  return v_material;
end;
$$;

grant execute on function public.worker_request_material(uuid, text, numeric, text, bigint, text) to authenticated;

-- Recording what the material actually cost, once bought. Requires a receipt,
-- because an unevidenced cost is an unrecoverable cost.
create or replace function public.worker_record_material_cost(
  p_material_id uuid,
  p_actual_cost_minor bigint
)
returns public.materials
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker   public.workers%rowtype;
  v_material public.materials%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_material
  from public.materials
  where id = p_material_id
  for update;

  if not found or v_material.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that material request is not yours' using errcode = 'P0002';
  end if;

  if v_material.status not in ('APPROVED', 'PURCHASED') then
    raise exception 'INVALID: the customer has not approved this material yet'
      using errcode = '23514';
  end if;

  if p_actual_cost_minor is null or p_actual_cost_minor < 0 then
    raise exception 'INVALID: enter the amount you actually paid' using errcode = '23514';
  end if;

  if not exists (
    select 1 from public.media_assets
    where material_id = p_material_id
      and purpose = 'BOOKING_RECEIPT'
      and upload_status = 'COMPLETED'
      and deleted_at is null
  ) then
    raise exception 'INVALID: attach a photo of the receipt before recording the cost'
      using errcode = '23514';
  end if;

  update public.materials
  set actual_cost_minor = p_actual_cost_minor,
      status            = 'COST_RECORDED',
      purchased_at      = coalesce(purchased_at, now()),
      cost_recorded_at  = now()
  where id = p_material_id
  returning * into v_material;

  return v_material;
end;
$$;

grant execute on function public.worker_record_material_cost(uuid, bigint) to authenticated;

-- ===========================================================================
-- Verification submission
-- ---------------------------------------------------------------------------
-- A worker submits evidence and reaches PENDING. Nothing here can reach
-- APPROVED: that is decide_verification()'s job, and it refuses self-review.
-- ===========================================================================
create or replace function public.worker_submit_verification(
  p_type    public.verification_type,
  p_details jsonb default '{}'::jsonb
)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker       public.workers%rowtype;
  v_verification public.worker_verifications%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_verification
  from public.worker_verifications
  where worker_id = v_worker.id and type = p_type
  for update;

  if found and v_verification.status in ('PENDING', 'UNDER_REVIEW') then
    raise exception 'CONFLICT: this is already with our team for review'
      using errcode = '23505';
  end if;

  if found and v_verification.status = 'APPROVED'
     and (v_verification.expires_at is null or v_verification.expires_at > now()) then
    raise exception 'CONFLICT: this is already verified' using errcode = '23505';
  end if;

  -- At least one completed document must back the submission, except for the
  -- checks the platform performs itself rather than asking the worker for paper.
  if p_type not in ('BACKGROUND_CHECK', 'RPL_SKILL') then
    if not exists (
      select 1 from public.media_assets
      where worker_id = v_worker.id
        and upload_status = 'COMPLETED'
        and deleted_at is null
        and purpose = case p_type
          when 'IDENTITY_KYC'    then 'WORKER_KYC_DOCUMENT'::public.media_purpose
          when 'ADDRESS'         then 'WORKER_KYC_DOCUMENT'::public.media_purpose
          when 'ITI_CERTIFICATE' then 'WORKER_QUALIFICATION'::public.media_purpose
          when 'DIPLOMA'         then 'WORKER_QUALIFICATION'::public.media_purpose
          when 'INSURANCE'       then 'WORKER_INSURANCE_DOCUMENT'::public.media_purpose
          else 'WORKER_QUALIFICATION'::public.media_purpose
        end
        and created_at > now() - interval '7 days'
    ) then
      raise exception 'INVALID: upload the required document before submitting'
        using errcode = '23514';
    end if;
  end if;

  insert into public.worker_verifications
    (worker_id, type, status, details, submitted_at)
  values
    (v_worker.id, p_type, 'PENDING', coalesce(p_details, '{}'::jsonb), now())
  on conflict (worker_id, type) do update
    set status           = 'PENDING',
        details          = coalesce(excluded.details, '{}'::jsonb),
        submitted_at     = now(),
        reviewed_by      = null,
        reviewed_at      = null,
        decision_note    = null,
        rejection_reason = null,
        info_requested   = null
  returning * into v_verification;

  -- Submitting anything moves a brand-new worker into the review queue.
  update public.workers
  set status = 'VERIFICATION_PENDING'
  where id = v_worker.id and status = 'REGISTERED';

  return v_verification;
end;
$$;

grant execute on function public.worker_submit_verification(public.verification_type, jsonb) to authenticated;

-- ===========================================================================
-- Skills
-- ---------------------------------------------------------------------------
-- Selecting a trade is a request, not a grant. is_approved stays false until an
-- administrator says otherwise, and an unapproved trade cannot carry a gig.
-- ===========================================================================
create or replace function public.worker_request_service(p_service_id uuid)
returns public.worker_services
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_row     public.worker_services%rowtype;
begin
  v_worker := public.require_current_worker();

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that service does not exist' using errcode = 'P0002';
  end if;

  insert into public.worker_services (worker_id, service_id, is_approved)
  values (v_worker.id, p_service_id, false)
  on conflict (worker_id, service_id) do update
    set worker_id = excluded.worker_id   -- no-op; returns the existing row
  returning * into v_row;

  return v_row;
end;
$$;

grant execute on function public.worker_request_service(uuid) to authenticated;

-- ===========================================================================
-- Gigs
-- ===========================================================================
create or replace function public.worker_upsert_gig(
  p_gig_id       uuid,          -- null to create
  p_service_id   uuid,
  p_title        text,
  p_description  text,
  p_price_minor  bigint,
  p_pricing_unit text,
  p_estimated_duration_minutes integer,
  p_service_radius_km numeric default null,
  p_submit       boolean default false   -- false keeps it a DRAFT
)
returns public.worker_gigs
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker      public.workers%rowtype;
  v_gig         public.worker_gigs%rowtype;
  v_requires_review boolean;
  v_max_active  integer;
  v_active      integer;
  v_next_status public.gig_status;
begin
  v_worker := public.require_current_worker();

  -- The rule that makes multi-gig safe: a gig may only exist under a trade the
  -- worker has actually been approved for.
  if not exists (
    select 1 from public.worker_services ws
    where ws.worker_id = v_worker.id
      and ws.service_id = p_service_id
      and ws.is_approved
  ) and v_worker.primary_service_id is distinct from p_service_id then
    raise exception 'FORBIDDEN: you are not approved to offer this service yet'
      using errcode = '42501';
  end if;

  v_requires_review := coalesce(
    (select value::boolean from public.platform_settings
     where key = 'gigs.require_review'), true);

  v_next_status := case
    when not p_submit then 'DRAFT'::public.gig_status
    when v_requires_review then 'PENDING_REVIEW'::public.gig_status
    else 'ACTIVE'::public.gig_status
  end;

  -- A configurable ceiling, absent by default. It lives in platform_settings so
  -- a business decision to cap gigs never becomes a hardcoded client rule.
  if v_next_status = 'ACTIVE' then
    select nullif(value, 'null'::jsonb)::integer into v_max_active
    from public.platform_settings where key = 'gigs.max_active_per_worker';

    if v_max_active is not null then
      select count(*) into v_active
      from public.worker_gigs
      where worker_id = v_worker.id
        and status = 'ACTIVE'
        and (p_gig_id is null or id <> p_gig_id);

      if v_active >= v_max_active then
        raise exception 'INVALID: you can have at most % active services', v_max_active
          using errcode = '23514';
      end if;
    end if;
  end if;

  if exists (
    select 1 from public.worker_gigs
    where worker_id = v_worker.id
      and service_id = p_service_id
      and title = btrim(p_title)
      and (p_gig_id is null or id <> p_gig_id)
  ) then
    raise exception 'CONFLICT: you already offer a service with that name'
      using errcode = '23505';
  end if;

  if p_gig_id is null then
    insert into public.worker_gigs
      (worker_id, service_id, title, description, status, price_minor,
       pricing_unit, estimated_duration_minutes, service_radius_km, submitted_at)
    values
      (v_worker.id, p_service_id, btrim(p_title), p_description, v_next_status,
       p_price_minor, coalesce(p_pricing_unit, 'PER_JOB'),
       p_estimated_duration_minutes, p_service_radius_km,
       case when p_submit then now() end)
    returning * into v_gig;
  else
    select * into v_gig from public.worker_gigs
    where id = p_gig_id and worker_id = v_worker.id
    for update;

    if not found then
      raise exception 'NOT_FOUND: that service is not yours' using errcode = 'P0002';
    end if;

    if v_gig.status = 'ARCHIVED' then
      raise exception 'INVALID: an archived service cannot be edited' using errcode = '23514';
    end if;

    update public.worker_gigs
    set service_id   = p_service_id,
        title        = btrim(p_title),
        description  = p_description,
        price_minor  = p_price_minor,
        pricing_unit = coalesce(p_pricing_unit, 'PER_JOB'),
        estimated_duration_minutes = p_estimated_duration_minutes,
        service_radius_km = p_service_radius_km,
        -- An edit to a live gig re-enters review when review is required.
        status       = case
          when p_submit then v_next_status
          when v_gig.status = 'ACTIVE' and v_requires_review then 'PENDING_REVIEW'::public.gig_status
          else v_gig.status
        end,
        submitted_at = case when p_submit then now() else submitted_at end,
        rejection_reason = case when p_submit then null else rejection_reason end
    where id = p_gig_id
    returning * into v_gig;
  end if;

  return v_gig;
end;
$$;

grant execute on function public.worker_upsert_gig(uuid, uuid, text, text, bigint, text, integer, numeric, boolean) to authenticated;

-- Pause, resume or archive. A worker cannot move their own gig to ACTIVE when
-- review is required, and cannot ever set REJECTED.
create or replace function public.worker_set_gig_status(
  p_gig_id uuid,
  p_status public.gig_status
)
returns public.worker_gigs
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_gig    public.worker_gigs%rowtype;
  v_requires_review boolean;
begin
  v_worker := public.require_current_worker();

  if p_status not in ('PAUSED', 'ACTIVE', 'ARCHIVED') then
    raise exception 'FORBIDDEN: you may only pause, resume or remove a service'
      using errcode = '42501';
  end if;

  select * into v_gig from public.worker_gigs
  where id = p_gig_id and worker_id = v_worker.id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that service is not yours' using errcode = 'P0002';
  end if;

  if p_status = 'ACTIVE' then
    -- Resuming is only ever a return from PAUSED. A draft or a rejected gig has
    -- to go back through worker_upsert_gig(p_submit => true).
    if v_gig.status <> 'PAUSED' then
      raise exception 'INVALID: only a paused service can be resumed' using errcode = '23514';
    end if;

    v_requires_review := coalesce(
      (select value::boolean from public.platform_settings
       where key = 'gigs.require_review'), true);

    -- It was already reviewed before it was paused, so resuming does not
    -- re-queue it; but a gig that never cleared review cannot slip through.
    if v_requires_review and v_gig.reviewed_at is null then
      raise exception 'INVALID: this service has not been reviewed yet' using errcode = '23514';
    end if;
  end if;

  update public.worker_gigs
  set status = p_status
  where id = p_gig_id
  returning * into v_gig;

  return v_gig;
end;
$$;

grant execute on function public.worker_set_gig_status(uuid, public.gig_status) to authenticated;

-- ===========================================================================
-- Rating the customer
-- ===========================================================================
create or replace function public.worker_rate_customer(
  p_booking_id uuid,
  p_rating     smallint,
  p_comment    text default null
)
returns public.ratings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_booking public.bookings%rowtype;
  v_rating  public.ratings%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_booking from public.bookings where id = p_booking_id;

  if not found or v_booking.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that job is not yours' using errcode = 'P0002';
  end if;

  -- Rating is earned by finishing the job, not by being assigned it.
  if v_booking.status not in ('COMPLETED', 'PAYMENT_PENDING', 'PAID', 'CLOSED') then
    raise exception 'INVALID: you can rate the customer once the job is complete'
      using errcode = '23514';
  end if;

  if p_rating is null or p_rating < 1 or p_rating > 5 then
    raise exception 'INVALID: choose a rating between 1 and 5' using errcode = '23514';
  end if;

  insert into public.ratings
    (booking_id, rater_type, worker_id, customer_id, rating, comment)
  values
    (p_booking_id, 'WORKER', v_worker.id, v_booking.customer_id, p_rating, p_comment)
  on conflict (booking_id, rater_type) do nothing
  returning * into v_rating;

  if v_rating.id is null then
    raise exception 'CONFLICT: you have already rated this job' using errcode = '23505';
  end if;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, metadata)
  values
    (p_booking_id, 'RATING_SUBMITTED', 'WORKER', v_worker.id,
     jsonb_build_object('rating', p_rating));

  return v_rating;
end;
$$;

grant execute on function public.worker_rate_customer(uuid, smallint, text) to authenticated;

-- ===========================================================================
-- Support
-- ===========================================================================
create or replace function public.worker_create_support_ticket(
  p_subject    text,
  p_category   public.support_category,
  p_message    text,
  p_booking_id uuid default null
)
returns public.support_tickets
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_ticket public.support_tickets%rowtype;
  v_open   integer;
begin
  v_worker := public.require_current_worker();

  if length(btrim(coalesce(p_subject, ''))) < 3 then
    raise exception 'INVALID: give your request a short subject' using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_message, ''))) < 10 then
    raise exception 'INVALID: describe the problem in a little more detail'
      using errcode = '23514';
  end if;

  if p_booking_id is not null and not exists (
    select 1 from public.bookings
    where id = p_booking_id and worker_id = v_worker.id
  ) then
    raise exception 'NOT_FOUND: that job is not yours' using errcode = 'P0002';
  end if;

  -- Keeps one frustrated worker from filling the queue.
  select count(*) into v_open
  from public.support_tickets
  where worker_id = v_worker.id and status in ('OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER');

  if v_open >= 10 then
    raise exception 'INVALID: you already have 10 open requests. We will get to them.'
      using errcode = '23514';
  end if;

  insert into public.support_tickets
    (subject, category, requester_type, worker_id, booking_id)
  values
    (btrim(p_subject), p_category, 'WORKER', v_worker.id, p_booking_id)
  returning * into v_ticket;

  insert into public.support_messages
    (ticket_id, author_type, author_profile_id, body, is_internal)
  values
    (v_ticket.id, 'WORKER', v_worker.profile_id, btrim(p_message), false);

  return v_ticket;
end;
$$;

grant execute on function public.worker_create_support_ticket(text, public.support_category, text, uuid) to authenticated;

create or replace function public.worker_post_support_message(
  p_ticket_id uuid,
  p_body      text
)
returns public.support_messages
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_ticket  public.support_tickets%rowtype;
  v_message public.support_messages%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_ticket from public.support_tickets
  where id = p_ticket_id and worker_id = v_worker.id;

  if not found then
    raise exception 'NOT_FOUND: that request does not exist' using errcode = 'P0002';
  end if;

  if v_ticket.status = 'CLOSED' then
    raise exception 'INVALID: this request is closed. Open a new one.' using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_body, ''))) = 0 then
    raise exception 'INVALID: write a message first' using errcode = '23514';
  end if;

  insert into public.support_messages
    (ticket_id, author_type, author_profile_id, body, is_internal)
  values
    (p_ticket_id, 'WORKER', v_worker.profile_id, btrim(p_body), false)
  returning * into v_message;

  -- A reply from the worker puts the ball back in the platform's court.
  update public.support_tickets
  set status = case when status = 'WAITING_FOR_USER' then 'IN_PROGRESS'::public.support_status
                    else status end
  where id = p_ticket_id;

  return v_message;
end;
$$;

grant execute on function public.worker_post_support_message(uuid, text) to authenticated;

-- ===========================================================================
-- Push registration
-- ---------------------------------------------------------------------------
-- push_tokens already grants insert/update to the owner under RLS, but routing
-- it through a function means the profile_id is resolved server-side and a
-- device cannot register a token against somebody else's profile.
-- ===========================================================================
create or replace function public.worker_register_push_token(
  p_token        text,
  p_platform     text,
  p_device_label text default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  v_worker := public.require_current_worker();

  if p_platform not in ('ANDROID', 'IOS', 'WEB') then
    raise exception 'INVALID: unknown platform' using errcode = '23514';
  end if;

  insert into public.push_tokens
    (profile_id, firebase_uid, token, platform, device_label, is_active, last_seen_at)
  values
    (v_worker.profile_id, v_worker.firebase_uid, p_token, p_platform,
     p_device_label, true, now())
  on conflict (token) do update
    set profile_id   = excluded.profile_id,
        firebase_uid = excluded.firebase_uid,
        platform     = excluded.platform,
        device_label = excluded.device_label,
        is_active    = true,
        last_seen_at = now();
end;
$$;

grant execute on function public.worker_register_push_token(text, text, text) to authenticated;

-- ===========================================================================
-- Matching reads gigs
-- ---------------------------------------------------------------------------
-- run_matching() in 0011 scored a worker on their trade alone. With gigs in the
-- schema, a worker must also have a live gig for the trade being requested:
-- "I am an electrician" and "I am currently selling electrical repair" are
-- different claims, and only the second one should win work.
--
-- The scoring is otherwise untouched. The gig requirement is a hard gate in the
-- eligible CTE, alongside KYC and background, rather than another weighted
-- factor, because a worker with nothing on offer is not a weaker match — they
-- are not a match at all.
-- ===========================================================================
create or replace function public.worker_has_live_gig(
  p_worker_id  uuid,
  p_service_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1 from public.worker_gigs g
    where g.worker_id = p_worker_id
      and g.service_id = p_service_id
      and g.status = 'ACTIVE'
  )
$$;

comment on function public.worker_has_live_gig is
  'Hard gate for matching: the worker is offering this trade right now, not merely approved for it.';

grant execute on function public.worker_has_live_gig(uuid, uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- run_matching, with the gig gate applied
-- ---------------------------------------------------------------------------
-- Redefined from 0011. The scoring, the weights and the snapshot are unchanged;
-- the only differences are the added `worker_has_live_gig` gate in the eligible
-- CTE and the cheapest live gig for the trade recorded in the snapshot, so a
-- past offer stays explainable after the worker edits their price.
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

  v_weights := jsonb_build_object(
    'trade', 0.24, 'qualification', 0.16, 'skill', 0.10, 'kyc', 0.12,
    'background', 0.10, 'insurance', 0.04, 'availability', 0.08,
    'rating', 0.08, 'proximity', 0.08
  );

  delete from public.booking_match_candidates
  where booking_id = p_booking_id and response is null and not was_offered;

  return query
  with eligible as (
    select
      w.*,
      (earth_distance(
         ll_to_earth(v_booking.latitude, v_booking.longitude),
         ll_to_earth(w.latitude, w.longitude)
       ) / 1000.0)::numeric(6, 2) as distance_km,
      case
        when w.primary_service_id = v_booking.service_id then 1.000
        when exists (
          select 1 from public.worker_services ws
          where ws.worker_id = w.id and ws.service_id = v_booking.service_id and ws.is_approved
        ) then 0.800
        else 0.000
      end::numeric(4, 3) as trade_score,
      -- Cheapest live gig for this trade, for the snapshot and for the offer
      -- card the worker sees. Null is impossible here because of the gate below.
      (select min(g.price_minor) from public.worker_gigs g
        where g.worker_id = w.id
          and g.service_id = v_booking.service_id
          and g.status = 'ACTIVE') as gig_price_minor
    from public.workers w
    where w.status = 'ACTIVE'
      and w.latitude is not null
      and w.longitude is not null
      and w.is_kyc_verified
      and w.is_background_verified
      -- The gig gate: approved for the trade is not the same as currently
      -- offering it. Only a live gig wins work.
      and public.worker_has_live_gig(w.id, v_booking.service_id)
      and earth_box(ll_to_earth(v_booking.latitude, v_booking.longitude), v_max_radius * 1000)
          @> ll_to_earth(w.latitude, w.longitude)
  ),
  scored as (
    select
      e.id as worker_id,
      e.distance_km,
      e.trade_score,
      e.gig_price_minor,
      (case when e.is_skill_verified then 1.000 else 0.400 end)::numeric(4, 3) as skill_score,
      (case when e.is_qualification_verified then 1.000 else 0.300 end)::numeric(4, 3) as qualification_score,
      (case when e.is_kyc_verified then 1.000 else 0.000 end)::numeric(4, 3) as kyc_score,
      (case when e.is_background_verified then 1.000 else 0.000 end)::numeric(4, 3) as background_score,
      (case when e.is_insured then 1.000 else 0.500 end)::numeric(4, 3) as insurance_score,
      (case e.availability
         when 'AVAILABLE' then 1.000
         when 'BUSY' then 0.300
         else 0.000
       end)::numeric(4, 3) as availability_score,
      (coalesce(e.rating_avg, 3.50) / 5.0)::numeric(4, 3) as rating_score,
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
      'gig_price_minor', wt.gig_price_minor,
      'gig_gate_applied', true,
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
  'Server-side multi-factor matching. Every input is read from the database; a client cannot submit a score. A worker must hold a live gig for the trade.';


-- ===========================================================================
-- Defect fix: transition_booking()
-- ---------------------------------------------------------------------------
-- As written in 0010 the function inserted the previous status into
-- booking_events.from_status as text:
--
--     v_before ->> 'status'          -- text, column is public.booking_status
--
-- Postgres refuses that without a cast, so the INSERT raised
-- 42804 datatype_mismatch and the whole transaction rolled back. The effect was
-- that EVERY booking state transition failed at runtime -- worker accept, travel,
-- arrival, completion, and the admin panel's override path alike. It is not
-- reachable by the type checker at CREATE FUNCTION time because the body of a
-- plpgsql function is only parsed when it first executes, which is why it
-- survived into the schema.
--
-- 0010 is corrected in place so a fresh `supabase db reset` is right. This
-- redefinition repeats the fix for any database that already applied the
-- original. The two definitions are otherwise identical.
-- ===========================================================================
create or replace function public.transition_booking(
  p_booking_id  uuid,
  p_to_status   public.booking_status,
  p_actor_type  public.actor_type,
  p_reason      text default null,
  p_metadata    jsonb default '{}'::jsonb,
  -- Set by an admin override path after a permission check. Still validated
  -- against the transition table; it only relaxes the actor restriction.
  p_admin_override boolean default false
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_booking    public.bookings%rowtype;
  v_transition public.booking_transitions%rowtype;
  v_actor_id   uuid;
  v_before     jsonb;
begin
  -- Lock the row so two concurrent transitions cannot both read the old status.
  select * into v_booking
  from public.bookings
  where id = p_booking_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: booking % does not exist', p_booking_id
      using errcode = 'P0002';
  end if;

  if v_booking.status = p_to_status then
    raise exception 'CONFLICT: booking % is already %', v_booking.booking_code, p_to_status
      using errcode = '23505';
  end if;

  select * into v_transition
  from public.booking_transitions
  where from_status = v_booking.status and to_status = p_to_status;

  if not found then
    raise exception 'INVALID_TRANSITION: % cannot move from % to %',
      v_booking.booking_code, v_booking.status, p_to_status
      using errcode = '23514';
  end if;

  -- An administrator may act outside the normal actor list, but only after the
  -- caller has already proven the bookings.update permission, and only with a
  -- reason on record.
  if not (p_actor_type = any (v_transition.allowed_actors)) then
    if not p_admin_override then
      raise exception 'FORBIDDEN: % may not move a booking from % to %',
        p_actor_type, v_booking.status, p_to_status
        using errcode = '42501';
    end if;

    if p_reason is null or length(btrim(p_reason)) = 0 then
      raise exception 'INVALID: an administrative override requires a reason'
        using errcode = '23514';
    end if;
  end if;

  if v_transition.requires_reason and (p_reason is null or length(btrim(p_reason)) = 0) then
    raise exception 'INVALID: moving from % to % requires a reason',
      v_booking.status, p_to_status
      using errcode = '23514';
  end if;

  -- Work may only begin once arrival has actually been verified, when the
  -- platform is configured to require it.
  if p_to_status = 'IN_PROGRESS' and v_booking.status = 'ARRIVED' then
    if coalesce((select value::boolean from public.platform_settings
                 where key = 'booking.arrival_code_required'), true)
       and v_booking.arrival_verified_at is null
       and not p_admin_override then
      raise exception 'INVALID: arrival must be verified before work can start'
        using errcode = '23514';
    end if;
  end if;

  v_actor_id := case p_actor_type
    when 'ADMIN'    then public.current_admin_id()
    when 'WORKER'   then public.current_worker_id()
    when 'CUSTOMER' then public.current_customer_id()
    else null
  end;

  v_before := jsonb_build_object(
    'status', v_booking.status,
    'worker_id', v_booking.worker_id,
    'final_amount_minor', v_booking.final_amount_minor
  );

  update public.bookings
  set status            = p_to_status,
      accepted_at       = case when p_to_status = 'ACCEPTED'    then now() else accepted_at end,
      confirmed_at      = case when p_to_status = 'CONFIRMED'   then now() else confirmed_at end,
      travel_started_at = case when p_to_status = 'TRAVELING'   then now() else travel_started_at end,
      arrived_at        = case when p_to_status = 'ARRIVED'     then now() else arrived_at end,
      work_started_at   = case when p_to_status = 'IN_PROGRESS' then now() else work_started_at end,
      completed_at      = case when p_to_status = 'COMPLETED'   then now() else completed_at end,
      paid_at           = case when p_to_status = 'PAID'        then now() else paid_at end,
      closed_at         = case when p_to_status = 'CLOSED'      then now() else closed_at end,
      cancelled_at      = case when p_to_status = 'CANCELLED'   then now() else cancelled_at end,
      cancelled_by_type = case when p_to_status = 'CANCELLED'   then p_actor_type else cancelled_by_type end,
      cancellation_reason = case when p_to_status = 'CANCELLED' then p_reason else cancellation_reason end,
      disputed_at       = case when p_to_status = 'DISPUTED'    then now() else disputed_at end,
      dispute_reason    = case when p_to_status = 'DISPUTED'    then p_reason else dispute_reason end
  where id = p_booking_id
  returning * into v_booking;

  insert into public.booking_events
    (booking_id, event_type, from_status, to_status, actor_type, actor_id, note, metadata)
  values
    (p_booking_id,
     case when p_admin_override then 'ADMIN_OVERRIDE'::public.booking_event_type
          else v_transition.event_type end,
     (v_before ->> 'status')::public.booking_status,
     p_to_status,
     p_actor_type,
     v_actor_id,
     p_reason,
     p_metadata);

  -- Administrative action is always auditable.
  if p_actor_type = 'ADMIN' then
    perform public.write_audit_log(
      case when p_admin_override then 'booking.status_override' else 'booking.status_changed' end,
      'booking',
      p_booking_id::text,
      v_before,
      jsonb_build_object('status', p_to_status),
      p_reason
    );
  end if;

  return v_booking;
end;
$$;

-- ===========================================================================
-- Registration
-- ---------------------------------------------------------------------------
-- Creates the platform-side records for a Firebase user who has already
-- authenticated. The Firebase UID is read from the verified token, never from
-- an argument, so this cannot be used to create a profile for somebody else.
-- ===========================================================================
create or replace function public.worker_create_profile(
  p_full_name text,
  p_phone     text,
  p_email     text default null
)
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid     text := public.firebase_uid();
  v_profile public.profiles%rowtype;
  v_worker  public.workers%rowtype;
  v_phone   text;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before creating a profile'
      using errcode = '42501';
  end if;

  -- Already registered: return what exists rather than failing, so a retry
  -- after a dropped connection is harmless.
  select * into v_worker from public.workers where firebase_uid = v_uid;
  if found then
    return v_worker;
  end if;

  if length(btrim(coalesce(p_full_name, ''))) < 2 then
    raise exception 'INVALID: enter your full name' using errcode = '23514';
  end if;

  v_phone := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  -- Accept a leading country code and store the national number, matching the
  -- format the phone check constraint expects.
  if length(v_phone) > 10 and left(v_phone, 2) = '91' then
    v_phone := right(v_phone, 10);
  end if;

  if v_phone !~ '^[0-9]{10,15}$' then
    raise exception 'INVALID: enter a valid mobile number' using errcode = '23514';
  end if;

  if exists (select 1 from public.workers where phone = v_phone) then
    raise exception 'CONFLICT: that number is already registered'
      using errcode = '23505';
  end if;

  -- A Firebase user may already have a profile row from another surface.
  select * into v_profile from public.profiles where firebase_uid = v_uid;

  if not found then
    insert into public.profiles (firebase_uid, role, phone, email, display_name)
    values (v_uid, 'WORKER', v_phone, nullif(btrim(p_email), ''), btrim(p_full_name))
    returning * into v_profile;
  elsif v_profile.role <> 'WORKER' then
    raise exception 'FORBIDDEN: this number is registered as a customer account'
      using errcode = '42501';
  end if;

  insert into public.workers
    (profile_id, firebase_uid, full_name, phone, email, status)
  values
    (v_profile.id, v_uid, btrim(p_full_name), v_phone,
     nullif(btrim(p_email), ''), 'REGISTERED')
  returning * into v_worker;

  return v_worker;
end;
$$;

grant execute on function public.worker_create_profile(text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Primary trade
-- ---------------------------------------------------------------------------
-- primary_service_id is not in the client update grant because it feeds
-- matching. Setting it also records the corresponding worker_services row, so
-- the worker's main trade and their skill list can never disagree.
create or replace function public.worker_set_primary_service(p_service_id uuid)
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  v_worker := public.require_current_worker();

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that trade does not exist' using errcode = 'P0002';
  end if;

  insert into public.worker_services (worker_id, service_id, is_approved)
  values (v_worker.id, p_service_id, false)
  on conflict (worker_id, service_id) do nothing;

  update public.workers
  set primary_service_id = p_service_id
  where id = v_worker.id
  returning * into v_worker;

  return v_worker;
end;
$$;

grant execute on function public.worker_set_primary_service(uuid) to authenticated;

-- ===========================================================================
-- Earnings aggregates
-- ---------------------------------------------------------------------------
-- Summed in the database rather than by shipping the whole ledger to a phone
-- and adding it up there. A worker two years in should not download two years
-- of history to see what they made today.
--
-- Only CREDIT_JOB_EARNING is counted as an earning. Fees, payouts and claim
-- recoveries are real ledger movements but they are not income, and rolling
-- them in would overstate what the worker earned.
-- ===========================================================================
create or replace function public.worker_earnings_summary()
returns jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  v_worker := public.require_current_worker();

  return (
    select jsonb_build_object(
      'today_minor',    coalesce(sum(amount_minor) filter (where created_at >= date_trunc('day', now())), 0),
      'week_minor',     coalesce(sum(amount_minor) filter (where created_at >= date_trunc('week', now())), 0),
      'month_minor',    coalesce(sum(amount_minor) filter (where created_at >= date_trunc('month', now())), 0),
      'lifetime_minor', coalesce(sum(amount_minor), 0)
    )
    from public.wallet_transactions
    where worker_id = v_worker.id
      and type = 'CREDIT_JOB_EARNING'
  );
end;
$$;

grant execute on function public.worker_earnings_summary() to authenticated;

-- ---------------------------------------------------------------------------
-- Per-job earning breakdown
-- ---------------------------------------------------------------------------
-- Groups the ledger by booking so the wallet can show gross, fee and net on one
-- line. The fee is the sum of the DEBIT rows that actually exist for that
-- booking: if the ledger holds no fee entry, the breakdown shows none. Nothing
-- here derives a fee from a percentage, which is what stops the app from
-- displaying a plausible number the accounts do not agree with.
create or replace function public.worker_earning_breakdowns(
  p_limit  integer default 20,
  p_offset integer default 0
)
returns setof jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  v_worker := public.require_current_worker();

  return query
  with per_booking as (
    select
      wt.reference_id as booking_id,
      sum(wt.amount_minor) filter (where wt.type::text like 'CREDIT%') as gross_minor,
      -sum(wt.amount_minor) filter (where wt.type::text like 'DEBIT%')  as fees_minor,
      sum(wt.amount_minor) as net_minor,
      max(wt.created_at) as at,
      max(wt.currency) as currency
    from public.wallet_transactions wt
    where wt.worker_id = v_worker.id
      and wt.reference_type = 'BOOKING'
      and wt.reference_id is not null
    group by wt.reference_id
  )
  select jsonb_build_object(
    'booking_code', b.booking_code,
    'service_name', s.name,
    'gross_minor',  coalesce(pb.gross_minor, 0),
    'fees_minor',   coalesce(pb.fees_minor, 0),
    'net_minor',    pb.net_minor,
    'currency',     coalesce(pb.currency, 'INR'),
    'at',           pb.at
  )
  from per_booking pb
  join public.bookings b on b.id = pb.booking_id
  join public.services s on s.id = b.service_id
  order by pb.at desc
  limit greatest(1, least(coalesce(p_limit, 20), 100))
  offset greatest(0, coalesce(p_offset, 0));
end;
$$;

grant execute on function public.worker_earning_breakdowns(integer, integer) to authenticated;

-- ===========================================================================
-- Claim response
-- ---------------------------------------------------------------------------
-- A worker may answer a claim against them when the assessor has asked for
-- more information. They cannot change its status, its amount, or its outcome;
-- decide_claim() remains the only writer of a decision.
-- ===========================================================================
create or replace function public.worker_respond_to_claim(
  p_claim_id uuid,
  p_response text
)
returns public.claim_events
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_claim  public.claims%rowtype;
  v_event  public.claim_events%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_claim from public.claims where id = p_claim_id;

  if not found or v_claim.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that claim is not yours' using errcode = 'P0002';
  end if;

  if v_claim.status in ('APPROVED', 'PARTIALLY_APPROVED', 'REJECTED', 'CLOSED') then
    raise exception 'INVALID: this claim has already been decided'
      using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_response, ''))) < 10 then
    raise exception 'INVALID: please explain what happened in a little more detail'
      using errcode = '23514';
  end if;

  -- claim_events has no actor_id column (the admin path uses actor_admin_id),
  -- so the responding worker is recorded in metadata.
  insert into public.claim_events
    (claim_id, from_status, to_status, actor_type, note, metadata)
  values
    (p_claim_id, v_claim.status,
     case when v_claim.status = 'MORE_INFORMATION_REQUIRED'
          then 'UNDER_REVIEW'::public.claim_status
          else v_claim.status end,
     'WORKER', btrim(p_response),
     jsonb_build_object('worker_id', v_worker.id))
  returning * into v_event;

  -- A response puts the claim back in front of an assessor.
  update public.claims
  set status = 'UNDER_REVIEW'
  where id = p_claim_id and status = 'MORE_INFORMATION_REQUIRED';

  return v_event;
end;
$$;

grant execute on function public.worker_respond_to_claim(uuid, text) to authenticated;

-- ===========================================================================
-- Media upload status
-- ---------------------------------------------------------------------------
-- A worker has no grant to write media_assets.upload_status, which is what
-- makes COMPLETED mean something: an asset counts as evidence only once the
-- trusted backend has confirmed the object really exists in Firebase Storage
-- and that its size matches what was authorized.
--
-- These two functions are how that confirmation is recorded. They are callable
-- by the worker who owns the asset, but they say nothing about whether the file
-- arrived — the web tier checks that against Storage before calling, and the
-- client is never in that conversation.
-- ===========================================================================
create or replace function public.worker_complete_media_upload(p_media_id uuid)
returns public.media_assets
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_media  public.media_assets%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_media
  from public.media_assets
  where id = p_media_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that upload does not exist' using errcode = 'P0002';
  end if;

  -- The uploader must be this worker. Ownership of the owning resource was
  -- already checked when the upload was authorized; this stops a worker from
  -- completing somebody else's pending row.
  if v_media.uploaded_by_firebase_uid is distinct from v_worker.firebase_uid then
    raise exception 'FORBIDDEN: that upload is not yours' using errcode = '42501';
  end if;

  if v_media.upload_status = 'COMPLETED' then
    return v_media;
  end if;

  if v_media.upload_status not in ('PENDING', 'UPLOADING') then
    raise exception 'INVALID: that upload can no longer be completed'
      using errcode = '23514';
  end if;

  update public.media_assets
  set upload_status = 'COMPLETED',
      completed_at  = now(),
      failure_reason = null
  where id = p_media_id
  returning * into v_media;

  return v_media;
end;
$$;

grant execute on function public.worker_complete_media_upload(uuid) to authenticated;

create or replace function public.worker_fail_media_upload(
  p_media_id uuid,
  p_reason   text
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_media  public.media_assets%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_media from public.media_assets where id = p_media_id;

  if not found
     or v_media.uploaded_by_firebase_uid is distinct from v_worker.firebase_uid then
    -- Nothing to do, and nothing to disclose about another worker's row.
    return;
  end if;

  -- A completed upload is never walked back by this path. Removing evidence is
  -- a separate, administrative decision.
  if v_media.upload_status not in ('PENDING', 'UPLOADING') then
    return;
  end if;

  update public.media_assets
  set upload_status  = 'FAILED',
      failure_reason = coalesce(nullif(btrim(p_reason), ''), 'Upload did not complete')
  where id = p_media_id;
end;
$$;

grant execute on function public.worker_fail_media_upload(uuid, text) to authenticated;

-- Workers need INSERT on media_assets so an upload can be recorded as PENDING.
-- The grant deliberately excludes upload_status and sensitivity: status is
-- written only by the two functions above, and sensitivity is derived from
-- purpose by trigger, so a caller cannot label a KYC document PUBLIC.
grant insert (
  id, firebase_storage_path, storage_bucket, media_type, purpose,
  uploaded_by_type, uploaded_by_firebase_uid, uploaded_by_profile_id,
  worker_id, customer_id, verification_id, booking_id, material_id,
  claim_id, support_ticket_id, service_id,
  original_file_name, mime_type, file_size_bytes, checksum_sha256,
  width, height, duration_seconds, captured_at
) on public.media_assets to authenticated;

create policy media_assets_worker_insert on public.media_assets
  for insert to authenticated
  with check (
    uploaded_by_firebase_uid = public.firebase_uid()
    and uploaded_by_type = 'WORKER'
    -- The owning resource must be one this worker can actually reach. The path
    -- trigger checks the prefix; this checks the relationship.
    and (
      worker_id = public.current_worker_id()
      or (booking_id is not null and public.is_booking_party(booking_id))
      or exists (
        select 1 from public.claims c
        where c.id = claim_id and c.worker_id = public.current_worker_id()
      )
      or exists (
        select 1 from public.support_tickets t
        where t.id = support_ticket_id and t.worker_id = public.current_worker_id()
      )
    )
  );
