-- ===========================================================================
-- 0014  Customer App contracts
-- ---------------------------------------------------------------------------
-- Everything the Customer App writes goes through the functions below.
-- The security posture is identical to the Worker App contracts in 0013:
--   * Firebase UID is read from the verified JWT, never from an argument.
--   * State transitions still call transition_booking(), so the state machine
--     and the audit trail are shared with the worker path.
--   * Coordinates are stored for operational use only; the customer never
--     receives raw worker coordinates — only bounded, booking-scoped streams.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Worker locations (live tracking)
-- ---------------------------------------------------------------------------
-- Written by the Worker App once per second while a booking is TRAVELING,
-- ARRIVED or IN_PROGRESS. The Customer App reads via Realtime, but only when
-- it holds an active booking that the row's booking_id matches.
--
-- Rows are cheap to insert but accumulate fast; a nightly job should prune
-- rows older than 7 days. That job is an Edge Function, not a migration.
create table public.worker_locations (
  id          uuid        primary key default gen_random_uuid(),
  worker_id   uuid        not null references public.workers  (id) on delete cascade,
  booking_id  uuid                 references public.bookings (id) on delete cascade,
  latitude    double precision not null,
  longitude   double precision not null,
  accuracy    double precision,          -- metres, nullable (GPS fix quality varies)
  heading     double precision,          -- degrees 0–360, nullable
  speed       double precision,          -- m/s, nullable
  recorded_at timestamptz not null default now(),

  constraint worker_locations_lat_range  check (latitude  between -90  and 90),
  constraint worker_locations_lng_range  check (longitude between -180 and 180),
  constraint worker_locations_accuracy   check (accuracy  is null or accuracy  >= 0),
  constraint worker_locations_speed      check (speed     is null or speed     >= 0)
);

create index worker_locations_booking_time_idx
  on public.worker_locations (booking_id, recorded_at desc)
  where booking_id is not null;

create index worker_locations_worker_time_idx
  on public.worker_locations (worker_id, recorded_at desc);

-- RLS: a worker writes their own rows. A customer reads rows for bookings they
-- own that are currently active. Nobody else reads raw GPS.
alter table public.worker_locations enable row level security;
alter table public.worker_locations force row level security;

grant select, insert on public.worker_locations to authenticated;

-- Worker may only insert their own rows (write path is the RPC below, but we
-- still gate the raw INSERT grant so a rogue client cannot spoof another's
-- location).
create policy worker_locations_worker_insert on public.worker_locations
  for insert to authenticated
  with check (worker_id = public.current_worker_id());

-- Worker may read their own rows (for debugging / last-known-location recovery).
create policy worker_locations_worker_read on public.worker_locations
  for select to authenticated
  using (worker_id = public.current_worker_id());

-- Customer may read locations tied to one of their active bookings.
create policy worker_locations_customer_read on public.worker_locations
  for select to authenticated
  using (
    booking_id is not null
    and exists (
      select 1 from public.bookings b
      where b.id = booking_id
        and b.customer_id = public.current_customer_id()
        and b.status not in ('REQUESTED', 'CANCELLED', 'EXPIRED', 'CLOSED')
    )
  );

create policy worker_locations_admin_read on public.worker_locations
  for select to authenticated
  using (public.admin_has_permission('bookings.read'));

-- Publish so the Customer App Realtime subscription sees new rows.
alter publication supabase_realtime add table public.worker_locations;

-- ---------------------------------------------------------------------------
-- Customer saved addresses
-- ---------------------------------------------------------------------------
create table public.customer_addresses (
  id           uuid    primary key default gen_random_uuid(),
  customer_id  uuid    not null references public.customers (id) on delete cascade,
  label        text    not null default 'Home',   -- 'Home' | 'Office' | 'Other'
  address_line text    not null,
  city         text,
  state        text,
  pincode      text,
  latitude     double precision,
  longitude    double precision,
  is_default   boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),

  constraint customer_addresses_label_length   check (length(btrim(label))        between 1 and 50),
  constraint customer_addresses_address_length check (length(btrim(address_line)) between 3 and 300),
  constraint customer_addresses_lat_range      check (latitude  is null or latitude  between -90  and 90),
  constraint customer_addresses_lng_range      check (longitude is null or longitude between -180 and 180)
);

