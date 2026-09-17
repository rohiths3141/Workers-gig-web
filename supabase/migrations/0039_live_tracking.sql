-- ===========================================================================
-- 0039  Live GPS tracking for an active job
-- ---------------------------------------------------------------------------
-- The booking state machine (0010) already models TRAVELING/ARRIVED as
-- statuses a worker moves into via worker_advance_booking(). What is missing
-- is location capture tied to that window: a worker's GPS must never be
-- readable before TRAVELING starts and must stop being readable the moment
-- the job leaves that window, regardless of what the client does.
--
-- Two tables, deliberately kept separate:
--   live_tracking_sessions  - the authorization/lifecycle record (ACTIVE /
--                              ENDED). This is what RLS checks.
--   worker_live_locations   - the single latest point for that booking. This
--                              is overwritten in place, never appended to, so
--                              there is no unbounded GPS history table.
-- High-frequency delivery to the customer goes over Realtime Broadcast
-- (realtime.send), not by the customer polling either table.
-- ===========================================================================

create table public.live_tracking_sessions (
  id           uuid primary key default gen_random_uuid(),
  booking_id   uuid not null unique references public.bookings (id) on delete cascade,
  worker_id    uuid not null references public.workers (id) on delete cascade,
  customer_id  uuid not null references public.customers (id) on delete cascade,
  status       text not null default 'ACTIVE' check (status in ('ACTIVE', 'PAUSED', 'ENDED')),
  started_at   timestamptz not null default now(),
  ended_at     timestamptz,
  last_latitude   double precision,
  last_longitude  double precision,
  last_accuracy   double precision,
  last_heading    double precision,
  last_speed      double precision,
  last_updated_at timestamptz
);

create index live_tracking_sessions_worker_idx on public.live_tracking_sessions (worker_id);
create index live_tracking_sessions_customer_idx on public.live_tracking_sessions (customer_id);
create index live_tracking_sessions_status_idx on public.live_tracking_sessions (status) where status = 'ACTIVE';

comment on table public.live_tracking_sessions is
  'One row per booking. Existence + status is the authorization gate for both GPS ingestion and customer subscription — never derived from booking.status alone, so a stale client cannot infer access from a status it cached earlier.';

create table public.worker_live_locations (
  booking_id  uuid primary key references public.bookings (id) on delete cascade,
  worker_id   uuid not null references public.workers (id) on delete cascade,
  latitude    double precision not null,
  longitude   double precision not null,
  accuracy    double precision,
  heading     double precision,
  speed       double precision,
  updated_at  timestamptz not null default now(),
  constraint worker_live_locations_lat_range check (latitude between -90 and 90),
  constraint worker_live_locations_lng_range check (longitude between -180 and 180)
);

comment on table public.worker_live_locations is
  'Latest GPS point only, upserted in place. Not a history log — there is no retention question because nothing accumulates.';

-- ---------------------------------------------------------------------------
-- RLS: readable only by the two parties to the booking, never publicly.
-- No insert/update/delete grant to authenticated on either table — every
-- write goes through the SECURITY DEFINER functions below.
-- ---------------------------------------------------------------------------
alter table public.live_tracking_sessions enable row level security;
alter table public.live_tracking_sessions force row level security;
alter table public.worker_live_locations enable row level security;
alter table public.worker_live_locations force row level security;

grant select on public.live_tracking_sessions to authenticated;
grant select on public.worker_live_locations to authenticated;

create policy live_tracking_sessions_parties_read on public.live_tracking_sessions
  for select to authenticated
  using (
    worker_id = public.current_worker_id()
    or customer_id = public.current_customer_id()
  );

create policy worker_live_locations_parties_read on public.worker_live_locations
  for select to authenticated
  using (
    worker_id = public.current_worker_id()
    or exists (
      select 1 from public.live_tracking_sessions s
      where s.booking_id = worker_live_locations.booking_id
        and s.customer_id = public.current_customer_id()
    )
  );

-- ---------------------------------------------------------------------------
-- Session lifecycle, driven off the existing transition trigger rather than a
-- new entry point — a worker starts/ends travel exactly the way they already
-- do via worker_advance_booking(); nothing new to call for that part.
-- ---------------------------------------------------------------------------
create or replace function public.bookings_manage_tracking_session()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.status = 'TRAVELING' and old.status is distinct from 'TRAVELING' then
    insert into public.live_tracking_sessions (booking_id, worker_id, customer_id, status, started_at)
    values (new.id, new.worker_id, new.customer_id, 'ACTIVE', now())
    on conflict (booking_id) do update
      set status = 'ACTIVE', started_at = now(), ended_at = null;

  elsif new.status not in ('TRAVELING', 'ARRIVED') and old.status in ('TRAVELING', 'ARRIVED') then
    -- Covers IN_PROGRESS, COMPLETED, CANCELLED, DISPUTED and any other exit:
    -- tracking always ends the moment the job leaves the travel window.
    update public.live_tracking_sessions
    set status = 'ENDED', ended_at = now()
    where booking_id = new.id and status <> 'ENDED';

    delete from public.worker_live_locations where booking_id = new.id;
  end if;

  return new;
