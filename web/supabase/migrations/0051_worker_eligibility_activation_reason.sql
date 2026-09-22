-- worker_eligibility: restore the "waiting for activation" reason.
--
-- 0050 stopped emitting ACCOUNT_NOT_ACTIVE for REGISTERED and
-- VERIFICATION_PENDING because the KYC and background-check reasons already
-- explain those states. That is only true while a check is outstanding: once
-- both are approved, activation is still an admin action
-- (admin_set_worker_status), and until it happens customers cannot find the
-- worker. Device testing showed an account "Under review" with no reason
-- left in the checklist.

create or replace function public.worker_eligibility(p_worker_id uuid default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker     public.workers%rowtype;
  v_reasons    jsonb := '[]'::jsonb;
  v_gigs       integer;
  v_kyc        public.verification_status;
  v_background public.verification_status;
begin
  select * into v_worker
  from public.workers
  where id = coalesce(p_worker_id, public.current_worker_id());

  if not found then
    raise exception 'NOT_FOUND: no such worker' using errcode = 'P0002';
  end if;

  if v_worker.id <> public.current_worker_id()
     and not public.admin_has_permission('workers.read') then
    raise exception 'FORBIDDEN: you may only read your own eligibility'
      using errcode = '42501';
  end if;

  select status into v_kyc
  from public.worker_verifications
  where worker_id = v_worker.id and type = 'IDENTITY_KYC';

  select status into v_background
  from public.worker_verifications
  where worker_id = v_worker.id and type = 'BACKGROUND_CHECK';

  -- REGISTERED and VERIFICATION_PENDING are explained by the specific gates
  -- below; repeating a generic line for them is what read as a contradiction.
  if v_worker.status not in ('ACTIVE', 'REGISTERED', 'VERIFICATION_PENDING') then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'ACCOUNT_NOT_ACTIVE',
      'status', v_worker.status,
      'message', case v_worker.status
        when 'INACTIVE' then 'Your account is inactive. Contact support to reactivate it.'
        when 'RESTRICTED' then 'Your account is restricted. Contact support.'
        when 'SUSPENDED' then 'Your account is suspended. Contact support.'
        when 'REJECTED' then 'Your application was not approved. Contact support.'
        else 'Your account cannot receive jobs at the moment.'
      end);
  end if;

  -- Checks approved but the account not yet activated by an admin. Without
  -- this, 0050 showed an empty checklist while customer_find_gigs (which
  -- requires workers.status = 'ACTIVE') still hid the worker from customers.
  if v_worker.status in ('REGISTERED', 'VERIFICATION_PENDING')
     and v_worker.is_kyc_verified
     and v_worker.is_background_verified then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'ACCOUNT_NOT_ACTIVE',
      'status', v_worker.status,
      'message', 'Your checks are approved. Our team will activate your account shortly.');
  end if;

  if not v_worker.is_kyc_verified then
    v_reasons := v_reasons || case
      when v_kyc in ('PENDING', 'UNDER_REVIEW') then jsonb_build_object(
        'code', 'KYC_UNDER_REVIEW',
        'message', 'Your identity check is being reviewed. We will let you know when it is done.')
      when v_kyc = 'MORE_INFO_REQUIRED' then jsonb_build_object(
        'code', 'KYC_REQUIRED',
        'message', 'Your identity check needs more information.',
        'action', 'verification/kyc')
      when v_kyc = 'REJECTED' then jsonb_build_object(
        'code', 'KYC_REQUIRED',
        'message', 'Your identity check was not approved. Try again.',
        'action', 'verification/kyc')
      else jsonb_build_object(
        'code', 'KYC_REQUIRED',
        'message', 'Complete identity verification.',
        'action', 'verification/kyc')
    end;
  end if;

  if not v_worker.is_background_verified then
    v_reasons := v_reasons || case
      when v_background in ('PENDING', 'UNDER_REVIEW') then jsonb_build_object(
        'code', 'BACKGROUND_CHECK_UNDER_REVIEW',
        'message', 'Your background check is in progress. Our team will complete it.')
      when v_background = 'REJECTED' then jsonb_build_object(
        'code', 'BACKGROUND_CHECK_REQUIRED',
        'message', 'Your background check was not cleared. Contact support.',
        'action', 'support')
      else jsonb_build_object(
        'code', 'BACKGROUND_CHECK_REQUIRED',
        'message', 'Your background check starts once your identity is verified.',
        'action', 'verification')
    end;
  end if;

  if v_worker.latitude is null or v_worker.longitude is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'SERVICE_AREA_REQUIRED',
      'message', 'Set your service area so we know where to send you work.',
      'action', 'profile/edit');
  end if;

  if v_worker.primary_service_id is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'TRADE_REQUIRED',
      'message', 'Choose your main trade.',
      'action', 'profile/edit');
  end if;

  select count(*) into v_gigs
  from public.worker_gigs
  where worker_id = v_worker.id and status = 'ACTIVE';

  if v_gigs = 0 then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'NO_ACTIVE_GIG',
      'message', 'Publish at least one service so customers can book you.',
      'action', 'gigs');
  end if;

  return jsonb_build_object(
    'worker_id', v_worker.id,
    'eligible', jsonb_array_length(v_reasons) = 0,
    'account_status', v_worker.status,
    'availability', v_worker.availability,
    'active_gig_count', v_gigs,
    'reasons', v_reasons);
end;
$$;
