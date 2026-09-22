-- ===========================================================================
-- 0034  Customer-posted service requests (Model B)
-- ---------------------------------------------------------------------------
-- Adds the second marketplace model: customers post service requirements and
-- workers respond with offers.
--
-- This coexists with the existing direct-gig model (Model A). The unified
-- bookings table tracks the origin via a new booking_source column. No
-- existing tables or columns are modified destructively.
--
-- New domain:
--   1. customer_service_requests — what a customer needs done
--   2. service_request_offers    — worker responses to a request
--
-- New enums:
--   service_request_status, budget_type, schedule_type, offer_status,
--   booking_source
--
-- Security posture identical to 0013/0014:
--   * Identity derived from JWT, never from arguments
--   * State transitions validated server-side
--   * Exact customer location hidden from workers until booking
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.service_request_status as enum (
  'DRAFT',              -- customer is still writing it
  'OPEN',               -- published, awaiting offers
  'RECEIVING_OFFERS',   -- at least one offer received
  'WORKER_SELECTED',    -- customer chose a worker; booking pending
  'BOOKED',             -- booking created from accepted offer
  'CANCELLED',          -- customer withdrew
  'EXPIRED',            -- timed out without acceptance
  'CLOSED'              -- terminal, after booking completes
);

create type public.budget_type as enum (
  'NONE',    -- customer has no budget preference
  'FIXED',   -- single amount
  'RANGE'    -- min..max
);

create type public.schedule_type as enum (
  'ASAP',
  'TODAY',
  'TOMORROW',
  'SPECIFIC_DATE'
);

create type public.offer_status as enum (
  'SUBMITTED',   -- worker sent the offer
  'VIEWED',      -- customer opened it
  'SHORTLISTED', -- customer bookmarked it
  'ACCEPTED',    -- customer chose this offer
  'REJECTED',    -- customer passed
  'WITHDRAWN',   -- worker pulled it back
  'EXPIRED',     -- request expired or closed
  'CLOSED'       -- terminal after booking flow
);

create type public.booking_source as enum (
  'DIRECT_GIG',        -- existing model: customer books a worker's gig
  'CUSTOMER_REQUEST'   -- new model: customer posts, worker offers
);

-- Add new media purpose for request photos.
alter type public.media_purpose add value if not exists 'SERVICE_REQUEST_PHOTO';

-- Add new booking event types for the request flow.
alter type public.booking_event_type add value if not exists 'OFFER_ACCEPTED';
alter type public.booking_event_type add value if not exists 'SERVICE_REQUEST_BOOKED';

-- ---------------------------------------------------------------------------
-- customer_service_requests
-- ---------------------------------------------------------------------------
create table public.customer_service_requests (
  id               uuid primary key default gen_random_uuid(),
  request_code     text not null unique,
  customer_id      uuid not null references public.customers (id) on delete restrict,
  category_id      uuid not null references public.services (id) on delete restrict,

  title            text not null,
  description      text not null,

  -- Budget
  budget_type      public.budget_type not null default 'NONE',
  budget_min_minor bigint,
  budget_max_minor bigint,
  currency         text not null default 'INR',

  -- Schedule
  schedule_type    public.schedule_type not null default 'ASAP',
  scheduled_date   date,
  time_window_start time,
  time_window_end   time,

  -- Location (exact — revealed only after booking)
  address_line     text not null,
  city             text,
  state            text,
  pincode          text,
  latitude         double precision,
  longitude        double precision,

  -- Privacy-safe location for worker discovery (±500 m noise)
  approx_latitude  double precision,
  approx_longitude double precision,

  -- Lifecycle
  status           public.service_request_status not null default 'DRAFT',
  offer_count      integer not null default 0,
  max_offers       integer not null default 20,

  -- Selection
  selected_offer_id  uuid,   -- FK added after offers table exists
  selected_worker_id uuid references public.workers (id) on delete set null,

  -- Expiration
  expires_at       timestamptz,

  -- Optional extras
  additional_notes text,

  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  -- Constraints
  constraint csr_title_length check (
    length(btrim(title)) between 6 and 200
  ),
  constraint csr_description_length check (
    length(btrim(description)) >= 10
  ),
  constraint csr_address_length check (
    length(btrim(address_line)) >= 5
  ),
  constraint csr_budget_fixed_requires_min check (
    budget_type <> 'FIXED' or budget_min_minor is not null
  ),
  constraint csr_budget_range_requires_both check (
    budget_type <> 'RANGE' or (budget_min_minor is not null and budget_max_minor is not null)
  ),
  constraint csr_budget_range_ordered check (
    budget_max_minor is null or budget_min_minor is null
    or budget_min_minor <= budget_max_minor
  ),
  constraint csr_budget_non_negative check (
    coalesce(budget_min_minor, 0) >= 0
    and coalesce(budget_max_minor, 0) >= 0
  ),
  constraint csr_schedule_date_required check (
    schedule_type <> 'SPECIFIC_DATE' or scheduled_date is not null
  ),
  constraint csr_time_window_ordered check (
    time_window_start is null or time_window_end is null
    or time_window_start < time_window_end
  ),
  constraint csr_latitude_range check (
    latitude is null or (latitude between -90 and 90)
  ),
  constraint csr_longitude_range check (
    longitude is null or (longitude between -180 and 180)
  ),
  constraint csr_offer_count_non_negative check (offer_count >= 0),
  constraint csr_max_offers_positive check (max_offers > 0 and max_offers <= 100)
);

