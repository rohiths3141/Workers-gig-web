-- Two product decisions taken during device testing.
--
-- 1. The platform takes no commission. Workers keep everything the customer
--    pays. The split still runs so the columns stay consistent; the fee is
--    simply zero and the worker's share is the full amount.
--
-- 2. Finishing a job is never blocked by photographs. A worker who has done
--    the work must always be able to say so; the evidence sections stay in the
--    app as protection they can choose to use. Material requests the customer
--    has not answered still block completion: those are unsettled charges, not
--    evidence.

update public.platform_settings
set value = to_jsonb(0),
    description = 'Platform commission on the labour component of a completed job, in percent. Currently zero: workers keep the full amount.'
where key = 'platform.commission_percent';

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
  -- a verified arrival. Photographic evidence is offered to the worker but is
  -- not required: a worker who has finished must always be able to say so.
  if p_to_status = 'AWAITING_APPROVAL' then
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

grant execute on function public.worker_advance_booking(uuid, public.booking_status, text) to authenticated;