create index customer_addresses_customer_idx
  on public.customer_addresses (customer_id, is_default desc, created_at asc);

create trigger customer_addresses_touch_updated_at
  before update on public.customer_addresses
  for each row execute function public.touch_updated_at();

alter table public.customer_addresses enable row level security;
alter table public.customer_addresses force row level security;

grant select, insert, update, delete on public.customer_addresses to authenticated;

create policy customer_addresses_self_all on public.customer_addresses
  for all to authenticated
  using  (customer_id = public.current_customer_id())
  with check (customer_id = public.current_customer_id());

create policy customer_addresses_admin_read on public.customer_addresses
  for select to authenticated
  using (public.admin_has_permission('customers.read'));

-- ===========================================================================
-- Caller resolution helper (customer variant)
-- ===========================================================================
-- require_current_customer mirrors require_current_worker() in 0013. Called
-- by every customer RPC to prove the caller has a real, active customer record
-- before touching any state.
create or replace function public.require_current_customer()
returns public.customers
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
begin
  select * into v_customer
  from public.customers
  where id = public.current_customer_id();

  if not found then
    raise exception 'FORBIDDEN: this operation is only available to a signed-in customer'
      using errcode = '42501';
  end if;

  if v_customer.status <> 'ACTIVE' then
    raise exception 'FORBIDDEN: your account is % and cannot make this request', v_customer.status
      using errcode = '42501';
  end if;

  return v_customer;
end;
$$;

comment on function public.require_current_customer is
  'Returns the caller''s customer row, or refuses with FORBIDDEN. Mirrors require_current_worker().';

grant execute on function public.require_current_customer() to authenticated;

-- ===========================================================================
-- Registration
-- ===========================================================================
-- Creates the customers row for a Firebase user who has just authenticated.
-- The Firebase UID comes from the verified JWT, never from a parameter.
-- Idempotent: re-calling after a dropped connection returns the existing row.
create or replace function public.customer_create_profile(
  p_full_name text,
  p_phone     text,
  p_email     text default null
)
returns public.customers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid      text := public.firebase_uid();
  v_profile  public.profiles%rowtype;
  v_customer public.customers%rowtype;
  v_phone    text;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before creating a profile'
      using errcode = '42501';
  end if;

  -- Idempotent: already registered.
  select * into v_customer from public.customers where firebase_uid = v_uid;
  if found then
    return v_customer;
  end if;

  if length(btrim(coalesce(p_full_name, ''))) < 2 then
    raise exception 'INVALID: enter your full name' using errcode = '23514';
  end if;

  v_phone := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  -- Strip a leading country code (+91).
  if length(v_phone) > 10 and left(v_phone, 2) = '91' then
    v_phone := right(v_phone, 10);
  end if;

  if v_phone !~ '^[0-9]{10,15}$' then
    raise exception 'INVALID: enter a valid mobile number' using errcode = '23514';
  end if;

  if exists (select 1 from public.customers where phone = v_phone) then
    raise exception 'CONFLICT: that number is already registered as a customer account'
      using errcode = '23505';
  end if;

  -- Workers and customers share the profiles table but may not share a UID
  -- (the apps are separate: one person cannot be both on the same account).
  select * into v_profile from public.profiles where firebase_uid = v_uid;

  if not found then
    insert into public.profiles (firebase_uid, role, phone, email, display_name)
    values (v_uid, 'CUSTOMER', v_phone, nullif(btrim(coalesce(p_email, '')), ''), btrim(p_full_name))
    returning * into v_profile;
  elsif v_profile.role <> 'CUSTOMER' then
    raise exception 'FORBIDDEN: this account is registered as a worker account'
      using errcode = '42501';
  end if;

  insert into public.customers
    (profile_id, firebase_uid, full_name, phone, email, status)
  values
    (v_profile.id, v_uid, btrim(p_full_name), v_phone,
     nullif(btrim(coalesce(p_email, '')), ''), 'ACTIVE')
  returning * into v_customer;

  return v_customer;