comment on table public.customer_service_requests is
  'A service a customer needs. Workers discover these and respond with offers. The complement of worker_gigs.';
comment on column public.customer_service_requests.approx_latitude is
  'Noisy latitude (±500 m) shown to workers during discovery. Exact location is revealed only after a booking is created.';

create index csr_customer_idx on public.customer_service_requests (customer_id, created_at desc);
create index csr_status_idx on public.customer_service_requests (status, created_at desc);
create index csr_category_status_idx on public.customer_service_requests (category_id, status, created_at desc)
  where status in ('OPEN', 'RECEIVING_OFFERS');
create index csr_expires_idx on public.customer_service_requests (expires_at)
  where status in ('OPEN', 'RECEIVING_OFFERS') and expires_at is not null;
create index csr_code_trgm_idx on public.customer_service_requests using gin (request_code gin_trgm_ops);

-- Geospatial index for worker discovery queries.
create index csr_approx_location_idx
  on public.customer_service_requests using gist (
    ll_to_earth(approx_latitude, approx_longitude)
  )
  where approx_latitude is not null
    and approx_longitude is not null
    and status in ('OPEN', 'RECEIVING_OFFERS');

create trigger csr_touch_updated_at
  before update on public.customer_service_requests
  for each row execute function public.touch_updated_at();

-- Human-readable request code, assigned on insert.
create or replace function public.assign_service_request_code()
returns trigger
language plpgsql
as $$
begin
  if new.request_code is null or length(btrim(new.request_code)) = 0 then
    new.request_code := 'SR-' || to_char(now(), 'YYMMDD') || '-' ||
                        upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger csr_assign_code
  before insert on public.customer_service_requests
  for each row execute function public.assign_service_request_code();

-- ---------------------------------------------------------------------------
-- service_request_offers
-- ---------------------------------------------------------------------------
create table public.service_request_offers (
  id                    uuid primary key default gen_random_uuid(),
  service_request_id    uuid not null references public.customer_service_requests (id) on delete cascade,
  worker_id             uuid not null references public.workers (id) on delete cascade,
  gig_id                uuid references public.worker_gigs (id) on delete set null,

  message               text,
  proposed_price_minor  bigint not null,
  currency              text not null default 'INR',
  estimated_duration_minutes integer,

  -- When the worker can come
  availability_date     date,
  availability_start    time,
  availability_end      time,

  status                public.offer_status not null default 'SUBMITTED',

  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),

  -- One active offer per worker per request.
  constraint sro_unique_worker_request unique (service_request_id, worker_id),
  constraint sro_price_positive check (proposed_price_minor > 0),
  constraint sro_duration_sane check (
    estimated_duration_minutes is null
    or (estimated_duration_minutes between 15 and 20160)
  ),
  constraint sro_availability_ordered check (
    availability_start is null or availability_end is null
    or availability_start < availability_end
  ),
  constraint sro_message_length check (
    message is null or length(btrim(message)) >= 5
  )
);

comment on table public.service_request_offers is
  'A worker''s bid on a customer service request. Exactly one may be accepted per request.';

create index sro_request_idx on public.service_request_offers (service_request_id, created_at desc);
create index sro_worker_idx on public.service_request_offers (worker_id, created_at desc);
create index sro_status_idx on public.service_request_offers (status, created_at desc);

create trigger sro_touch_updated_at
  before update on public.service_request_offers
  for each row execute function public.touch_updated_at();

-- Offer count trigger: keep customer_service_requests.offer_count in sync.
create or replace function public.sync_offer_count()
returns trigger
language plpgsql
as $$
begin
  if TG_OP = 'INSERT' then
    update public.customer_service_requests
    set offer_count = offer_count + 1
    where id = NEW.service_request_id;

    -- Auto-transition OPEN → RECEIVING_OFFERS on first offer.
    update public.customer_service_requests
    set status = 'RECEIVING_OFFERS'
    where id = NEW.service_request_id
      and status = 'OPEN';

  elsif TG_OP = 'DELETE' then
    update public.customer_service_requests
    set offer_count = greatest(offer_count - 1, 0)
    where id = OLD.service_request_id;
  end if;

  return null;
end;
$$;

