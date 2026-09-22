-- ===========================================================================
-- 0004  Bookings, the match candidate record, and materials
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Bookings
-- ---------------------------------------------------------------------------
-- status is never updated directly by a client. public.transition_booking() in
-- 0009 is the only writer, and RLS forbids UPDATE on this table for every
-- non-service role.
create table public.bookings (
  id             uuid primary key default gen_random_uuid(),
  booking_code   text not null unique,
  customer_id    uuid not null references public.customers (id) on delete restrict,
  worker_id      uuid references public.workers (id) on delete restrict,
  service_id     uuid not null references public.services (id) on delete restrict,
  status         public.booking_status not null default 'REQUESTED',

  problem_description text not null,
  scheduled_at   timestamptz,
  -- Service address, snapshotted at booking time so later profile edits do not
  -- rewrite history.
  address_line   text not null,
  city           text,
  state          text,
  pincode        text,
  latitude       double precision,
  longitude      double precision,

  -- Money is stored in minor units (paise) as integers. Never floating point.
  quoted_amount_minor   bigint,
  labour_amount_minor   bigint,
  material_amount_minor bigint not null default 0,
  platform_fee_minor    bigint not null default 0,
  worker_amount_minor   bigint,
  final_amount_minor    bigint,
  currency       text not null default 'INR',

  -- One-time code the customer reads out to confirm the worker actually arrived.
  arrival_code   text,
  arrival_verified_at timestamptz,

  accepted_at    timestamptz,
  confirmed_at   timestamptz,
  travel_started_at timestamptz,
  arrived_at     timestamptz,
  work_started_at timestamptz,
  completed_at   timestamptz,
  paid_at        timestamptz,
  closed_at      timestamptz,

  cancelled_at   timestamptz,
  cancelled_by_type public.actor_type,
  cancellation_reason text,

  dispute_reason text,
  disputed_at    timestamptz,

  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint bookings_amounts_non_negative check (
    coalesce(quoted_amount_minor, 0) >= 0
    and coalesce(labour_amount_minor, 0) >= 0
    and material_amount_minor >= 0
    and platform_fee_minor >= 0
    and coalesce(worker_amount_minor, 0) >= 0
    and coalesce(final_amount_minor, 0) >= 0
  ),
  -- A booking past the matching stage must have a worker attached.
  constraint bookings_worker_required_after_accept check (
    status in ('REQUESTED', 'CANCELLED', 'EXPIRED') or worker_id is not null
  ),
  constraint bookings_cancellation_attributed check (
    status <> 'CANCELLED'
    or (cancelled_by_type is not null
        and cancellation_reason is not null
        and length(btrim(cancellation_reason)) > 0)
  ),
  constraint bookings_latitude_range check (latitude is null or (latitude between -90 and 90)),
  constraint bookings_longitude_range check (longitude is null or (longitude between -180 and 180))
);

comment on column public.bookings.status is
  'Written only by public.transition_booking(). Direct UPDATE is blocked by RLS.';
comment on column public.bookings.quoted_amount_minor is
  'Minor currency units (paise). Integer arithmetic only.';

create index bookings_status_idx on public.bookings (status, created_at desc);
create index bookings_customer_idx on public.bookings (customer_id, created_at desc);
create index bookings_worker_idx on public.bookings (worker_id, created_at desc);
create index bookings_service_idx on public.bookings (service_id, created_at desc);
create index bookings_scheduled_idx on public.bookings (scheduled_at)
  where status in ('CONFIRMED', 'ACCEPTED', 'TRAVELING');
create index bookings_code_trgm_idx on public.bookings using gin (booking_code gin_trgm_ops);
create index bookings_active_idx on public.bookings (created_at desc)
  where status in ('ACCEPTED', 'CONFIRMED', 'TRAVELING', 'ARRIVED', 'IN_PROGRESS', 'AWAITING_APPROVAL');

create trigger bookings_touch_updated_at
  before update on public.bookings
  for each row execute function public.touch_updated_at();

create or replace function public.assign_booking_code()
returns trigger
language plpgsql
as $$
begin
  if new.booking_code is null or length(btrim(new.booking_code)) = 0 then
    new.booking_code := 'BK-' || to_char(now(), 'YYMMDD') || '-' ||
                        upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger bookings_assign_code
  before insert on public.bookings
  for each row execute function public.assign_booking_code();

-- ---------------------------------------------------------------------------
-- Booking timeline
-- ---------------------------------------------------------------------------
-- Append-only. Every row is written by a trusted server operation, and the admin
-- timeline renders exactly these rows — it never synthesises steps that did not
-- happen.
create table public.booking_events (
  id           bigint generated always as identity primary key,
  booking_id   uuid not null references public.bookings (id) on delete cascade,
  event_type   public.booking_event_type not null,
  from_status  public.booking_status,
  to_status    public.booking_status,
  actor_type   public.actor_type not null,
  actor_id     uuid,
  note         text,
  metadata     jsonb not null default '{}'::jsonb,
  created_at   timestamptz not null default now()
);

create index booking_events_booking_idx on public.booking_events (booking_id, created_at);
create index booking_events_type_idx on public.booking_events (event_type, created_at desc);

