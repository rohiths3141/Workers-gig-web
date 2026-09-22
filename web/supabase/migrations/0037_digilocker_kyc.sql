-- ===========================================================================
-- 0037  Real identity KYC via MessageCentral DigiLocker e-KYC
-- ===========================================================================
-- Identity verification (IDENTITY_KYC) now happens through a DigiLocker
-- consent flow (MessageCentral's ekyc product), not a photographed document:
-- the worker opens a government DigiLocker consent screen, and the result
-- (name / DOB / Aadhaar existence) comes back from MessageCentral itself.
-- There is nothing for the worker to upload, so the "a completed document
-- must exist" gate in worker_submit_verification() must not apply to
-- IDENTITY_KYC any more. It still applies to every other document-backed
-- type (qualifications, insurance, address).
--
-- The actual DigiLocker orchestration (init / poll status / fetch document /
-- decide) lives in the Edge Function supabase/functions/kyc-digilocker,
-- which is the only caller of record_provider_kyc_result() (added in 0036)
-- for this type. The generic mock webhook from 0036 now only fires for
-- BACKGROUND_CHECK, since MessageCentral does not perform background checks.
-- ===========================================================================

create or replace function public.worker_submit_verification(
  p_type    public.verification_type,
  p_details jsonb default '{}'::jsonb
)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker       public.workers%rowtype;
  v_verification public.worker_verifications%rowtype;
begin
  v_worker := public.require_current_worker();

  select * into v_verification
  from public.worker_verifications
  where worker_id = v_worker.id and type = p_type
  for update;

  if found and v_verification.status in ('PENDING', 'UNDER_REVIEW') then
    raise exception 'CONFLICT: this is already with our team for review'
      using errcode = '23505';
  end if;

  if found and v_verification.status = 'APPROVED'
     and (v_verification.expires_at is null or v_verification.expires_at > now()) then
    raise exception 'CONFLICT: this is already verified' using errcode = '23505';
  end if;

  -- At least one completed document must back the submission, except for the
  -- checks the platform performs itself rather than asking the worker for
  -- paper: BACKGROUND_CHECK and RPL_SKILL always did; IDENTITY_KYC now goes
  -- through the DigiLocker consent flow instead of a photographed document.
  if p_type not in ('BACKGROUND_CHECK', 'RPL_SKILL', 'IDENTITY_KYC') then
    if not exists (
      select 1 from public.media_assets
      where worker_id = v_worker.id
        and upload_status = 'COMPLETED'
        and deleted_at is null
        and purpose = case p_type
          when 'ADDRESS'         then 'WORKER_KYC_DOCUMENT'::public.media_purpose
          when 'ITI_CERTIFICATE' then 'WORKER_QUALIFICATION'::public.media_purpose
          when 'DIPLOMA'         then 'WORKER_QUALIFICATION'::public.media_purpose
          when 'INSURANCE'       then 'WORKER_INSURANCE_DOCUMENT'::public.media_purpose
          else 'WORKER_QUALIFICATION'::public.media_purpose
        end
        and created_at > now() - interval '7 days'
    ) then
      raise exception 'INVALID: upload the required document before submitting'
        using errcode = '23514';
    end if;
  end if;

  insert into public.worker_verifications
    (worker_id, type, status, details, submitted_at)
  values
    (v_worker.id, p_type, 'PENDING', coalesce(p_details, '{}'::jsonb), now())
  on conflict (worker_id, type) do update
    set status           = 'PENDING',
        details          = coalesce(excluded.details, '{}'::jsonb),
        submitted_at     = now(),
        reviewed_by      = null,
        reviewed_at      = null,
        provider         = null,
        provider_reference = null,
        decision_note    = null,
        rejection_reason = null,
        info_requested   = null
  returning * into v_verification;

  update public.workers
  set status = 'VERIFICATION_PENDING'
  where id = v_worker.id and status = 'REGISTERED';

  return v_verification;
end;
$$;

-- IDENTITY_KYC is now decided exclusively through the DigiLocker flow
-- (supabase/functions/kyc-digilocker), driven directly by the app after
-- worker_submit_verification, not by the generic PENDING webhook.
drop trigger if exists worker_verifications_notify_provider on public.worker_verifications;

create trigger worker_verifications_notify_provider
  after insert or update of status on public.worker_verifications
  for each row
  when (new.status = 'PENDING' and new.type = 'BACKGROUND_CHECK')
  execute function public.trigger_kyc_provider_webhook();
