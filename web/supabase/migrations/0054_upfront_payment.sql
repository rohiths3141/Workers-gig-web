-- Upfront payment: the customer pays when booking.
--
-- The state machine (0010) was built for pay-after-work: COMPLETED ->
-- PAYMENT_PENDING -> PAID, and confirm_payment() (0011) always moved the
-- booking to PAID. The customer app takes payment right after creating the
-- booking, so in device testing a Razorpay-captured payment could never be
-- confirmed ("We could not confirm this payment"): REQUESTED -> PAID is not a
-- transition.
--
-- Money flow after this migration:
--   1. Customer books (REQUESTED, unpaid). Nobody is offered the job yet.
--   2. Payment verified -> payment SUCCESS, the booking amounts are split
--      (platform commission / worker share) and the job is offered to the
--      chosen gig's worker (0053). The money is held: no wallet credit yet.
--   3. Worker accepts -> the booking is confirmed automatically. The customer
--      already chose and paid for this worker; nothing in either app ever
--      performed the ACCEPTED -> CONFIRMED step, so work could never start.
--   4. Customer approves completion (COMPLETED) -> the worker's share is
--      credited and the booking settles COMPLETED -> PAYMENT_PENDING -> PAID
--      in the same transaction.
--   5. Cancelled or expired after payment -> a PENDING refund row is opened
--      for operations to process with the gateway.
--
-- Pay-after-work bookings (payment taken at PAYMENT_PENDING) keep the old
-- behaviour.

-- ---------------------------------------------------------------------------
-- 1. The system may confirm a booking (prepaid bookings confirm on accept).
-- ---------------------------------------------------------------------------
update public.booking_transitions
set allowed_actors = array['CUSTOMER','ADMIN','SYSTEM']::public.actor_type[]
where from_status = 'ACCEPTED' and to_status = 'CONFIRMED'
  and not ('SYSTEM' = any (allowed_actors));

-- ---------------------------------------------------------------------------
-- 2. Amount split, shared by capture and settlement.
-- ---------------------------------------------------------------------------
create or replace function public.split_payment_amounts(p_payment_id uuid)
returns public.payments
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_payment    public.payments%rowtype;
  v_percent    numeric;
  v_fee        bigint;
  v_labour     bigint;
