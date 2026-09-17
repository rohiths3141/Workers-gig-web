-- ===========================================================================
-- 0040  Revert 0039
-- ---------------------------------------------------------------------------
-- 0039 built a second, parallel live-location system (live_tracking_sessions,
-- worker_live_locations, worker_ingest_location) without first checking for
-- one that already existed. It did: public.worker_locations +
-- worker_update_location() (migration 0014), already wired end-to-end —
-- worker app streams to it via jobs_controller.dart's locationBroadcastProvider,
-- already gated server-side to TRAVELING/ARRIVED/IN_PROGRESS, already RLS-scoped,
-- already on the Realtime publication. Nothing was ever built against 0039's
-- objects, so this is a clean drop rather than a data migration.
-- ===========================================================================

drop trigger if exists bookings_manage_tracking_session on public.bookings;
drop function if exists public.bookings_manage_tracking_session();
drop function if exists public.worker_ingest_location(
  uuid, double precision, double precision, double precision, double precision, double precision
);
drop policy if exists booking_tracking_channel_read on realtime.messages;
drop table if exists public.worker_live_locations;
drop table if exists public.live_tracking_sessions;

-- The one real gap in the existing system: the customer-read policy allowed
-- reading location rows for any non-terminal-ish booking status (including
-- ACCEPTED, CONFIRMED, COMPLETED, PAID, DISPUTED), wider than the write gate
-- (TRAVELING/ARRIVED/IN_PROGRESS only). No rows normally exist outside that
-- write window, but a booking that later moves to COMPLETED/PAID left its
-- TRAVELING-era rows readable indefinitely — live location access must end
-- when the job does, not linger until the row ages out on its own.
drop policy if exists worker_locations_customer_read on public.worker_locations;
create policy worker_locations_customer_read on public.worker_locations
  for select to authenticated
  using (
    booking_id is not null
    and exists (
      select 1 from public.bookings b
      where b.id = booking_id
        and b.customer_id = public.current_customer_id()
        and b.status in ('TRAVELING', 'ARRIVED', 'IN_PROGRESS')
    )
  );