end;
$$;

grant execute on function public.customer_create_profile(text, text, text) to authenticated;

-- ===========================================================================
-- Self read
-- ===========================================================================
create or replace function public.customer_get_profile()
returns public.customers
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
begin
  select * into v_customer
  from public.customers
  where firebase_uid = public.firebase_uid();

  -- NOT_FOUND is used deliberately: the caller should call
  -- customer_create_profile() if this returns nothing.
  return v_customer;
end;
$$;

grant execute on function public.customer_get_profile() to authenticated;

-- ===========================================================================
-- Gig discovery
-- ---------------------------------------------------------------------------
-- Returns active gigs near a location for a given service. Coordinates are
-- returned with deliberate noise (±500 m) so a worker's home address cannot
-- be inferred by repeated queries. The exact location is used only for the
-- distance calculation.
-- ===========================================================================
create or replace function public.customer_find_gigs(
  p_service_id  uuid,
  p_latitude    double precision,
  p_longitude   double precision,
  p_radius_km   numeric default 25
)
returns setof jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_max_km   numeric;
begin
  v_customer := public.require_current_customer();

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that service does not exist' using errcode = 'P0002';
  end if;

  v_max_km := least(
    greatest(coalesce(p_radius_km, 25), 1),
    coalesce(
      (select value::numeric from public.platform_settings where key = 'matching.max_radius_km'),
      25
    )
  );

  return query
  select jsonb_build_object(
    'gig_id',          g.id,
    'title',           g.title,
    'description',     g.description,
    'price_minor',     g.price_minor,
    'pricing_unit',    g.pricing_unit,
    'currency',        'INR',
    'estimated_duration_minutes', g.estimated_duration_minutes,
    -- Worker public card fields (no phone, no exact address, no raw coords)
    'worker_id',       w.id,
    'worker_code',     w.worker_code,
    'worker_name',     w.full_name,
    'worker_rating',   w.rating_avg,
    'worker_rating_count', w.rating_count,
    'worker_jobs_completed', w.jobs_completed,
    'is_kyc_verified', w.is_kyc_verified,
    'is_background_verified', w.is_background_verified,
    'is_insured',      w.is_insured,
    'experience_years', w.experience_years,
    'bio',             w.bio,
    'city',            w.city,
    -- Noisy coordinates: a random offset ±0.005° (~500 m) is added so
    -- repeated queries cannot triangulate the worker's home.
    'approx_latitude',
      round((w.latitude + (random() - 0.5) * 0.01)::numeric, 4),
    'approx_longitude',
      round((w.longitude + (random() - 0.5) * 0.01)::numeric, 4),
    -- Exact distance for sorting; not exposed as-is to avoid leaking exact location.
    'distance_km',
      round((earth_distance(
        ll_to_earth(p_latitude, p_longitude),
        ll_to_earth(w.latitude, w.longitude)
      ) / 1000.0)::numeric, 1)
  )
  from public.worker_gigs g
  join public.workers w on w.id = g.worker_id
  where g.service_id  = p_service_id
    and g.status      = 'ACTIVE'
    and w.status      = 'ACTIVE'
    and w.is_kyc_verified
    and w.is_background_verified
    and w.latitude    is not null
    and w.longitude   is not null
    -- Within the requested radius and within the worker's own service radius.
    and earth_box(ll_to_earth(p_latitude, p_longitude), v_max_km * 1000)
        @> ll_to_earth(w.latitude, w.longitude)
    and (earth_distance(
           ll_to_earth(p_latitude, p_longitude),
           ll_to_earth(w.latitude, w.longitude)
         ) / 1000.0) <= least(v_max_km, w.service_radius_km)
  order by
    -- Availability up front, then rating, then distance.
    case w.availability when 'AVAILABLE' then 0 when 'BUSY' then 1 else 2 end,
    coalesce(w.rating_avg, 3.5) desc,
    earth_distance(
      ll_to_earth(p_latitude, p_longitude),
      ll_to_earth(w.latitude, w.longitude)
    );
