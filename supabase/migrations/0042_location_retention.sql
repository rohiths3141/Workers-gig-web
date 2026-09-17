-- ===========================================================================
-- 0042  Retention for worker_locations
-- ---------------------------------------------------------------------------
-- 0014 flagged this at the time worker_locations was created: "rows are cheap
-- to insert but accumulate fast; a nightly job should prune rows older than 7
-- days. That job is an Edge Function, not a migration." No such job was ever
-- built — this closes that gap with pg_cron directly, since a plain DELETE on
-- a schedule needs no HTTP round trip and nothing external to keep running.
-- ===========================================================================

create extension if not exists pg_cron with schema cron;

create or replace function public.prune_worker_locations()
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  delete from public.worker_locations
  where recorded_at < now() - interval '7 days';
end;
$$;

comment on function public.prune_worker_locations is
  'Deletes GPS history older than 7 days. worker_locations is a live-tracking feed, not an indefinite audit log — retention is bounded on purpose.';

-- Re-running this migration must not fail with "job already exists" or
-- silently create a second schedule under the same name.
do $$
begin
  perform cron.unschedule('prune-worker-locations');
exception when others then
  null;
end $$;

select cron.schedule(
  'prune-worker-locations',
  '17 3 * * *',  -- once a day, off the top of the hour
  $$select public.prune_worker_locations();$$
);
