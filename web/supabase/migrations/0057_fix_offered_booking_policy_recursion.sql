-- Break the policy recursion introduced by 0055.
--
-- 0055 let a worker read a booking they were offered by testing
-- booking_match_candidates from a policy on bookings. But the candidates table
-- has its own policy (match_candidates_customer_read) that reads bookings, so
-- evaluating either one re-entered the other: every query touching bookings
-- failed with 42P17 "infinite recursion detected in policy for relation
-- bookings", which took the worker app's whole session down.
--
-- The test moves into a security definer function, which is not subject to the
-- candidates policies, so the cycle disappears. It still answers only for the
-- calling worker.

create or replace function public.worker_has_open_offer(p_booking_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.booking_match_candidates c
    where c.booking_id = p_booking_id
      and c.worker_id  = public.current_worker_id()
      and c.was_offered
      and c.response is null
  );
$$;

comment on function public.worker_has_open_offer is
  'True when the calling worker has an unanswered offer for this booking. Used by the bookings read policy; security definer to avoid policy recursion.';

grant execute on function public.worker_has_open_offer(uuid) to authenticated;

drop policy if exists bookings_offered_worker_read on public.bookings;
create policy bookings_offered_worker_read on public.bookings
  for select to authenticated
  using (public.worker_has_open_offer(id));