-- ---------------------------------------------------------------------------
-- Match candidates
-- ---------------------------------------------------------------------------
-- Written by the server-side matching engine only. A client can never submit a
-- score for itself: RLS grants no INSERT or UPDATE to authenticated users, and
-- every score column is recomputed from database state by
-- public.run_matching() in 0009.
create table public.booking_match_candidates (
  id             uuid primary key default gen_random_uuid(),
  booking_id     uuid not null references public.bookings (id) on delete cascade,
  worker_id      uuid not null references public.workers (id) on delete cascade,

  distance_km          numeric(6, 2) not null,
  -- Each factor is 0..1; total_score is the weighted sum, also 0..1.
  trade_match_score    numeric(4, 3) not null,
  skill_score          numeric(4, 3) not null,
  qualification_score  numeric(4, 3) not null,
  kyc_score            numeric(4, 3) not null,
  background_score     numeric(4, 3) not null,
  insurance_score      numeric(4, 3) not null,
  availability_score   numeric(4, 3) not null,
  rating_score         numeric(4, 3) not null,
  proximity_score      numeric(4, 3) not null,
  total_score          numeric(5, 4) not null,
  rank                 integer not null,

  was_offered    boolean not null default false,
  offered_at     timestamptz,
  -- 'ACCEPTED', 'DECLINED', 'TIMED_OUT', NULL while pending
  response       text,
  responded_at   timestamptz,
  -- Snapshot of the weights and inputs used, so a past decision is explainable
  -- even after the algorithm is retuned.
  scoring_snapshot jsonb not null default '{}'::jsonb,
  created_at     timestamptz not null default now(),

  constraint match_candidates_unique unique (booking_id, worker_id),
  constraint match_candidates_scores_bounded check (
    trade_match_score between 0 and 1
    and skill_score between 0 and 1
    and qualification_score between 0 and 1
    and kyc_score between 0 and 1
    and background_score between 0 and 1
    and insurance_score between 0 and 1
    and availability_score between 0 and 1
    and rating_score between 0 and 1
    and proximity_score between 0 and 1
    and total_score between 0 and 1
  ),
  constraint match_candidates_distance_non_negative check (distance_km >= 0),
  constraint match_candidates_response_valid check (
    response is null or response in ('ACCEPTED', 'DECLINED', 'TIMED_OUT')
  )
);

create index match_candidates_booking_idx on public.booking_match_candidates (booking_id, rank);
create index match_candidates_worker_idx on public.booking_match_candidates (worker_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Materials
-- ---------------------------------------------------------------------------
create table public.materials (
  id             uuid primary key default gen_random_uuid(),
  booking_id     uuid not null references public.bookings (id) on delete cascade,
  worker_id      uuid not null references public.workers (id) on delete restrict,
  name           text not null,
  description    text,
  quantity       numeric(10, 2) not null default 1,
  unit           text not null default 'unit',
  estimated_cost_minor bigint not null,
  actual_cost_minor    bigint,
  currency       text not null default 'INR',
  status         public.material_status not null default 'REQUESTED',

  customer_decision_at timestamptz,
  customer_rejection_reason text,
  purchased_at   timestamptz,
  cost_recorded_at timestamptz,
  billed_at      timestamptz,

  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint materials_quantity_positive check (quantity > 0),
  constraint materials_estimate_non_negative check (estimated_cost_minor >= 0),
  constraint materials_actual_non_negative check (actual_cost_minor is null or actual_cost_minor >= 0),
  -- A material cannot be billed without a recorded actual cost. Migration 0008
  -- additionally requires a receipt media asset once that table exists.
  constraint materials_billed_requires_cost check (
    status <> 'BILLED' or actual_cost_minor is not null
  ),
  constraint materials_rejection_has_reason check (
    status <> 'REJECTED' or (customer_rejection_reason is not null
                             and length(btrim(customer_rejection_reason)) > 0)
  )
);

create index materials_booking_idx on public.materials (booking_id, created_at);
create index materials_status_idx on public.materials (status, created_at desc);
create index materials_worker_idx on public.materials (worker_id, created_at desc);

create trigger materials_touch_updated_at
  before update on public.materials
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Job evidence
-- ---------------------------------------------------------------------------
-- Before/during/after photos and arrival proof live in Firebase Storage and are
-- referenced through public.media_assets (migration 0008) by booking_id and
-- media purpose. No binary and no bucket path is stored on this table.

-- ---------------------------------------------------------------------------
-- Ratings
-- ---------------------------------------------------------------------------
create table public.ratings (
  id          uuid primary key default gen_random_uuid(),
  booking_id  uuid not null references public.bookings (id) on delete cascade,
  rater_type  public.actor_type not null,
  worker_id   uuid not null references public.workers (id) on delete cascade,
  customer_id uuid not null references public.customers (id) on delete cascade,
  rating      smallint not null,
  comment     text,
  -- Hidden from public view by trust and safety without deleting the record.
  is_hidden   boolean not null default false,
  hidden_reason text,
  hidden_by   uuid references public.admin_users (id) on delete set null,
  created_at  timestamptz not null default now(),

  constraint ratings_value_range check (rating between 1 and 5),
  constraint ratings_rater_valid check (rater_type in ('CUSTOMER', 'WORKER')),
  -- One rating per booking per direction.
  constraint ratings_unique_per_direction unique (booking_id, rater_type)
);

create index ratings_worker_idx on public.ratings (worker_id, created_at desc) where not is_hidden;
create index ratings_customer_idx on public.ratings (customer_id, created_at desc) where not is_hidden;