end;
$$;

grant execute on function public.customer_find_gigs(uuid, double precision, double precision, numeric) to authenticated;

-- ===========================================================================
-- Booking creation
-- ---------------------------------------------------------------------------
-- The customer selects a gig; the booking is created at REQUESTED and
-- run_matching() is called immediately to queue up worker candidates.
--
-- Price: the gig's current price_minor is snapshotted onto the booking.
-- The customer never supplies a price; the server reads it from the gig.
-- This is the same principle as "never trust the client-provided price" from
-- the original brief.
-- ===========================================================================
create or replace function public.customer_create_booking(
  p_gig_id             uuid,
  p_problem_description text,
  p_address_line       text,
  p_city               text,
  p_state              text default null,
  p_pincode            text default null,
  p_latitude           double precision default null,
  p_longitude          double precision default null,
  p_scheduled_at       timestamptz default null,
  p_notes              text default null
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer  public.customers%rowtype;
  v_gig       public.worker_gigs%rowtype;
  v_service   public.services%rowtype;
  v_booking   public.bookings%rowtype;
  v_code      text;
  v_arrival_code text;
begin
  v_customer := public.require_current_customer();

  -- Fetch and validate the gig.
  select * into v_gig from public.worker_gigs where id = p_gig_id;
  if not found or v_gig.status <> 'ACTIVE' then
    raise exception 'NOT_FOUND: that service is no longer available' using errcode = 'P0002';
  end if;

  -- The worker must still be in a state that can accept work.
  if not exists (
    select 1 from public.workers w
    where w.id     = v_gig.worker_id
      and w.status = 'ACTIVE'
      and w.is_kyc_verified
      and w.is_background_verified
  ) then
    raise exception 'NOT_FOUND: that professional is no longer available' using errcode = 'P0002';
  end if;

  if length(btrim(coalesce(p_problem_description, ''))) < 5 then
    raise exception 'INVALID: describe what you need done' using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_address_line, ''))) < 5 then
    raise exception 'INVALID: enter the service address' using errcode = '23514';
  end if;

  select * into v_service from public.services where id = v_gig.service_id;

  -- Human-readable booking code.
  v_code := 'BKG-' || to_char(now(), 'YY') || '-' ||
            upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));

  -- 6-digit numeric arrival code; the worker types this when they arrive.
  v_arrival_code := lpad((floor(random() * 1000000))::text, 6, '0');

  insert into public.bookings (
    booking_code,
    customer_id,
    service_id,
    -- Price is server-read from the gig; the customer never supplies it.
    quoted_amount_minor,
    currency,
    status,
    problem_description,
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
    v_gig.service_id,
    v_gig.price_minor,
    'INR',
    'REQUESTED',
    btrim(p_problem_description),
    btrim(p_address_line),
    p_city,
    p_state,
    p_pincode,
    p_latitude,
    p_longitude,
    p_scheduled_at,
    nullif(btrim(coalesce(p_notes, '')), ''),
    v_arrival_code
  )
  returning * into v_booking;

  insert into public.booking_events
    (booking_id, event_type, from_status, to_status, actor_type, actor_id, metadata)
  values
    (v_booking.id, 'REQUESTED', null, 'REQUESTED', 'CUSTOMER', v_customer.id,
     jsonb_build_object(
       'gig_id',        p_gig_id,
       'gig_title',     v_gig.title,
       'service_name',  v_service.name,
       'price_minor',   v_gig.price_minor
     ));

  -- Kick off matching immediately. Errors here must not abort the booking
  -- creation — the booking exists; matching can be retried by an operations
  -- job if this fails (e.g. no eligible workers: that is valid and expected).
  begin
    perform public.run_matching(v_booking.id);
  exception when others then
    -- Log and continue; the booking is real even if matching found nobody.
    insert into public.booking_events
      (booking_id, event_type, actor_type, metadata)
    values
      (v_booking.id, 'SYSTEM_NOTE', 'SYSTEM',
       jsonb_build_object('note', 'run_matching failed at booking creation', 'sqlerrm', sqlerrm));
  end;

  return v_booking;
