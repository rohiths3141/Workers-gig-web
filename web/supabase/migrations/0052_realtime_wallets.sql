-- Publish wallets and wallet_transactions to Supabase Realtime.
--
-- The worker app subscribes to its wallet row so the balance updates when an
-- earning or payout lands. Neither table was in the supabase_realtime
-- publication, so every subscription failed ("Realtime stream error on
-- wallets" in device testing) and the balance only refreshed on reload.
-- RLS still applies to Realtime: a worker receives only their own rows.

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'wallets'
  ) then
    alter publication supabase_realtime add table public.wallets;
  end if;

  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'wallet_transactions'
  ) then
    alter publication supabase_realtime add table public.wallet_transactions;
  end if;
end $$;
