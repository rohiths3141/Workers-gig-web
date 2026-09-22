-- A worker can see the booking they were offered, and the booking remembers
-- which gig was booked.
--
-- Found in device testing, straight after the first upfront payment worked:
-- the payment was captured, the candidate row was marked was_offered, and the
-- worker app's New jobs list was still empty. The offer list embeds
-- `bookings!inner(...)`, and the only worker policy on bookings is
-- `worker_id = current_worker_id()`. Until a worker accepts, worker_id is
-- null, so the join returned nothing: an offer could be made but never seen.
--
-- bookings.gig_id (added in 0013) was never populated either -- the chosen gig
-- was only recorded in the first event's metadata -- so the worker's job card
-- could not show which of their services was booked.

-- ---------------------------------------------------------------------------
-- 1. Read access while an offer is open.
-- ---------------------------------------------------------------------------
-- Scoped to an offer the worker has not yet answered: enough to show the job
-- card and accept it, and it falls away once they decline or the offer is
-- taken. After acceptance, bookings_worker_read covers them.
drop policy if exists bookings_offered_worker_read on public.bookings;
create policy bookings_offered_worker_read on public.bookings
  for select to authenticated
  using (
    exists (
      select 1
      from public.booking_match_candidates c
      where c.booking_id = bookings.id
        and c.worker_id  = public.current_worker_id()
        and c.was_offered
        and c.response is null
    )
  );

-- ---------------------------------------------------------------------------
-- 2. Record the booked gig on the booking itself.
-- ---------------------------------------------------------------------------
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
    gig_id,
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
    p_gig_id,
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

-- Bookings created before this migration only have the gig in their first
-- event's metadata.
update public.bookings b
set gig_id = (
  select (e.metadata ->> 'gig_id')::uuid
  from public.booking_events e
  where e.booking_id = b.id
    and e.to_status = 'REQUESTED'
    and e.metadata ? 'gig_id'
  order by e.created_at
  limit 1)
where b.gig_id is null;

-- ---------------------------------------------------------------------------
-- 3. Read the gig from the column now that it is populated.
-- ---------------------------------------------------------------------------
create or replace function public.gig_worker_for_booking(p_booking_id uuid)
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce(
    (select g.worker_id
     from public.bookings b
     join public.worker_gigs g on g.id = b.gig_id
     where b.id = p_booking_id),
    -- Fallback for any row whose gig was never recorded on the booking.
    (select g.worker_id
     from public.booking_events e
     join public.worker_gigs g on g.id = (e.metadata ->> 'gig_id')::uuid
     where e.booking_id = p_booking_id
       and e.to_status = 'REQUESTED'
       and e.metadata ? 'gig_id'
     order by e.created_at
     limit 1));
$$;

revoke all on function public.gig_worker_for_booking(uuid) from public, anon, authenticated;