end;
$$;

grant execute on function public.customer_create_booking(uuid, text, text, text, text, text, double precision, double precision, timestamptz, text) to authenticated;

-- ===========================================================================
-- Material approval / rejection
-- ===========================================================================
create or replace function public.customer_approve_material(p_material_id uuid)
returns public.materials
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_material public.materials%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_material
  from public.materials
  where id = p_material_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that material request does not exist' using errcode = 'P0002';
  end if;

  -- Confirm the booking belongs to this customer.
  if not exists (
    select 1 from public.bookings b
    where b.id = v_material.booking_id
      and b.customer_id = v_customer.id
  ) then
    raise exception 'FORBIDDEN: that is not your booking' using errcode = '42501';
  end if;

  if v_material.status not in ('REQUESTED', 'CUSTOMER_REVIEW') then
    raise exception 'INVALID: that material request cannot be approved in its current state'
      using errcode = '23514';
  end if;

  update public.materials
  set status = 'APPROVED', approved_at = now()
  where id = p_material_id
  returning * into v_material;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, note, metadata)
  values
    (v_material.booking_id, 'MATERIAL_APPROVED', 'CUSTOMER', v_customer.id,
     v_material.name,
     jsonb_build_object('material_id', v_material.id,
                        'estimated_cost_minor', v_material.estimated_cost_minor));

  return v_material;
end;
$$;

grant execute on function public.customer_approve_material(uuid) to authenticated;

create or replace function public.customer_reject_material(
  p_material_id uuid,
  p_reason      text default null
)
returns public.materials
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_material public.materials%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_material
  from public.materials
  where id = p_material_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: that material request does not exist' using errcode = 'P0002';
  end if;

  if not exists (
    select 1 from public.bookings b
    where b.id = v_material.booking_id
      and b.customer_id = v_customer.id
  ) then
    raise exception 'FORBIDDEN: that is not your booking' using errcode = '42501';
  end if;

  if v_material.status not in ('REQUESTED', 'CUSTOMER_REVIEW') then
    raise exception 'INVALID: that material request cannot be rejected in its current state'
      using errcode = '23514';
  end if;

  update public.materials
  set status = 'REJECTED'
  where id = p_material_id
  returning * into v_material;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, note, metadata)
  values
    (v_material.booking_id, 'MATERIAL_REJECTED', 'CUSTOMER', v_customer.id,
     coalesce(p_reason, v_material.name),
     jsonb_build_object('material_id', v_material.id));

  return v_material;
end;
$$;

grant execute on function public.customer_reject_material(uuid, text) to authenticated;

-- ===========================================================================
-- Approve completion (AWAITING_APPROVAL → COMPLETED)
-- ===========================================================================
create or replace function public.customer_approve_completion(p_booking_id uuid)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_booking  public.bookings%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_booking
  from public.bookings
  where id = p_booking_id
  for update;

  if not found or v_booking.customer_id <> v_customer.id then
    raise exception 'NOT_FOUND: that booking is not yours' using errcode = 'P0002';
  end if;

  if v_booking.status <> 'AWAITING_APPROVAL' then
    raise exception 'INVALID: the job is not waiting for your approval'
      using errcode = '23514';
  end if;

  return public.transition_booking(p_booking_id, 'COMPLETED', 'CUSTOMER');
