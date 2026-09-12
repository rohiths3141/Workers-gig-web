-- ===========================================================================
-- 0010  The booking state machine and the verification decision path
-- ---------------------------------------------------------------------------
-- No React component, and no client of any kind, ever writes bookings.status.
-- The flow is always:
--
--   Admin UI / Flutter app
--        -> trusted server operation (this file)
--        -> permission validation
--        -> state transition validation
--        -> database transaction
--        -> audit log
--        -> timeline event
--
-- Legal transitions live in a table rather than in a CASE expression so the
-- admin UI can ask the database which actions are actually available, instead
-- of hard-coding a second copy of the rules that can drift.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Transition table
-- ---------------------------------------------------------------------------
create table public.booking_transitions (
  from_status     public.booking_status not null,
  to_status       public.booking_status not null,
  -- Who may make this move unaided.
  allowed_actors  public.actor_type[] not null,
  event_type      public.booking_event_type not null,
  -- Requires a written reason from the actor.
  requires_reason boolean not null default false,
  description     text not null,
  primary key (from_status, to_status)
);

insert into public.booking_transitions
  (from_status, to_status, allowed_actors, event_type, requires_reason, description)
values
  ('REQUESTED',  'ACCEPTED',  array['WORKER','SYSTEM']::public.actor_type[],            'WORKER_ACCEPTED',   false, 'A matched worker accepted the job'),
  ('REQUESTED',  'CANCELLED', array['CUSTOMER','ADMIN']::public.actor_type[],           'BOOKING_CANCELLED', true,  'Cancelled before any worker accepted'),
  ('REQUESTED',  'EXPIRED',   array['SYSTEM']::public.actor_type[],                     'BOOKING_CANCELLED', false, 'No worker accepted within the offer window'),

  ('ACCEPTED',   'CONFIRMED', array['CUSTOMER','ADMIN']::public.actor_type[],           'BOOKING_CONFIRMED', false, 'Customer confirmed the selected worker'),
  ('ACCEPTED',   'CANCELLED', array['CUSTOMER','WORKER','ADMIN']::public.actor_type[],  'BOOKING_CANCELLED', true,  'Cancelled after acceptance'),

  ('CONFIRMED',  'TRAVELING', array['WORKER']::public.actor_type[],                     'TRAVEL_STARTED',    false, 'Worker started travelling to the site'),
  ('CONFIRMED',  'CANCELLED', array['CUSTOMER','WORKER','ADMIN']::public.actor_type[],  'BOOKING_CANCELLED', true,  'Cancelled before travel'),

  ('TRAVELING',  'ARRIVED',   array['WORKER']::public.actor_type[],                     'WORKER_ARRIVED',    false, 'Worker reached the site'),
  ('TRAVELING',  'CANCELLED', array['CUSTOMER','WORKER','ADMIN']::public.actor_type[],  'BOOKING_CANCELLED', true,  'Cancelled while travelling'),

  ('ARRIVED',    'IN_PROGRESS', array['WORKER']::public.actor_type[],                   'WORK_STARTED',      false, 'Arrival verified and work started'),
  ('ARRIVED',    'CANCELLED', array['CUSTOMER','ADMIN']::public.actor_type[],           'BOOKING_CANCELLED', true,  'Cancelled at the door'),
  ('ARRIVED',    'DISPUTED',  array['CUSTOMER','WORKER','ADMIN']::public.actor_type[],  'DISPUTE_RAISED',    true,  'Dispute raised on arrival'),

  ('IN_PROGRESS','AWAITING_APPROVAL', array['WORKER']::public.actor_type[],             'WORK_COMPLETED',    false, 'Worker finished and asked the customer to approve'),
  ('IN_PROGRESS','DISPUTED',  array['CUSTOMER','WORKER','ADMIN']::public.actor_type[],  'DISPUTE_RAISED',    true,  'Dispute raised during the job'),

  ('AWAITING_APPROVAL','COMPLETED',   array['CUSTOMER','ADMIN']::public.actor_type[],   'CUSTOMER_APPROVED', false, 'Customer approved the completed work'),
  ('AWAITING_APPROVAL','IN_PROGRESS', array['CUSTOMER','ADMIN']::public.actor_type[],   'WORK_STARTED',      true,  'Customer sent the job back for more work'),
  ('AWAITING_APPROVAL','DISPUTED',    array['CUSTOMER','ADMIN']::public.actor_type[],   'DISPUTE_RAISED',    true,  'Customer disputed the completed work'),

  ('COMPLETED',  'PAYMENT_PENDING', array['SYSTEM','ADMIN']::public.actor_type[],       'PAYMENT_INITIATED', false, 'Final amount computed and payment requested'),
  ('COMPLETED',  'DISPUTED',  array['CUSTOMER','ADMIN']::public.actor_type[],           'DISPUTE_RAISED',    true,  'Dispute raised after completion'),

  ('PAYMENT_PENDING','PAID',  array['SYSTEM']::public.actor_type[],                     'PAYMENT_COMPLETED', false, 'Gateway-verified payment captured'),
  ('PAYMENT_PENDING','CANCELLED', array['ADMIN']::public.actor_type[],                  'BOOKING_CANCELLED', true,  'Written off by operations'),
  ('PAYMENT_PENDING','DISPUTED', array['CUSTOMER','ADMIN']::public.actor_type[],        'DISPUTE_RAISED',    true,  'Dispute raised at payment'),

  ('PAID',       'CLOSED',    array['SYSTEM','ADMIN']::public.actor_type[],             'BOOKING_CLOSED',    false, 'Settled and closed'),
  ('PAID',       'DISPUTED',  array['CUSTOMER','ADMIN']::public.actor_type[],           'DISPUTE_RAISED',    true,  'Dispute raised after payment'),

  ('DISPUTED',   'IN_PROGRESS', array['ADMIN']::public.actor_type[],                    'WORK_STARTED',      true,  'Dispute resolved, work resumed'),
  ('DISPUTED',   'COMPLETED', array['ADMIN']::public.actor_type[],                      'CUSTOMER_APPROVED', true,  'Dispute resolved in favour of completion'),
  ('DISPUTED',   'CANCELLED', array['ADMIN']::public.actor_type[],                      'BOOKING_CANCELLED', true,  'Dispute resolved by cancelling the job'),
  ('DISPUTED',   'CLOSED',    array['ADMIN']::public.actor_type[],                      'BOOKING_CLOSED',    true,  'Dispute closed without further action');

