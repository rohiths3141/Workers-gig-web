-- Gender is asked during onboarding alongside city/PIN code, and stored as a
-- plain constrained text column rather than a new enum type — it is read
-- back verbatim by the client and never branched on server-side.
alter table public.workers
  add column if not exists gender text;

alter table public.workers
  drop constraint if exists workers_gender_valid;
alter table public.workers
  add constraint workers_gender_valid
  check (gender is null or gender in ('MALE', 'FEMALE', 'OTHER'));

-- The self-update grant (migration 0009) enumerates columns explicitly; a
-- new column is write-locked by default until it is added here too.
grant update (gender) on public.workers to authenticated;
