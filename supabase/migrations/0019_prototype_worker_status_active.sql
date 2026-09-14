-- ===========================================================================
-- 0019  Prototype: bypass worker account-status gate on eligibility
--       + auto-activate new workers during prototype phase
-- ===========================================================================
-- Context: migration 0018 removed the KYC / background-check gates from
-- worker_eligibility() so the prototype can be tested end-to-end without a
-- real verification pipeline.  However it left the `status <> 'ACTIVE'` gate
-- intact.  Because worker_create_profile() always inserts status='REGISTERED',
-- and the only path to ACTIVE is the admin decide_verification() RPC, no
-- worker created via the mobile app can ever reach ACTIVE through client-side
-- actions alone — making "Go available" permanently blocked.
--
-- This migration makes two complementary prototype-only changes:
--   1. worker_eligibility()  — remove the account-status gate so REGISTERED
--      and VERIFICATION_PENDING workers are not blocked by it.
--   2. worker_create_profile() — insert new workers with status='ACTIVE' so
--      they are immediately match-eligible after onboarding.
--
-- ALSO: back-fills the existing test worker (phone 9797979797) to ACTIVE so
-- re-registration is not required this session.
--
-- Revert both function overrides and the default status change when the real
-- verification pipeline goes live.  The approach mirrors 0018's comments.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1. worker_eligibility — drop the account-status gate
-- ---------------------------------------------------------------------------
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

  -- PROTOTYPE BYPASS: account status gate removed (was: status <> 'ACTIVE').
  -- PROTOTYPE BYPASS: is_kyc_verified / is_background_verified checks removed.
  -- Reinstate both before production launch.

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

-- ---------------------------------------------------------------------------
-- 2. worker_create_profile — insert new workers as ACTIVE for prototype
-- ---------------------------------------------------------------------------
create or replace function public.worker_create_profile(
  p_full_name text,
  p_phone     text,
  p_email     text default null
)
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid     text := public.firebase_uid();
  v_profile public.profiles%rowtype;
  v_worker  public.workers%rowtype;
  v_phone   text;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before creating a profile'
      using errcode = '42501';
  end if;

  -- Already registered: return what exists rather than failing, so a retry
  -- after a dropped connection is harmless.
  select * into v_worker from public.workers where firebase_uid = v_uid;
  if found then
    return v_worker;
  end if;

  if length(btrim(coalesce(p_full_name, ''))) < 2 then
    raise exception 'INVALID: enter your full name' using errcode = '23514';
  end if;

  v_phone := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  -- Accept a leading country code and store the national number.
  if length(v_phone) > 10 and left(v_phone, 2) = '91' then
    v_phone := right(v_phone, 10);
  end if;

  if v_phone !~ '^[0-9]{10,15}$' then
    raise exception 'INVALID: enter a valid mobile number' using errcode = '23514';
  end if;

  if exists (select 1 from public.workers where phone = v_phone) then
    raise exception 'CONFLICT: that number is already registered'
      using errcode = '23505';
  end if;

  -- A Firebase user may already have a profile row from another surface.
  select * into v_profile from public.profiles where firebase_uid = v_uid;

  if not found then
    insert into public.profiles (firebase_uid, role, phone, email, display_name)
    values (v_uid, 'WORKER', v_phone, nullif(btrim(p_email), ''), btrim(p_full_name))
    returning * into v_profile;
  elsif v_profile.role <> 'WORKER' then
    raise exception 'FORBIDDEN: this number is registered as a customer account'
      using errcode = '42501';
  end if;

  -- PROTOTYPE BYPASS: insert as 'ACTIVE' rather than 'REGISTERED' so the
  -- worker is immediately eligible after completing onboarding without needing
  -- an admin to run decide_verification().  Revert to 'REGISTERED' when the
  -- real verification pipeline is operational.
  insert into public.workers
    (profile_id, firebase_uid, full_name, phone, email, status)
  values
    (v_profile.id, v_uid, btrim(p_full_name), v_phone,
     nullif(btrim(p_email), ''), 'ACTIVE')
  returning * into v_worker;

  return v_worker;
end;
$$;

grant execute on function public.worker_create_profile(text, text, text) to authenticated;

-- ---------------------------------------------------------------------------
-- 3. Back-fill existing test worker to ACTIVE
-- ---------------------------------------------------------------------------
-- Avoids forcing a re-registration for the test account (9797979797) that was
-- created in a previous session with the old 'REGISTERED' default.
update public.workers
set status = 'ACTIVE'
where phone = '9797979797'
  and status in ('REGISTERED', 'VERIFICATION_PENDING');
