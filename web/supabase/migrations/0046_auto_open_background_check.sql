-- ===========================================================================
-- 0046  Background checks: opened automatically, decided by an admin
-- ---------------------------------------------------------------------------
-- The worker app tells workers "We run this ourselves" for the background
-- check, but nothing opened the case, so it showed NOT STARTED forever unless
-- an operator found the button on the worker page.
--
-- 1. When a worker's IDENTITY_KYC is approved, open their BACKGROUND_CHECK as
--    PENDING so it lands in the admin verification queue without anyone
--    having to remember to start it.
-- 2. Background checks are an admin decision. The only automated provider
--    wired up is MockKycProvider, which approves everything, so the webhook
--    that handed PENDING background checks to it is removed. IDENTITY_KYC
--    already stopped using it in 0037, so the trigger has nothing left to do.
-- 3. Backfill: workers whose identity is already approved get their check
--    opened now.
-- ===========================================================================

drop trigger if exists worker_verifications_notify_provider on public.worker_verifications;

create or replace function public.open_background_check_after_kyc()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.worker_verifications (worker_id, type, status, submitted_at)
  values (new.worker_id, 'BACKGROUND_CHECK', 'PENDING', now())
  on conflict (worker_id, type) do update
    set status       = 'PENDING',
        submitted_at = now(),
        reviewed_by  = null,
        reviewed_at  = null,
        expires_at   = null
    -- Never reopen a check that is in progress, already decided and current,
    -- or deliberately rejected; only one that was never started or lapsed.
    where public.worker_verifications.status in ('NOT_SUBMITTED', 'EXPIRED');

  return null;
end;
$$;

drop trigger if exists worker_verifications_open_background_check on public.worker_verifications;

create trigger worker_verifications_open_background_check
  after insert or update of status on public.worker_verifications
  for each row
  when (new.type = 'IDENTITY_KYC' and new.status = 'APPROVED')
  execute function public.open_background_check_after_kyc();

insert into public.worker_verifications (worker_id, type, status, submitted_at)
select kyc.worker_id, 'BACKGROUND_CHECK', 'PENDING', now()
from public.worker_verifications kyc
where kyc.type = 'IDENTITY_KYC'
  and kyc.status = 'APPROVED'
  and (kyc.expires_at is null or kyc.expires_at > now())
on conflict (worker_id, type) do update
  set status       = 'PENDING',
      submitted_at = now(),
      reviewed_by  = null,
      reviewed_at  = null,
      expires_at   = null
  where public.worker_verifications.status in ('NOT_SUBMITTED', 'EXPIRED');
