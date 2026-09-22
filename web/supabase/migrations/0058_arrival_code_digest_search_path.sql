-- Arrival code verification could never succeed.
--
-- Found in device testing: the worker arrived, typed the customer's code and
-- got "Something went wrong at our end". worker_verify_arrival() hashes both
-- codes with digest() from pgcrypto, which Supabase installs into the
-- extensions schema, but the function pins search_path to "public, pg_temp".
-- Every call failed with 42883 "function digest(text, unknown) does not
-- exist", so no job could pass ARRIVED and work could never start.
--
-- The function is unchanged apart from its search_path.
create or replace function public.worker_verify_arrival(
  p_booking_id uuid,
  p_code       text
)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions, pg_temp
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