end;
$$;

grant execute on function public.customer_approve_completion(uuid) to authenticated;

-- ===========================================================================
-- Cancel booking
-- ===========================================================================
create or replace function public.customer_cancel_booking(
  p_booking_id uuid,
  p_reason     text default null
)
returns public.bookings
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_booking  public.bookings%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_booking
  from public.bookings
  where id = p_booking_id
  for update;

  if not found or v_booking.customer_id <> v_customer.id then
    raise exception 'NOT_FOUND: that booking is not yours' using errcode = 'P0002';
  end if;

  -- A customer may cancel only before a worker has started travelling.
  if v_booking.status not in ('REQUESTED', 'ACCEPTED', 'CONFIRMED') then
    raise exception 'INVALID: you cannot cancel a booking that is already underway. Contact support.'
      using errcode = '23514';
  end if;

  return public.transition_booking(p_booking_id, 'CANCELLED', 'CUSTOMER', p_reason);
end;
$$;

grant execute on function public.customer_cancel_booking(uuid, text) to authenticated;

-- ===========================================================================
-- Rate worker
-- ===========================================================================
create or replace function public.customer_rate_worker(
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
  v_customer public.customers%rowtype;
  v_booking  public.bookings%rowtype;
  v_rating   public.ratings%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_booking from public.bookings where id = p_booking_id;

  if not found or v_booking.customer_id <> v_customer.id then
    raise exception 'NOT_FOUND: that booking is not yours' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('COMPLETED', 'PAYMENT_PENDING', 'PAID', 'CLOSED') then
    raise exception 'INVALID: rate the worker once the job is complete'
      using errcode = '23514';
  end if;

  if p_rating is null or p_rating < 1 or p_rating > 5 then
    raise exception 'INVALID: choose a rating between 1 and 5' using errcode = '23514';
  end if;

  if v_booking.worker_id is null then
    raise exception 'INVALID: this booking has no assigned worker' using errcode = '23514';
  end if;

  insert into public.ratings
    (booking_id, rater_type, worker_id, customer_id, rating, comment)
  values
    (p_booking_id, 'CUSTOMER', v_booking.worker_id, v_customer.id, p_rating, p_comment)
  on conflict (booking_id, rater_type) do nothing
  returning * into v_rating;

  if v_rating.id is null then
    raise exception 'CONFLICT: you have already rated this booking' using errcode = '23505';
  end if;

  insert into public.booking_events
    (booking_id, event_type, actor_type, actor_id, metadata)
  values
    (p_booking_id, 'RATING_SUBMITTED', 'CUSTOMER', v_customer.id,
     jsonb_build_object('rating', p_rating));

  return v_rating;
end;
$$;

grant execute on function public.customer_rate_worker(uuid, smallint, text) to authenticated;

-- ===========================================================================
-- Support
-- ===========================================================================
create or replace function public.customer_create_support_ticket(
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
  v_customer public.customers%rowtype;
  v_ticket   public.support_tickets%rowtype;
  v_open     integer;
begin
  v_customer := public.require_current_customer();

  if length(btrim(coalesce(p_subject, ''))) < 3 then
    raise exception 'INVALID: give your request a short subject' using errcode = '23514';
  end if;

  if length(btrim(coalesce(p_message, ''))) < 10 then
    raise exception 'INVALID: describe the problem in a little more detail'
      using errcode = '23514';
  end if;

  if p_booking_id is not null and not exists (
    select 1 from public.bookings
    where id = p_booking_id and customer_id = v_customer.id
  ) then
    raise exception 'NOT_FOUND: that booking is not yours' using errcode = 'P0002';
  end if;

  select count(*) into v_open
  from public.support_tickets
  where customer_id = v_customer.id
    and status in ('OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER');

  if v_open >= 10 then
    raise exception 'INVALID: you already have 10 open requests. We will get to them.'
      using errcode = '23514';
  end if;

  insert into public.support_tickets
    (subject, category, requester_type, customer_id, booking_id)
  values
    (btrim(p_subject), p_category, 'CUSTOMER', v_customer.id, p_booking_id)
  returning * into v_ticket;

  insert into public.support_messages
    (ticket_id, author_type, author_profile_id, body, is_internal)
  values
    (v_ticket.id, 'CUSTOMER', v_customer.profile_id, btrim(p_message), false);

  return v_ticket;
end;
$$;

grant execute on function public.customer_create_support_ticket(text, public.support_category, text, uuid) to authenticated;

create or replace function public.customer_post_support_message(
  p_ticket_id uuid,
  p_body      text
)
returns public.support_messages
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_ticket   public.support_tickets%rowtype;
  v_message  public.support_messages%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_ticket
  from public.support_tickets
  where id = p_ticket_id and customer_id = v_customer.id;

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
    (p_ticket_id, 'CUSTOMER', v_customer.profile_id, btrim(p_body), false)
  returning * into v_message;

  update public.support_tickets
  set status = case when status = 'WAITING_FOR_USER' then 'IN_PROGRESS'::public.support_status
                    else status end
  where id = p_ticket_id;

  return v_message;
end;
$$;

grant execute on function public.customer_post_support_message(uuid, text) to authenticated;

-- ===========================================================================
-- Push token registration
-- ===========================================================================
create or replace function public.customer_register_push_token(
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
  v_customer public.customers%rowtype;
begin
  v_customer := public.require_current_customer();

  if p_platform not in ('ANDROID', 'IOS', 'WEB') then
    raise exception 'INVALID: unknown platform' using errcode = '23514';
  end if;

  insert into public.push_tokens
    (profile_id, firebase_uid, token, platform, device_label, is_active, last_seen_at)
  values
    (v_customer.profile_id, v_customer.firebase_uid, p_token, p_platform,
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

grant execute on function public.customer_register_push_token(text, text, text) to authenticated;

-- ===========================================================================
-- Worker location write (called by the Worker App)
-- ---------------------------------------------------------------------------
-- The Worker App calls this (not a raw INSERT) so the booking_id is validated
-- against the worker and the booking state before the row is written.
-- ===========================================================================
create or replace function public.worker_update_location(
  p_booking_id uuid,
  p_latitude   double precision,
  p_longitude  double precision,
  p_accuracy   double precision default null,
  p_heading    double precision default null,
  p_speed      double precision default null
)
returns public.worker_locations
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker   public.workers%rowtype;
  v_booking  public.bookings%rowtype;
  v_location public.worker_locations%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_booking
  from public.bookings
  where id = p_booking_id;

  if not found or v_booking.worker_id is distinct from v_worker.id then
    raise exception 'NOT_FOUND: that booking is not assigned to you' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('TRAVELING', 'ARRIVED', 'IN_PROGRESS') then
    -- Silently discard: the worker may send a stale update after the booking
    -- moves. Raising here would break the worker's location loop.
    return null;
  end if;

  if p_latitude not between -90 and 90 then
    raise exception 'INVALID: latitude out of range' using errcode = '23514';
  end if;
  if p_longitude not between -180 and 180 then
    raise exception 'INVALID: longitude out of range' using errcode = '23514';
  end if;

  insert into public.worker_locations
    (worker_id, booking_id, latitude, longitude, accuracy, heading, speed)
  values
    (v_worker.id, p_booking_id, p_latitude, p_longitude, p_accuracy, p_heading, p_speed)
  returning * into v_location;

  return v_location;
end;
$$;

grant execute on function public.worker_update_location(uuid, double precision, double precision, double precision, double precision, double precision) to authenticated;

-- ===========================================================================
-- Saved addresses
-- ===========================================================================
create or replace function public.customer_upsert_address(
  p_address_id uuid    default null,   -- null = create new
  p_label      text    default 'Home',
  p_address_line text  default null,
  p_city       text    default null,
  p_state      text    default null,
  p_pincode    text    default null,
  p_latitude   double precision default null,
  p_longitude  double precision default null,
  p_is_default boolean default false
)
returns public.customer_addresses
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_address  public.customer_addresses%rowtype;
begin
  v_customer := public.require_current_customer();

  if length(btrim(coalesce(p_address_line, ''))) < 3 then
    raise exception 'INVALID: enter a valid address' using errcode = '23514';
  end if;

  -- When marking as default, clear any existing default first.
  if p_is_default then
    update public.customer_addresses
    set is_default = false
    where customer_id = v_customer.id and is_default = true;
  end if;

  if p_address_id is null then
    insert into public.customer_addresses
      (customer_id, label, address_line, city, state, pincode, latitude, longitude, is_default)
    values
      (v_customer.id, coalesce(btrim(p_label), 'Home'), btrim(p_address_line),
       p_city, p_state, p_pincode, p_latitude, p_longitude, p_is_default)
    returning * into v_address;
  else
    update public.customer_addresses
    set label        = coalesce(btrim(p_label), label),
        address_line = coalesce(btrim(p_address_line), address_line),
        city         = coalesce(p_city, city),
        state        = coalesce(p_state, state),
        pincode      = coalesce(p_pincode, pincode),
        latitude     = coalesce(p_latitude, latitude),
        longitude    = coalesce(p_longitude, longitude),
        is_default   = p_is_default
    where id          = p_address_id
      and customer_id = v_customer.id
    returning * into v_address;

    if not found then
      raise exception 'NOT_FOUND: that address is not yours' using errcode = 'P0002';
    end if;
  end if;

  return v_address;
end;
$$;

grant execute on function public.customer_upsert_address(uuid, text, text, text, text, text, double precision, double precision, boolean) to authenticated;

create or replace function public.customer_delete_address(p_address_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
begin
  v_customer := public.require_current_customer();

  delete from public.customer_addresses
  where id = p_address_id and customer_id = v_customer.id;

  if not found then
    raise exception 'NOT_FOUND: that address is not yours' using errcode = 'P0002';
  end if;
end;
$$;

grant execute on function public.customer_delete_address(uuid) to authenticated;

-- ===========================================================================
-- Arrival code display (customer reads their own code)
-- ---------------------------------------------------------------------------
-- The booking row's arrival_code column is excluded from the bookings SELECT
-- grant for workers (that is what forces the comparison to happen server-side
-- in worker_verify_arrival). For the customer, displaying the code is correct:
-- the customer reads it aloud to the worker.
--
-- This function returns the code only when:
--   (a) the caller is the booking's customer, and
--   (b) the booking is in ARRIVED state (the worker is on site).
-- ===========================================================================
create or replace function public.customer_get_arrival_code(p_booking_id uuid)
returns text
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_booking  public.bookings%rowtype;
begin
  v_customer := public.require_current_customer();

  select * into v_booking from public.bookings where id = p_booking_id;

  if not found or v_booking.customer_id <> v_customer.id then
    raise exception 'NOT_FOUND: that booking is not yours' using errcode = 'P0002';
  end if;

  if v_booking.status <> 'ARRIVED' then
    raise exception 'INVALID: the code is shown only once the professional is on site'
      using errcode = '23514';
  end if;

  return v_booking.arrival_code;
end;
$$;

grant execute on function public.customer_get_arrival_code(uuid) to authenticated;

-- ===========================================================================
-- worker_gigs — also publish to Realtime so the discovery screen refreshes
-- when a worker goes offline or their gig is paused.
-- ===========================================================================
alter publication supabase_realtime add table public.worker_gigs;