create trigger sro_sync_offer_count
  after insert or delete on public.service_request_offers
  for each row execute function public.sync_offer_count();

-- Now add the FK from customer_service_requests.selected_offer_id.
alter table public.customer_service_requests
  add constraint csr_selected_offer_fk
  foreign key (selected_offer_id)
  references public.service_request_offers (id)
  on delete set null;

-- ---------------------------------------------------------------------------
-- Extend bookings table
-- ---------------------------------------------------------------------------
-- booking_source tracks origin. Defaults to DIRECT_GIG for backward compat.
-- service_request_id and offer_id link back to Model B when applicable.
-- gig_id already exists (added in 0013).

alter table public.bookings
  add column if not exists booking_source public.booking_source not null default 'DIRECT_GIG',
  add column if not exists service_request_id uuid references public.customer_service_requests (id) on delete set null,
  add column if not exists offer_id uuid references public.service_request_offers (id) on delete set null;

comment on column public.bookings.booking_source is
  'DIRECT_GIG for traditional gig-based bookings, CUSTOMER_REQUEST for request-offer flow.';
comment on column public.bookings.service_request_id is
  'The customer service request this booking originated from (Model B only).';

create index bookings_source_idx on public.bookings (booking_source, created_at desc);
create index bookings_service_request_idx on public.bookings (service_request_id)
  where service_request_id is not null;

-- ---------------------------------------------------------------------------
-- Platform settings for the new model
-- ---------------------------------------------------------------------------
insert into public.platform_settings (key, value, description, is_public) values
  ('service_request.default_expiry_hours', '24'::jsonb,
   'How many hours an ASAP service request stays open before expiring.', false),
  ('service_request.scheduled_expiry_hours', '48'::jsonb,
   'How many hours a scheduled service request stays open before expiring.', false),
  ('service_request.max_offers', '20'::jsonb,
   'Maximum offers a single service request can receive.', false),
  ('service_request.worker_max_active_offers', '10'::jsonb,
   'Maximum number of active (SUBMITTED) offers a single worker can have.', false)
on conflict (key) do nothing;

-- ===========================================================================
-- Row-level security
-- ===========================================================================

alter table public.customer_service_requests enable row level security;
alter table public.customer_service_requests force row level security;
alter table public.service_request_offers enable row level security;
alter table public.service_request_offers force row level security;

grant select on public.customer_service_requests to authenticated;
grant select on public.service_request_offers to authenticated;

-- Customer sees own requests in every state.
create policy csr_customer_read on public.customer_service_requests
  for select to authenticated
  using (customer_id = public.current_customer_id());

-- Workers see OPEN / RECEIVING_OFFERS requests (discovery).
create policy csr_worker_discovery on public.customer_service_requests
  for select to authenticated
  using (
    status in ('OPEN', 'RECEIVING_OFFERS')
    and public.current_worker_id() is not null
  );

-- Admin sees everything.
create policy csr_admin_read on public.customer_service_requests
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- Workers see their own offers.
create policy sro_worker_read on public.service_request_offers
  for select to authenticated
  using (worker_id = public.current_worker_id());

-- Customers see offers on their own requests.
create policy sro_customer_read on public.service_request_offers
  for select to authenticated
  using (
    exists (
      select 1 from public.customer_service_requests csr
      where csr.id = service_request_id
        and csr.customer_id = public.current_customer_id()
    )
  );

-- Admin sees all offers.
create policy sro_admin_read on public.service_request_offers
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- Publish for Realtime subscriptions.
alter publication supabase_realtime add table public.customer_service_requests;
alter publication supabase_realtime add table public.service_request_offers;

-- ===========================================================================
-- RPC: customer_create_service_request
-- ===========================================================================
create or replace function public.customer_create_service_request(
  p_category_id      uuid,
  p_title            text,
  p_description      text,
  p_budget_type      public.budget_type default 'NONE',
  p_budget_min_minor bigint default null,
  p_budget_max_minor bigint default null,
  p_schedule_type    public.schedule_type default 'ASAP',
  p_scheduled_date   date default null,
  p_time_window_start time default null,
  p_time_window_end   time default null,
  p_address_line     text default null,
  p_city             text default null,
  p_state            text default null,
  p_pincode          text default null,
  p_latitude         double precision default null,
  p_longitude        double precision default null,
  p_additional_notes text default null
)
returns public.customer_service_requests
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer   public.customers%rowtype;
  v_request    public.customer_service_requests%rowtype;
  v_expiry_hrs integer;
  v_expires_at timestamptz;
  v_approx_lat double precision;
  v_approx_lng double precision;
  v_addr       text;
  v_max_active integer;
  v_active_count integer;
