-- ===========================================================================
-- 0018  Prototype: bypass KYC / background-check gates on worker eligibility
-- ===========================================================================
-- This is a deliberate, temporary relaxation for the prototype phase: identity
-- and background verification are not yet operational (no reviewer, no real
-- document pipeline), so gating "Go available" on them would make it
-- impossible for any worker to ever go live. The remaining checks — account
-- status, service area, primary trade, at least one published gig — stay in
-- place, since those are correctness requirements the app genuinely needs,
-- not security checks being deferred.
--
-- Revert this migration (or reintroduce the two `if not v_worker.is_*` blocks
-- below) before the KYC and background-check pipelines go live for real.
create or replace function public.worker_eligibility(p_worker_id uuid default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_reasons jsonb := '[]'::jsonb;
  v_gigs    integer;
begin
  select * into v_worker
  from public.workers
  where id = coalesce(p_worker_id, public.current_worker_id());

  if not found then
    raise exception 'NOT_FOUND: no such worker' using errcode = 'P0002';
  end if;

  -- A worker may only ask about themselves unless they are staff.
  if v_worker.id <> public.current_worker_id()
     and not public.admin_has_permission('workers.read') then
    raise exception 'FORBIDDEN: you may only read your own eligibility'
      using errcode = '42501';
  end if;

  if v_worker.status <> 'ACTIVE' then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'ACCOUNT_NOT_ACTIVE',
      'status', v_worker.status,
      'message', case v_worker.status
        when 'REGISTERED' then 'Finish setting up your profile to start receiving jobs.'
        when 'VERIFICATION_PENDING' then 'Your documents are being reviewed. We will let you know as soon as this is done.'
        when 'INACTIVE' then 'Your account is inactive. Contact support to reactivate it.'
        when 'RESTRICTED' then 'Your account is restricted. Contact support.'
        when 'SUSPENDED' then 'Your account is suspended. Contact support.'
        when 'REJECTED' then 'Your application was not approved. Contact support.'
        else 'Your account cannot receive jobs at the moment.'
      end);
  end if;

  -- PROTOTYPE BYPASS: is_kyc_verified / is_background_verified checks removed.

  if v_worker.latitude is null or v_worker.longitude is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'SERVICE_AREA_REQUIRED',
      'message', 'Set your service area so we know where to send you work.',
      'action', 'profile/service-area');
  end if;

  if v_worker.primary_service_id is null then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'TRADE_REQUIRED',
      'message', 'Choose your main trade.',
      'action', 'profile/trade');
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