comment on table public.booking_transitions is
  'The booking state machine as data. The admin UI reads it to decide which actions to offer; transition_booking() reads it to decide which to permit.';

grant select on public.booking_transitions to authenticated;

alter table public.booking_transitions enable row level security;
alter table public.booking_transitions force row level security;

create policy booking_transitions_read on public.booking_transitions
  for select to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- The single writer of bookings.status
-- ---------------------------------------------------------------------------
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
     v_before ->> 'status',
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

comment on function public.transition_booking is
  'The only writer of bookings.status. Validates the transition, records the timeline event, and audits administrative action.';

-- ---------------------------------------------------------------------------
-- Administrative entry point
-- ---------------------------------------------------------------------------
-- Separate from the function above so the permission check cannot be skipped by
-- a caller that forgets to pass p_admin_override correctly.
create or replace function public.admin_transition_booking(
  p_booking_id uuid,
  p_to_status  public.booking_status,
  p_reason     text
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_permission text;
begin
  v_permission := case
    when p_to_status = 'CANCELLED' then 'bookings.cancel'
    else 'bookings.update'
  end;

  perform public.require_permission(v_permission);

  if p_reason is null or length(btrim(p_reason)) < 5 then
    raise exception 'INVALID: an administrative status change requires a reason of at least 5 characters'
      using errcode = '23514';
  end if;

  return public.transition_booking(
    p_booking_id, p_to_status, 'ADMIN', p_reason, '{}'::jsonb, true
  );
end;
$$;

grant execute on function public.admin_transition_booking(uuid, public.booking_status, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Verification decisions
-- ---------------------------------------------------------------------------
-- A worker can never approve their own case: the reviewer is resolved from the
-- caller's admin identity, and a self-review is refused outright.
create or replace function public.decide_verification(
  p_verification_id  uuid,
  p_decision         text,             -- APPROVE | REJECT | REQUEST_INFO | TAKE_REVIEW
  p_note             text default null,
  p_rejection_reason text default null,
  p_info_requested   text default null,
  p_expires_at       timestamptz default null
)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_case     public.worker_verifications%rowtype;
  v_worker   public.workers%rowtype;
  v_admin_id uuid;
  v_before   jsonb;
  v_status   public.verification_status;
begin
  if p_decision not in ('APPROVE', 'REJECT', 'REQUEST_INFO', 'TAKE_REVIEW') then
    raise exception 'INVALID: unknown verification decision %', p_decision
      using errcode = '23514';
  end if;

  v_admin_id := public.require_permission(
    case p_decision
      when 'APPROVE'      then 'verification.approve'
      when 'REJECT'       then 'verification.reject'
      else 'verification.review'
    end
  );

  select * into v_case
  from public.worker_verifications
  where id = p_verification_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: verification case % does not exist', p_verification_id
      using errcode = 'P0002';
  end if;

  select * into v_worker from public.workers where id = v_case.worker_id;

  -- Nobody reviews their own paperwork.
  if v_worker.firebase_uid = public.firebase_uid() then
    raise exception 'FORBIDDEN: a worker may not decide their own verification'
      using errcode = '42501';
  end if;

  if v_case.status in ('APPROVED', 'REJECTED') and p_decision <> 'TAKE_REVIEW' then
    raise exception 'CONFLICT: verification case is already %, reopen it before deciding again', v_case.status
      using errcode = '23505';
  end if;

  if p_decision = 'REJECT' and (p_rejection_reason is null or length(btrim(p_rejection_reason)) < 5) then
    raise exception 'INVALID: a rejection requires a reason of at least 5 characters'
      using errcode = '23514';
  end if;

  if p_decision = 'REQUEST_INFO' and (p_info_requested is null or length(btrim(p_info_requested)) < 5) then
    raise exception 'INVALID: state what additional information is required'
      using errcode = '23514';
  end if;

  v_status := case p_decision
    when 'APPROVE'      then 'APPROVED'
    when 'REJECT'       then 'REJECTED'
    when 'REQUEST_INFO' then 'MORE_INFO_REQUIRED'
    else 'UNDER_REVIEW'
  end::public.verification_status;

  v_before := jsonb_build_object(
    'status', v_case.status,
    'reviewed_by', v_case.reviewed_by,
    'expires_at', v_case.expires_at
  );

  update public.worker_verifications
  set status           = v_status,
      reviewed_by      = case when p_decision in ('APPROVE', 'REJECT') then v_admin_id else reviewed_by end,
      reviewed_at      = case when p_decision in ('APPROVE', 'REJECT') then now() else reviewed_at end,
      assigned_to      = case when p_decision = 'TAKE_REVIEW' then v_admin_id else assigned_to end,
      assigned_at      = case when p_decision = 'TAKE_REVIEW' then now() else assigned_at end,
      decision_note    = coalesce(p_note, decision_note),
      rejection_reason = case when p_decision = 'REJECT' then p_rejection_reason else null end,
      info_requested   = case when p_decision = 'REQUEST_INFO' then p_info_requested else null end,
      expires_at       = case when p_decision = 'APPROVE' then p_expires_at else expires_at end
  where id = p_verification_id
  returning * into v_case;

  perform public.write_audit_log(
    'verification.' || lower(p_decision),
    'worker_verification',
    p_verification_id::text,
    v_before,
    jsonb_build_object('status', v_status, 'expires_at', v_case.expires_at),
    coalesce(p_rejection_reason, p_info_requested, p_note)
  );

  return v_case;
end;
$$;

grant execute on function
  public.decide_verification(uuid, text, text, text, text, timestamptz)
to authenticated;

-- ---------------------------------------------------------------------------
-- Derived verification flags on the worker record
-- ---------------------------------------------------------------------------
-- workers.is_* columns are a projection of the approved, unexpired cases. They
-- are recomputed here and are never writable by any client, which is what makes
-- a verification badge on the public site meaningful.
create or replace function public.sync_worker_verification_flags()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker_id uuid := coalesce(new.worker_id, old.worker_id);
  v_kyc   boolean;
  v_qual  boolean;
  v_skill boolean;
  v_bgv   boolean;
  v_ins   boolean;
begin
  select
    bool_or(type = 'IDENTITY_KYC'      and status = 'APPROVED' and (expires_at is null or expires_at > now())),
    bool_or(type in ('ITI_CERTIFICATE','DIPLOMA') and status = 'APPROVED' and (expires_at is null or expires_at > now())),
    bool_or(type = 'RPL_SKILL'         and status = 'APPROVED' and (expires_at is null or expires_at > now())),
    bool_or(type = 'BACKGROUND_CHECK'  and status = 'APPROVED' and (expires_at is null or expires_at > now())),
    bool_or(type = 'INSURANCE'         and status = 'APPROVED' and (expires_at is null or expires_at > now()))
  into v_kyc, v_qual, v_skill, v_bgv, v_ins
  from public.worker_verifications
  where worker_id = v_worker_id;

  update public.workers
  set is_kyc_verified           = coalesce(v_kyc, false),
      is_qualification_verified = coalesce(v_qual, false),
      is_skill_verified         = coalesce(v_skill, false),
      is_background_verified    = coalesce(v_bgv, false),
      is_insured                = coalesce(v_ins, false),
      -- "Verified" on the public site means identity and background are both
      -- approved and current. Nothing weaker is presented as verified.
      verified_at = case
        when coalesce(v_kyc, false) and coalesce(v_bgv, false) and verified_at is null then now()
        when not (coalesce(v_kyc, false) and coalesce(v_bgv, false)) then null
        else verified_at
      end
  where id = v_worker_id;

  return null;
end;
$$;

create trigger worker_verifications_sync_flags
  after insert or update or delete on public.worker_verifications
  for each row execute function public.sync_worker_verification_flags();

-- ---------------------------------------------------------------------------
-- Expiry sweep
-- ---------------------------------------------------------------------------
-- Run on a schedule. Certificates and background checks go stale, and a stale
-- check must stop counting as verification.
create or replace function public.expire_stale_verifications()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer;
begin
  with expired as (
    update public.worker_verifications
    set status = 'EXPIRED'
    where status = 'APPROVED'
      and expires_at is not null
      and expires_at <= now()
    returning id
  )
  select count(*) into v_count from expired;

  if v_count > 0 then
    perform public.write_audit_log(
      'verification.expired_sweep', 'worker_verification', null,
      null, jsonb_build_object('expired_count', v_count),
      'Scheduled expiry of time-limited verification records'
    );
  end if;

  return v_count;
end;
$$;

-- ---------------------------------------------------------------------------
-- Rating aggregates
-- ---------------------------------------------------------------------------
create or replace function public.sync_rating_aggregates()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker_id   uuid := coalesce(new.worker_id, old.worker_id);
  v_customer_id uuid := coalesce(new.customer_id, old.customer_id);
begin
  update public.workers w
  set rating_avg = agg.avg_rating,
      rating_count = agg.rating_count
  from (
    select round(avg(rating)::numeric, 2) as avg_rating, count(*) as rating_count
    from public.ratings
    where worker_id = v_worker_id and rater_type = 'CUSTOMER' and not is_hidden
  ) agg
  where w.id = v_worker_id;

  update public.customers c
  set rating_avg = agg.avg_rating,
      rating_count = agg.rating_count
  from (
    select round(avg(rating)::numeric, 2) as avg_rating, count(*) as rating_count
    from public.ratings
    where customer_id = v_customer_id and rater_type = 'WORKER' and not is_hidden
  ) agg
  where c.id = v_customer_id;

  return null;
end;
$$;

create trigger ratings_sync_aggregates
  after insert or update or delete on public.ratings
  for each row execute function public.sync_rating_aggregates();