begin
  v_customer := public.require_current_customer();

  -- Validate category.
  if not exists (select 1 from public.services where id = p_category_id and is_active) then
    raise exception 'NOT_FOUND: that service category does not exist'
      using errcode = 'P0002';
  end if;

  -- Validate title and description.
  if length(btrim(coalesce(p_title, ''))) < 6 then
    raise exception 'INVALID: give your request a descriptive title (at least 6 characters)'
      using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_description, ''))) < 10 then
    raise exception 'INVALID: describe what you need done in more detail (at least 10 characters)'
      using errcode = '23514';
  end if;

  -- Resolve address: use provided or fall back to customer default.
  v_addr := nullif(btrim(coalesce(p_address_line, '')), '');
  if v_addr is null then
    v_addr := v_customer.address_line;
  end if;
  if v_addr is null or length(btrim(v_addr)) < 5 then
    raise exception 'INVALID: provide the service address'
      using errcode = '23514';
  end if;

  -- Limit active requests per customer (prevent spam).
  v_max_active := coalesce(
    (select value::integer from public.platform_settings
     where key = 'service_request.max_active_per_customer'), 10);

  select count(*) into v_active_count
  from public.customer_service_requests
  where customer_id = v_customer.id
    and status in ('OPEN', 'RECEIVING_OFFERS', 'WORKER_SELECTED');

  if v_active_count >= v_max_active then
    raise exception 'INVALID: you already have % active service requests. Complete or cancel one before posting a new one.', v_active_count
      using errcode = '23514';
  end if;

  -- Compute approximate location (±500 m noise for privacy).
  if p_latitude is not null and p_longitude is not null then
    v_approx_lat := round((p_latitude + (random() - 0.5) * 0.01)::numeric, 4);
    v_approx_lng := round((p_longitude + (random() - 0.5) * 0.01)::numeric, 4);
  end if;

  -- Compute expiration.
  if p_schedule_type = 'ASAP' then
    v_expiry_hrs := coalesce(
      (select value::integer from public.platform_settings
       where key = 'service_request.default_expiry_hours'), 24);
  else
    v_expiry_hrs := coalesce(
      (select value::integer from public.platform_settings
       where key = 'service_request.scheduled_expiry_hours'), 48);
  end if;
  v_expires_at := now() + make_interval(hours => v_expiry_hrs);

  insert into public.customer_service_requests (
    request_code,
    customer_id,
    category_id,
    title,
    description,
    budget_type,
    budget_min_minor,
    budget_max_minor,
    currency,
    schedule_type,
    scheduled_date,
    time_window_start,
    time_window_end,
    address_line,
    city,
    state,
    pincode,
    latitude,
    longitude,
    approx_latitude,
    approx_longitude,
    status,
    expires_at,
    additional_notes
  )
  values (
    '',  -- trigger will assign
    v_customer.id,
    p_category_id,
    btrim(p_title),
    btrim(p_description),
    p_budget_type,
    p_budget_min_minor,
    case p_budget_type
      when 'FIXED' then p_budget_min_minor  -- FIXED: max = min
      else p_budget_max_minor
    end,
    'INR',
    p_schedule_type,
    p_scheduled_date,
    p_time_window_start,
    p_time_window_end,
    btrim(v_addr),
    coalesce(p_city, v_customer.city),
    coalesce(p_state, v_customer.state),
    coalesce(p_pincode, v_customer.pincode),
    p_latitude,
    p_longitude,
    v_approx_lat,
    v_approx_lng,
    'OPEN',
    v_expires_at,
    nullif(btrim(coalesce(p_additional_notes, '')), '')
  )
  returning * into v_request;

  return v_request;
end;
$$;

grant execute on function public.customer_create_service_request(
  uuid, text, text, public.budget_type, bigint, bigint,
  public.schedule_type, date, time, time,
  text, text, text, text, double precision, double precision, text
) to authenticated;

-- ===========================================================================
-- RPC: customer_cancel_service_request
-- ===========================================================================
create or replace function public.customer_cancel_service_request(
  p_request_id uuid
)
returns public.customer_service_requests
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_request  public.customer_service_requests%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_request
  from public.customer_service_requests
  where id = p_request_id
  for update;

  if not found or v_request.customer_id <> v_customer.id then
    raise exception 'NOT_FOUND: that service request is not yours'
      using errcode = 'P0002';
  end if;

  if v_request.status in ('BOOKED', 'CANCELLED', 'EXPIRED', 'CLOSED') then
    raise exception 'INVALID: this request cannot be cancelled in its current state (%)', v_request.status
      using errcode = '23514';
  end if;

  -- Close all pending offers.
  update public.service_request_offers
  set status = 'CLOSED', updated_at = now()
  where service_request_id = p_request_id
    and status in ('SUBMITTED', 'VIEWED', 'SHORTLISTED');

  update public.customer_service_requests
  set status = 'CANCELLED', updated_at = now()
  where id = p_request_id
  returning * into v_request;

  return v_request;
end;
$$;