end;
$$;

drop trigger if exists bookings_manage_tracking_session on public.bookings;
create trigger bookings_manage_tracking_session
  after update of status on public.bookings
  for each row
  execute function public.bookings_manage_tracking_session();

-- ---------------------------------------------------------------------------
-- Location ingestion
-- ---------------------------------------------------------------------------
-- Called by the worker app roughly every few seconds / meaningful movement
-- while TRAVELING. Identity comes only from require_current_worker() — the
-- worker_id is never taken from the payload, so one worker cannot post
-- location on another worker's behalf.
create or replace function public.worker_ingest_location(
  p_booking_id uuid,
  p_latitude   double precision,
  p_longitude  double precision,
  p_accuracy   double precision default null,
  p_heading    double precision default null,
  p_speed      double precision default null
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_session public.live_tracking_sessions%rowtype;
  v_previous public.worker_live_locations%rowtype;
  v_elapsed_seconds double precision;
  v_jump_km double precision;
begin
  v_worker := public.require_current_worker();

  if p_latitude is null or p_longitude is null
     or p_latitude not between -90 and 90
     or p_longitude not between -180 and 180 then
    raise exception 'INVALID: coordinates out of range' using errcode = '23514';
  end if;

  -- Wildly inaccurate fixes are worse than none: they make the marker jump
  -- and pollute the "last known position" a stale-check depends on.
  if p_accuracy is not null and p_accuracy > 1000 then
    raise exception 'INVALID: location accuracy too low to use' using errcode = '23514';
  end if;

  select * into v_session
  from public.live_tracking_sessions
  where booking_id = p_booking_id
  for update;

  if not found or v_session.status <> 'ACTIVE' or v_session.worker_id <> v_worker.id then
    raise exception 'FORBIDDEN: no active tracking session for this booking'
      using errcode = '42501';
  end if;

  select * into v_previous
  from public.worker_live_locations
  where booking_id = p_booking_id;

  -- A soft sanity check against teleportation, not a hard physics model: a
  -- corrupt/spoofed fix is rejected, a genuinely fast vehicle is not.
  if found and v_previous.updated_at is not null then
    v_elapsed_seconds := greatest(extract(epoch from (now() - v_previous.updated_at)), 1);
    v_jump_km := earth_distance(
                   ll_to_earth(v_previous.latitude, v_previous.longitude),
                   ll_to_earth(p_latitude, p_longitude)
                 ) / 1000.0;
    if (v_jump_km / (v_elapsed_seconds / 3600.0)) > 200 then
      raise exception 'INVALID: implausible movement rejected' using errcode = '23514';
    end if;
  end if;

  insert into public.worker_live_locations
    (booking_id, worker_id, latitude, longitude, accuracy, heading, speed, updated_at)
  values
    (p_booking_id, v_worker.id, p_latitude, p_longitude, p_accuracy, p_heading, p_speed, now())
  on conflict (booking_id) do update
    set latitude = excluded.latitude,
        longitude = excluded.longitude,
        accuracy = excluded.accuracy,
        heading = excluded.heading,
        speed = excluded.speed,
        updated_at = excluded.updated_at;

  update public.live_tracking_sessions
  set last_latitude = p_latitude,
      last_longitude = p_longitude,
      last_accuracy = p_accuracy,
      last_heading = p_heading,
      last_speed = p_speed,
      last_updated_at = now()
  where booking_id = p_booking_id;

  -- Broadcast is the delivery path to the customer; the tables above are the
  -- durable "latest state", not a feed anyone subscribes to directly. A
  -- broadcast failure must never fail the ingestion write itself.
  begin
    perform realtime.send(
      jsonb_build_object(
        'booking_id', p_booking_id,
        'latitude', p_latitude,
        'longitude', p_longitude,
        'accuracy', p_accuracy,
        'heading', p_heading,
        'speed', p_speed,
        'updated_at', now()
      ),
      'location',
      'booking:' || p_booking_id || ':tracking',
      true
    );
  exception when others then
    raise warning 'live location broadcast failed for booking %: %', p_booking_id, sqlerrm;
  end;
end;
$$;

grant execute on function public.worker_ingest_location(
  uuid, double precision, double precision, double precision, double precision, double precision
) to authenticated;

-- ---------------------------------------------------------------------------
-- Realtime Broadcast authorization: private channel access is governed by
-- RLS on realtime.messages, keyed off the same booking-membership check used
-- everywhere else. Topic shape: booking:{booking_id}:tracking.
-- ---------------------------------------------------------------------------
drop policy if exists booking_tracking_channel_read on realtime.messages;
create policy booking_tracking_channel_read on realtime.messages
  for select to authenticated
  using (
    realtime.topic() like 'booking:%:tracking'
    and exists (
      select 1 from public.live_tracking_sessions s
      where s.booking_id = (split_part(realtime.topic(), ':', 2))::uuid
        and (s.worker_id = public.current_worker_id() or s.customer_id = public.current_customer_id())
    )
  );
