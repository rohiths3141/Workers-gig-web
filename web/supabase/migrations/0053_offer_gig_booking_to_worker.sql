-- Offer a paid gig booking to the gig's worker.
--
-- Found in device testing: a customer booked a specific worker's gig, matching
-- ran and inserted that worker as candidate #1, but the worker never saw the
-- job. Nothing anywhere set booking_match_candidates.was_offered = true, and
-- both the worker app's "New jobs" list and worker_accept_job() require it,
-- so no booking could ever be offered or accepted.
--
-- When the customer picked a gig, the offer belongs to that gig's worker: the
-- customer chose them. Customers pay upfront (0054), so the offer is made once
-- the payment is captured, not when the unpaid booking is created; offered_at
-- starts the worker's response window from that moment.
--
-- offer_paid_gig_booking() is called by confirm_payment() (0054). The trigger
-- below covers the reverse order: a candidate inserted by a later re-run of
-- matching on a booking that is already paid.

create or replace function public.gig_worker_for_booking(p_booking_id uuid)
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  -- customer_create_booking() records the chosen gig in the first event's
  -- metadata; bookings has no gig_id column.
  select g.worker_id
  from public.booking_events e
  join public.worker_gigs g on g.id = (e.metadata ->> 'gig_id')::uuid
  where e.booking_id = p_booking_id
    and e.to_status = 'REQUESTED'
    and e.metadata ? 'gig_id'
  order by e.created_at
  limit 1;
$$;

create or replace function public.booking_is_prepaid(p_booking_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1 from public.payments
    where booking_id = p_booking_id and status = 'SUCCESS'
  );
$$;

create or replace function public.offer_paid_gig_booking(p_booking_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_gig_worker uuid;
begin
  v_gig_worker := public.gig_worker_for_booking(p_booking_id);
  if v_gig_worker is null then
    return;
  end if;

  update public.booking_match_candidates c
  set was_offered = true,
      offered_at  = now()
  from public.bookings b
  where c.booking_id = p_booking_id
    and b.id = c.booking_id
    and b.status = 'REQUESTED'
    and b.worker_id is null
    and c.worker_id = v_gig_worker
    and c.was_offered = false
    and c.response is null;
end;
$$;

create or replace function public.offer_gig_booking_to_gig_worker()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if not new.was_offered
     and new.worker_id = public.gig_worker_for_booking(new.booking_id)
     and public.booking_is_prepaid(new.booking_id) then
    new.was_offered := true;
    new.offered_at := coalesce(new.offered_at, now());
  end if;
  return new;
end;
$$;

drop trigger if exists booking_match_candidates_offer_gig_worker on public.booking_match_candidates;
create trigger booking_match_candidates_offer_gig_worker
  before insert on public.booking_match_candidates
  for each row execute function public.offer_gig_booking_to_gig_worker();

revoke all on function public.gig_worker_for_booking(uuid) from public, anon, authenticated;
revoke all on function public.booking_is_prepaid(uuid) from public, anon, authenticated;
revoke all on function public.offer_paid_gig_booking(uuid) from public, anon, authenticated;
