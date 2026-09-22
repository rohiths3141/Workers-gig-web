-- Live job offers for the worker app.
--
-- The worker app subscribes to booking_match_candidates so a new offer appears
-- without the worker pulling to refresh. The table was never added to the
-- supabase_realtime publication, so every subscription failed and the New jobs
-- tab showed "Something went wrong at our end" after the retry. Same omission
-- as wallets in 0052.

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'booking_match_candidates'
  ) then
    alter publication supabase_realtime add table public.booking_match_candidates;
  end if;
end $$;