begin
  select * into v_payment from public.payments where id = p_payment_id for update;
  if not found then
    raise exception 'NOT_FOUND: payment % does not exist', p_payment_id using errcode = 'P0002';
  end if;

  -- Already split (create-order copied amounts from a priced booking).
  if v_payment.worker_amount_minor > 0 then
    return v_payment;
  end if;

  v_percent := coalesce(
    (select (value #>> '{}')::numeric from public.platform_settings
     where key = 'platform.commission_percent'), 15);

  -- Commission applies to labour only; materials pass through to the worker.
  v_labour := v_payment.amount_minor - v_payment.material_amount_minor;
  v_fee    := round(v_labour * v_percent / 100.0)::bigint;

  update public.payments
  set platform_fee_minor  = v_fee,
      worker_amount_minor = v_payment.amount_minor - v_fee
  where id = p_payment_id
  returning * into v_payment;

  update public.bookings
  set platform_fee_minor  = v_fee,
      worker_amount_minor = v_payment.worker_amount_minor,
      final_amount_minor  = coalesce(final_amount_minor, v_payment.amount_minor)
  where id = v_payment.booking_id;

  return v_payment;
end;
$$;

-- ---------------------------------------------------------------------------
-- 3. Settlement of a prepaid booking once the work is approved.
-- ---------------------------------------------------------------------------
create or replace function public.settle_prepaid_booking(p_booking_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_booking public.bookings%rowtype;
  v_payment public.payments%rowtype;
begin
  select * into v_booking from public.bookings where id = p_booking_id for update;
  if not found or v_booking.status <> 'COMPLETED' then
    return;
  end if;

  select * into v_payment
  from public.payments
  where booking_id = p_booking_id and status = 'SUCCESS'
  order by captured_at desc nulls last
  limit 1;

  if not found then
    return;  -- Pay-after-work booking: the customer is asked to pay now.
  end if;

  v_payment := public.split_payment_amounts(v_payment.id);

  -- Same idempotency key confirm_payment() has always used, so a booking can
  -- never be credited twice whichever path settles it.
  if v_payment.worker_amount_minor > 0 and v_booking.worker_id is not null then
    perform public.post_wallet_transaction(
      v_booking.worker_id,
      'CREDIT_JOB_EARNING',
      v_payment.worker_amount_minor,
      'Earning for booking ' || v_booking.booking_code,
      'payment-earning:' || v_payment.id::text,
      'PAYMENT', v_payment.id, null, 'SYSTEM'
    );
  end if;

  perform public.transition_booking(
    p_booking_id, 'PAYMENT_PENDING', 'SYSTEM', null,
    jsonb_build_object('prepaid', true, 'payment_id', v_payment.id));
  perform public.transition_booking(
    p_booking_id, 'PAID', 'SYSTEM',
    'Settled from upfront payment ' || coalesce(v_payment.gateway_payment_id, v_payment.id::text),
    jsonb_build_object('prepaid', true, 'payment_id', v_payment.id));
end;
$$;

-- ---------------------------------------------------------------------------
-- 4. confirm_payment: hold upfront payments, settle pay-after-work ones.
-- ---------------------------------------------------------------------------
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
  v_booking public.bookings%rowtype;
begin
  if not p_signature_verified then
    raise exception 'FORBIDDEN: refusing to confirm a payment whose gateway signature was not verified'
      using errcode = '42501';
  end if;

  select * into v_payment from public.payments where id = p_payment_id for update;
  if not found then
    raise exception 'NOT_FOUND: payment % does not exist', p_payment_id using errcode = 'P0002';
  end if;

  -- Replayed webhook or retried client call: already captured.
  if v_payment.status = 'SUCCESS' then
    return v_payment;
  end if;

  select * into v_booking from public.bookings where id = v_payment.booking_id for update;

  update public.payments
  set status = 'SUCCESS',
      gateway_payment_id = p_gateway_payment_id,
      gateway_signature_verified = true,
      gateway_verified_at = now(),
      gateway_payload = p_payload,
      captured_at = now()
  where id = p_payment_id;

  v_payment := public.split_payment_amounts(p_payment_id);

  if v_booking.status = 'PAYMENT_PENDING' then
    -- Pay-after-work: credit and close out now, as before.
    if v_payment.worker_amount_minor > 0 and v_booking.worker_id is not null then
      perform public.post_wallet_transaction(
        v_booking.worker_id,
        'CREDIT_JOB_EARNING',
        v_payment.worker_amount_minor,
        'Earning for booking ' || v_booking.booking_code,
        'payment-earning:' || v_payment.id::text,
        'PAYMENT', v_payment.id, null, 'SYSTEM'
      );
    end if;

    perform public.transition_booking(
      v_booking.id, 'PAID', 'SYSTEM',
      'Gateway-verified payment ' || p_gateway_payment_id);

  elsif v_booking.status = 'REQUESTED' then
    -- Upfront: hold the money and offer the job to the chosen worker.
    perform public.offer_paid_gig_booking(v_booking.id);

  elsif v_booking.status = 'COMPLETED' then
    perform public.settle_prepaid_booking(v_booking.id);

  elsif v_booking.status in ('CANCELLED', 'EXPIRED') then
    -- Paid for a booking that ended while checkout was open.
    perform public.open_booking_refund(v_booking.id, 'Payment captured after the booking was ' || lower(v_booking.status::text));
  end if;
  -- Any other status (accepted through awaiting approval): held until settled.

  return v_payment;
end;
$$;

-- ---------------------------------------------------------------------------
-- 5. Refund request when a paid booking is cancelled or expires.
-- ---------------------------------------------------------------------------
create or replace function public.open_booking_refund(p_booking_id uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  -- One refund request per captured payment; the gateway call is made by
  -- operations from the admin panel.
  insert into public.refunds (payment_id, amount_minor, currency, reason, idempotency_key)
  select p.id, p.amount_minor - p.refunded_amount_minor, p.currency, p_reason,
         'booking-cancel-refund:' || p.id::text
  from public.payments p
  where p.booking_id = p_booking_id
    and p.status = 'SUCCESS'
    and p.amount_minor - p.refunded_amount_minor > 0
  on conflict (idempotency_key) do nothing;
end;
$$;

-- ---------------------------------------------------------------------------
-- 6. React to booking events: auto-confirm, settle, refund.
-- ---------------------------------------------------------------------------
-- An AFTER INSERT trigger on booking_events runs once the originating
-- transition has fully written its own event, so the follow-up transitions
-- appear after it in the timeline. The events those follow-ups write re-enter
-- this trigger with a status it ignores.
create or replace function public.booking_events_prepaid_flow()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.to_status is null or new.to_status is not distinct from new.from_status then
    return new;
  end if;

  if new.to_status = 'ACCEPTED' and public.booking_is_prepaid(new.booking_id) then
    perform public.transition_booking(
      new.booking_id, 'CONFIRMED', 'SYSTEM', null,
      jsonb_build_object('prepaid', true, 'note', 'Customer paid upfront for this worker'));

  elsif new.to_status = 'COMPLETED' then
    perform public.settle_prepaid_booking(new.booking_id);

  elsif new.to_status in ('CANCELLED', 'EXPIRED') then
    perform public.open_booking_refund(new.booking_id,
      case new.to_status when 'EXPIRED' then 'Booking expired before a worker accepted'
                         else 'Booking cancelled: ' || coalesce(nullif(btrim(new.note), ''), 'no reason given') end);
  end if;

  return new;
end;
$$;

drop trigger if exists booking_events_prepaid_flow on public.booking_events;
create trigger booking_events_prepaid_flow
  after insert on public.booking_events
  for each row execute function public.booking_events_prepaid_flow();

revoke all on function public.split_payment_amounts(uuid) from public, anon, authenticated;
revoke all on function public.settle_prepaid_booking(uuid) from public, anon, authenticated;
revoke all on function public.open_booking_refund(uuid, text) from public, anon, authenticated;
revoke all on function public.confirm_payment(uuid, text, boolean, jsonb) from public, anon, authenticated;