grant execute on function public.customer_cancel_service_request(uuid) to authenticated;

-- ===========================================================================
-- RPC: customer_accept_offer
-- ---------------------------------------------------------------------------
-- Atomic: accept one offer, close all others, create a booking with
-- booking_source = 'CUSTOMER_REQUEST'.
-- ===========================================================================
create or replace function public.customer_accept_offer(
  p_offer_id uuid
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer  public.customers%rowtype;
  v_offer     public.service_request_offers%rowtype;
  v_request   public.customer_service_requests%rowtype;
  v_gig       public.worker_gigs%rowtype;
  v_worker    public.workers%rowtype;
  v_service   public.services%rowtype;
  v_booking   public.bookings%rowtype;
  v_code      text;
  v_arrival_code text;
begin
  v_customer := public.require_current_customer();

  -- Lock the offer row.
  select * into v_offer
  from public.service_request_offers
  where id = p_offer_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that offer does not exist'
      using errcode = 'P0002';
  end if;

  if v_offer.status <> 'SUBMITTED' and v_offer.status <> 'VIEWED'
     and v_offer.status <> 'SHORTLISTED' then
    raise exception 'INVALID: this offer can no longer be accepted (status: %)', v_offer.status
      using errcode = '23514';
  end if;

  -- Lock the request row.
  select * into v_request
  from public.customer_service_requests
  where id = v_offer.service_request_id
  for update;

  if not found or v_request.customer_id <> v_customer.id then
    raise exception 'FORBIDDEN: that service request is not yours'
      using errcode = '42501';
  end if;

  if v_request.status not in ('OPEN', 'RECEIVING_OFFERS') then
    raise exception 'INVALID: this request is no longer accepting offers (status: %)', v_request.status
      using errcode = '23514';
  end if;

  -- Validate the worker is still eligible.
  select * into v_worker
  from public.workers
  where id = v_offer.worker_id;

  if not found or v_worker.status <> 'ACTIVE' then
    raise exception 'INVALID: that professional is no longer available'
      using errcode = '23514';
  end if;

  -- Load service.
  select * into v_service
  from public.services
  where id = v_request.category_id;

  -- Optionally load gig if the offer references one.
  if v_offer.gig_id is not null then
    select * into v_gig
    from public.worker_gigs
    where id = v_offer.gig_id;
  end if;

  -- Mark this offer as ACCEPTED.
  update public.service_request_offers
  set status = 'ACCEPTED', updated_at = now()
  where id = p_offer_id;

  -- Close all other offers on this request.
  update public.service_request_offers
  set status = 'CLOSED', updated_at = now()
  where service_request_id = v_request.id
    and id <> p_offer_id
    and status in ('SUBMITTED', 'VIEWED', 'SHORTLISTED');

  -- Update the request.
  update public.customer_service_requests
  set status = 'WORKER_SELECTED',
      selected_offer_id = p_offer_id,
      selected_worker_id = v_offer.worker_id,
      updated_at = now()
  where id = v_request.id;

  -- Generate booking code and arrival code.
  v_code := 'BKG-' || to_char(now(), 'YY') || '-' ||
            upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  v_arrival_code := lpad((floor(random() * 1000000))::text, 6, '0');

  -- Create the booking — unified system, different source.
  insert into public.bookings (
    booking_code,
    customer_id,
    worker_id,
    service_id,
    status,
    booking_source,
    service_request_id,
    offer_id,
    gig_id,
    problem_description,
    quoted_amount_minor,
    currency,
    address_line,
    city,
    state,
    pincode,
    latitude,
    longitude,
    scheduled_at,
    customer_notes,
    arrival_code
  )
  values (
    v_code,
    v_customer.id,
    v_offer.worker_id,
    v_request.category_id,
    'ACCEPTED',  -- worker already volunteered; skip REQUESTED
    'CUSTOMER_REQUEST',
    v_request.id,
    p_offer_id,
    v_offer.gig_id,
    v_request.title || ': ' || v_request.description,
    v_offer.proposed_price_minor,
    'INR',
    v_request.address_line,
    v_request.city,
    v_request.state,
    v_request.pincode,
    v_request.latitude,
    v_request.longitude,
    case v_request.schedule_type
      when 'SPECIFIC_DATE' then
        (v_request.scheduled_date + coalesce(v_request.time_window_start, '09:00'::time))::timestamptz
      when 'TODAY' then
        (current_date + coalesce(v_request.time_window_start, '09:00'::time))::timestamptz
      when 'TOMORROW' then
        ((current_date + 1) + coalesce(v_request.time_window_start, '09:00'::time))::timestamptz
      else null  -- ASAP
    end,
    v_request.additional_notes,
    v_arrival_code
  )
  returning * into v_booking;

  -- Transition request to BOOKED.
  update public.customer_service_requests
  set status = 'BOOKED', updated_at = now()
  where id = v_request.id;

  -- Record booking events.
  insert into public.booking_events
    (booking_id, event_type, from_status, to_status, actor_type, actor_id, metadata)
  values
    (v_booking.id, 'OFFER_ACCEPTED', null, 'ACCEPTED', 'CUSTOMER', v_customer.id,
     jsonb_build_object(
       'offer_id',           p_offer_id,
       'service_request_id', v_request.id,
       'request_code',       v_request.request_code,
       'proposed_price',     v_offer.proposed_price_minor,
       'booking_source',     'CUSTOMER_REQUEST',
       'worker_name',        v_worker.full_name
     ));

  return v_booking;
end;
$$;

grant execute on function public.customer_accept_offer(uuid) to authenticated;

-- ===========================================================================
-- RPC: customer_reject_offer
-- ===========================================================================
create or replace function public.customer_reject_offer(
  p_offer_id uuid
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_offer    public.service_request_offers%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_offer
  from public.service_request_offers
  where id = p_offer_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that offer does not exist'
      using errcode = 'P0002';
  end if;

  -- Verify the customer owns the request.
  if not exists (
    select 1 from public.customer_service_requests
    where id = v_offer.service_request_id
      and customer_id = v_customer.id
  ) then
    raise exception 'FORBIDDEN: that is not your service request'
      using errcode = '42501';
  end if;

  if v_offer.status not in ('SUBMITTED', 'VIEWED', 'SHORTLISTED') then
    raise exception 'INVALID: this offer cannot be rejected in its current state'
      using errcode = '23514';
  end if;

  update public.service_request_offers
  set status = 'REJECTED', updated_at = now()
  where id = p_offer_id;
end;
$$;

grant execute on function public.customer_reject_offer(uuid) to authenticated;

-- ===========================================================================
-- RPC: worker_find_eligible_requests
-- ---------------------------------------------------------------------------
-- Returns service requests near the worker, filtered by matching skills.
-- Exact customer location is never exposed — only approx_lat/lng.
-- ===========================================================================
create or replace function public.worker_find_eligible_requests(
  p_latitude    double precision default null,
  p_longitude   double precision default null,
  p_radius_km   numeric default 25,
  p_category_id uuid default null,
  p_sort_by     text default 'newest',
  p_limit       integer default 50,
  p_offset      integer default 0
)
returns setof jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_lat     double precision;
  v_lng     double precision;
  v_max_km  numeric;
begin
  v_worker := public.require_current_worker();

  -- Use provided location or fall back to worker's registered location.
  v_lat := coalesce(p_latitude, v_worker.latitude);
  v_lng := coalesce(p_longitude, v_worker.longitude);

  if v_lat is null or v_lng is null then
    raise exception 'INVALID: location is required to find nearby requests'
      using errcode = '23514';
  end if;

  v_max_km := least(greatest(coalesce(p_radius_km, 25), 1), 50);

  return query
  select jsonb_build_object(
    'id',               r.id,
    'request_code',     r.request_code,
    'category_id',      r.category_id,
    'category_name',    s.name,
    'title',            r.title,
    'description',      r.description,
    'budget_type',      r.budget_type,
    'budget_min_minor', r.budget_min_minor,
    'budget_max_minor', r.budget_max_minor,
    'currency',         r.currency,
    'schedule_type',    r.schedule_type,
    'scheduled_date',   r.scheduled_date,
    'time_window_start', r.time_window_start,
    'time_window_end',  r.time_window_end,
    -- Privacy: approximate location only
    'approx_latitude',  r.approx_latitude,
    'approx_longitude', r.approx_longitude,
    'city',             r.city,
    'status',           r.status,
    'offer_count',      r.offer_count,
    'max_offers',       r.max_offers,
    'expires_at',       r.expires_at,
    'created_at',       r.created_at,
    -- Distance from worker to approx location
    'distance_km',
      round((earth_distance(
        ll_to_earth(v_lat, v_lng),
        ll_to_earth(r.approx_latitude, r.approx_longitude)
      ) / 1000.0)::numeric, 1),
    -- Eligibility flags
    'has_matching_gig',
      exists (
        select 1 from public.worker_gigs wg
        where wg.worker_id = v_worker.id
          and wg.service_id = r.category_id
          and wg.status = 'ACTIVE'
      ),
    'already_offered',
      exists (
        select 1 from public.service_request_offers o
        where o.service_request_id = r.id
          and o.worker_id = v_worker.id
          and o.status not in ('WITHDRAWN', 'EXPIRED', 'CLOSED', 'REJECTED')
      )
  )
  from public.customer_service_requests r
  join public.services s on s.id = r.category_id
  where r.status in ('OPEN', 'RECEIVING_OFFERS')
    and r.approx_latitude is not null
    and r.approx_longitude is not null
    -- Not expired.
    and (r.expires_at is null or r.expires_at > now())
    -- Not full on offers.
    and r.offer_count < r.max_offers
    -- Category filter (optional).
    and (p_category_id is null or r.category_id = p_category_id)
    -- Geospatial: within search radius.
    and earth_box(ll_to_earth(v_lat, v_lng), v_max_km * 1000)
        @> ll_to_earth(r.approx_latitude, r.approx_longitude)
    and (earth_distance(
           ll_to_earth(v_lat, v_lng),
           ll_to_earth(r.approx_latitude, r.approx_longitude)
         ) / 1000.0) <= v_max_km
    -- Worker has a skill match (approved service or primary).
    and (
      r.category_id = v_worker.primary_service_id
      or exists (
        select 1 from public.worker_services ws
        where ws.worker_id = v_worker.id
          and ws.service_id = r.category_id
          and ws.is_approved
      )
    )
  order by
    case p_sort_by
      when 'nearest' then earth_distance(
        ll_to_earth(v_lat, v_lng),
        ll_to_earth(r.approx_latitude, r.approx_longitude)
      )
      when 'highest_budget' then -(coalesce(r.budget_max_minor, r.budget_min_minor, 0))::double precision
      else extract(epoch from now() - r.created_at)  -- 'newest' default
    end
  limit least(coalesce(p_limit, 50), 100)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

grant execute on function public.worker_find_eligible_requests(
  double precision, double precision, numeric, uuid, text, integer, integer
) to authenticated;

-- ===========================================================================
-- RPC: worker_submit_offer
-- ===========================================================================
create or replace function public.worker_submit_offer(
  p_service_request_id uuid,
  p_proposed_price_minor bigint,
  p_gig_id               uuid default null,
  p_message              text default null,
  p_estimated_duration   integer default null,
  p_availability_date    date default null,
  p_availability_start   time default null,
  p_availability_end     time default null
)
returns public.service_request_offers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker     public.workers%rowtype;
  v_request    public.customer_service_requests%rowtype;
  v_offer      public.service_request_offers%rowtype;
  v_max_offers integer;
  v_active     integer;
begin
  v_worker := public.require_current_worker();

  if v_worker.status <> 'ACTIVE' then
    raise exception 'FORBIDDEN: your account cannot submit offers at the moment'
      using errcode = '42501';
  end if;

  -- Validate the request.
  select * into v_request
  from public.customer_service_requests
  where id = p_service_request_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that service request does not exist'
      using errcode = 'P0002';
  end if;

  if v_request.status not in ('OPEN', 'RECEIVING_OFFERS') then
    raise exception 'INVALID: this request is no longer accepting offers'
      using errcode = '23514';
  end if;

  if v_request.expires_at is not null and v_request.expires_at <= now() then
    raise exception 'INVALID: this request has expired'
      using errcode = '23514';
  end if;

  if v_request.offer_count >= v_request.max_offers then
    raise exception 'INVALID: this request has reached its maximum number of offers'
      using errcode = '23514';
  end if;

  -- Check skill match.
  if v_request.category_id <> v_worker.primary_service_id
     and not exists (
       select 1 from public.worker_services ws
       where ws.worker_id = v_worker.id
         and ws.service_id = v_request.category_id
         and ws.is_approved
     ) then
    raise exception 'FORBIDDEN: you are not approved for this service category'
      using errcode = '42501';
  end if;

  -- Validate gig if provided.
  if p_gig_id is not null then
    if not exists (
      select 1 from public.worker_gigs
      where id = p_gig_id
        and worker_id = v_worker.id
        and service_id = v_request.category_id
        and status = 'ACTIVE'
    ) then
      raise exception 'INVALID: that gig does not match this service category or is not active'
        using errcode = '23514';
    end if;
  end if;

  -- Check worker's active offer limit.
  v_max_offers := coalesce(
    (select value::integer from public.platform_settings
     where key = 'service_request.worker_max_active_offers'), 10);

  select count(*) into v_active
  from public.service_request_offers
  where worker_id = v_worker.id
    and status in ('SUBMITTED', 'VIEWED', 'SHORTLISTED');

  if v_active >= v_max_offers then
    raise exception 'INVALID: you have reached your limit of % active offers. Wait for responses or withdraw existing offers.', v_max_offers
      using errcode = '23514';
  end if;

  -- Validate price.
  if p_proposed_price_minor is null or p_proposed_price_minor <= 0 then
    raise exception 'INVALID: propose a price for your service'
      using errcode = '23514';
  end if;

  -- Check for existing offer (the unique constraint will catch it, but a
  -- friendlier message is better).
  if exists (
    select 1 from public.service_request_offers
    where service_request_id = p_service_request_id
      and worker_id = v_worker.id
      and status not in ('WITHDRAWN', 'EXPIRED', 'CLOSED', 'REJECTED')
  ) then
    raise exception 'CONFLICT: you have already submitted an offer for this request'
      using errcode = '23505';
  end if;

  insert into public.service_request_offers (
    service_request_id,
    worker_id,
    gig_id,
    message,
    proposed_price_minor,
    currency,
    estimated_duration_minutes,
    availability_date,
    availability_start,
    availability_end,
    status
  )
  values (
    p_service_request_id,
    v_worker.id,
    p_gig_id,
    nullif(btrim(coalesce(p_message, '')), ''),
    p_proposed_price_minor,
    'INR',
    p_estimated_duration,
    p_availability_date,
    p_availability_start,
    p_availability_end,
    'SUBMITTED'
  )
  returning * into v_offer;

  return v_offer;
end;
$$;

grant execute on function public.worker_submit_offer(
  uuid, bigint, uuid, text, integer, date, time, time
) to authenticated;

-- ===========================================================================
-- RPC: worker_withdraw_offer
-- ===========================================================================
create or replace function public.worker_withdraw_offer(
  p_offer_id uuid
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
  v_offer  public.service_request_offers%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_offer
  from public.service_request_offers
  where id = p_offer_id
  for update;

  if not found or v_offer.worker_id <> v_worker.id then
    raise exception 'NOT_FOUND: that offer is not yours'
      using errcode = 'P0002';
  end if;

  if v_offer.status not in ('SUBMITTED', 'VIEWED', 'SHORTLISTED') then
    raise exception 'INVALID: this offer cannot be withdrawn (status: %)', v_offer.status
      using errcode = '23514';
  end if;

  update public.service_request_offers
  set status = 'WITHDRAWN', updated_at = now()
  where id = p_offer_id;

  -- Decrement offer count.
  update public.customer_service_requests
  set offer_count = greatest(offer_count - 1, 0),
      updated_at = now()
  where id = v_offer.service_request_id;
end;
$$;

grant execute on function public.worker_withdraw_offer(uuid) to authenticated;

-- ===========================================================================
-- RPC: worker_get_request_detail
-- ---------------------------------------------------------------------------
-- Returns full request detail (privacy-safe) for a worker.
-- ===========================================================================
create or replace function public.worker_get_request_detail(
  p_request_id uuid
)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_request public.customer_service_requests%rowtype;
  v_service public.services%rowtype;
  v_customer_name text;
  v_customer_rating numeric;
  v_my_offer_id uuid;
  v_my_offer_status text;
begin
  v_worker := public.require_current_worker();

  select * into v_request
  from public.customer_service_requests
  where id = p_request_id;

  if not found then
    raise exception 'NOT_FOUND: that service request does not exist'
      using errcode = 'P0002';
  end if;

  select * into v_service from public.services where id = v_request.category_id;

  -- Minimal customer info (no phone, no address, no exact location).
  select c.full_name, c.rating_avg
  into v_customer_name, v_customer_rating
  from public.customers c
  where c.id = v_request.customer_id;

  -- Worker's own offer on this request, if any.
  select o.id, o.status::text
  into v_my_offer_id, v_my_offer_status
  from public.service_request_offers o
  where o.service_request_id = p_request_id
    and o.worker_id = v_worker.id
  limit 1;

  return jsonb_build_object(
    'id',               v_request.id,
    'request_code',     v_request.request_code,
    'category_id',      v_request.category_id,
    'category_name',    v_service.name,
    'title',            v_request.title,
    'description',      v_request.description,
    'budget_type',      v_request.budget_type,
    'budget_min_minor', v_request.budget_min_minor,
    'budget_max_minor', v_request.budget_max_minor,
    'currency',         v_request.currency,
    'schedule_type',    v_request.schedule_type,
    'scheduled_date',   v_request.scheduled_date,
    'time_window_start', v_request.time_window_start,
    'time_window_end',  v_request.time_window_end,
    'approx_latitude',  v_request.approx_latitude,
    'approx_longitude', v_request.approx_longitude,
    'city',             v_request.city,
    'status',           v_request.status,
    'offer_count',      v_request.offer_count,
    'max_offers',       v_request.max_offers,
    'expires_at',       v_request.expires_at,
    'created_at',       v_request.created_at,
    'additional_notes', v_request.additional_notes,
    -- Privacy-safe customer info
    'customer_first_name', split_part(v_customer_name, ' ', 1),
    'customer_rating',     v_customer_rating,
    -- Worker's own offer status
    'my_offer_id',         v_my_offer_id,
    'my_offer_status',     v_my_offer_status,
    -- Eligibility
    'has_matching_gig',
      exists (
        select 1 from public.worker_gigs wg
        where wg.worker_id = v_worker.id
          and wg.service_id = v_request.category_id
          and wg.status = 'ACTIVE'
      )
  );
end;
$$;

grant execute on function public.worker_get_request_detail(uuid) to authenticated;
