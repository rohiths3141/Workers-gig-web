-- ===========================================================================
-- 0035  Revert prototype bypasses: restore real worker verification, gig
--       review, and customer-gig-discovery security
-- ===========================================================================
-- Migrations 0018-0032 were deliberate, documented prototype shortcuts to let
-- the app be tested end-to-end before a verification pipeline existed. This
-- migration retires every one of them and restores the real rules that were
-- already designed (and, for the worker/customer RPCs, already correctly
-- implemented) back in 0013/0014:
--
--   1. worker_create_profile()  -> new workers start REGISTERED again, not
--      auto-activated.
--   2. worker_eligibility()     -> real gates restored: account status,
--      is_kyc_verified, is_background_verified, service area, primary trade,
--      at least one ACTIVE gig. (0013's version already had all of this; we
--      are simply re-applying it over 0018/0019's stripped-down override.)
--   3. gigs.require_review      -> back to true. New gigs land in
--      PENDING_REVIEW again instead of going live unreviewed.
--   4. customer_find_gigs()     -> restores the real auth guard
--      (require_current_customer(), which 0032 deleted), the real spatial
--      filter (which 0025 removed), and the real is_kyc_verified /
--      is_background_verified filter (which 0021 removed). Also revokes the
--      `anon` execute grant 0032 added -- this RPC must only ever be callable
--      by an authenticated customer.
--   5. Worker rows that had is_kyc_verified / is_background_verified forced
--      to true directly by 0021-0024 (bypassing the trigger that is supposed
--      to be the only writer) are recomputed from their real
--      worker_verifications history, so nobody is left "verified" on paper
--      alone.
--
-- What is intentionally NOT touched: the seeded test-worker coordinates,
-- worker_services / primary_service_id, and worker_gigs rows created by
-- 0020/0026-0028. Those are legitimate test data, not security bypasses, and
-- removing them would just break the existing test account for no benefit.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 1 & 2. worker_create_profile + worker_eligibility: restore 0013's version
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

  select * into v_worker from public.workers where firebase_uid = v_uid;
  if found then
    return v_worker;
  end if;

  if length(btrim(coalesce(p_full_name, ''))) < 2 then
    raise exception 'INVALID: enter your full name' using errcode = '23514';
  end if;

  v_phone := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
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

  select * into v_profile from public.profiles where firebase_uid = v_uid;

  if not found then
    insert into public.profiles (firebase_uid, role, phone, email, display_name)
    values (v_uid, 'WORKER', v_phone, nullif(btrim(p_email), ''), btrim(p_full_name))
    returning * into v_profile;
  elsif v_profile.role <> 'WORKER' then
    raise exception 'FORBIDDEN: this number is registered as a customer account'
      using errcode = '42501';
  end if;

  -- Real behaviour restored: a new worker starts REGISTERED and must go
  -- through verification before they can ever reach ACTIVE.
  insert into public.workers
    (profile_id, firebase_uid, full_name, phone, email, status)
  values
    (v_profile.id, v_uid, btrim(p_full_name), v_phone,
     nullif(btrim(p_email), ''), 'REGISTERED')
  returning * into v_worker;

  return v_worker;
end;
$$;

grant execute on function public.worker_create_profile(text, text, text) to authenticated;

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

  -- Real gates restored: identity and background checks must actually be
  -- approved (via a verification provider or admin decide_verification()),
  -- not assumed.
  if not v_worker.is_kyc_verified then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'KYC_REQUIRED',
      'message', 'Complete identity verification.',
      'action', 'verification/kyc');
  end if;

  if not v_worker.is_background_verified then
    v_reasons := v_reasons || jsonb_build_object(
      'code', 'BACKGROUND_CHECK_REQUIRED',
      'message', 'Your background check is not complete yet.',
      'action', 'verification');
  end if;

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
-- 3. Gig review gate: restore require_review
-- ---------------------------------------------------------------------------
update public.platform_settings
set value = 'true'::jsonb,
    description = 'Whether a newly submitted gig requires ops review before going ACTIVE.',
    updated_at = now()
where key = 'gigs.require_review';

-- ---------------------------------------------------------------------------
-- 4. customer_find_gigs: restore auth guard, spatial filter, KYC filter
-- ---------------------------------------------------------------------------
create or replace function public.customer_find_gigs(
  p_service_id  uuid,
  p_latitude    double precision,
  p_longitude   double precision,
  p_radius_km   numeric default 25
)
returns setof jsonb
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_customer public.customers%rowtype;
  v_max_km   numeric;
begin
  -- Real auth guard restored: only a signed-in, active customer may call this.
  v_customer := public.require_current_customer();

  if not exists (select 1 from public.services where id = p_service_id and is_active) then
    raise exception 'NOT_FOUND: that service does not exist' using errcode = 'P0002';
  end if;

  v_max_km := least(
    greatest(coalesce(p_radius_km, 25), 1),
    coalesce(
      (select value::numeric from public.platform_settings where key = 'matching.max_radius_km'),
      25
    )
  );

  return query
  select jsonb_build_object(
    'gig_id',          g.id,
    'title',           g.title,
    'description',     g.description,
    'price_minor',     g.price_minor,
    'pricing_unit',    g.pricing_unit,
    'currency',        'INR',
    'estimated_duration_minutes', g.estimated_duration_minutes,
    'worker_id',       w.id,
    'worker_code',     w.worker_code,
    'worker_name',     w.full_name,
    'worker_rating',   w.rating_avg,
    'worker_rating_count', w.rating_count,
    'worker_jobs_completed', w.jobs_completed,
    'is_kyc_verified', w.is_kyc_verified,
    'is_background_verified', w.is_background_verified,
    'is_insured',      w.is_insured,
    'experience_years', w.experience_years,
    'bio',             w.bio,
    'city',            w.city,
    'approx_latitude',
      round((w.latitude + (random() - 0.5) * 0.01)::numeric, 4),
    'approx_longitude',
      round((w.longitude + (random() - 0.5) * 0.01)::numeric, 4),
    'distance_km',
      round((earth_distance(
        ll_to_earth(p_latitude, p_longitude),
        ll_to_earth(w.latitude, w.longitude)
      ) / 1000.0)::numeric, 1)
  )
  from public.worker_gigs g
  join public.workers w on w.id = g.worker_id
  where g.service_id  = p_service_id
    and g.status      = 'ACTIVE'
    and w.status      = 'ACTIVE'
    -- Real KYC / background-check filter restored.
    and w.is_kyc_verified
    and w.is_background_verified
    and w.latitude    is not null
    and w.longitude   is not null
    -- Real spatial filter restored.
    and earth_box(ll_to_earth(p_latitude, p_longitude), v_max_km * 1000)
        @> ll_to_earth(w.latitude, w.longitude)
    and (earth_distance(
           ll_to_earth(p_latitude, p_longitude),
           ll_to_earth(w.latitude, w.longitude)
         ) / 1000.0) <= least(v_max_km, w.service_radius_km)
  order by
    case w.availability when 'AVAILABLE' then 0 when 'BUSY' then 1 else 2 end,
    coalesce(w.rating_avg, 3.5) desc,
    earth_distance(
      ll_to_earth(p_latitude, p_longitude),
      ll_to_earth(w.latitude, w.longitude)
    );
end;
$$;

-- Revoke the anon grant 0032 added; only authenticated customers may call this.
revoke execute on function
  public.customer_find_gigs(uuid, double precision, double precision, numeric)
from anon;

grant execute on function
  public.customer_find_gigs(uuid, double precision, double precision, numeric)
to authenticated;

-- ---------------------------------------------------------------------------
-- 5. Recompute verification flags from real worker_verifications history
-- ---------------------------------------------------------------------------
-- 0021-0024 wrote is_kyc_verified / is_background_verified directly, bypassing
-- the sync_worker_verification_flags() trigger that is supposed to be the only
-- writer. Recompute every worker's flags from what is actually approved (and
-- current) in worker_verifications, so nobody stays "verified" without a real
-- verification record backing it.
update public.workers w
set is_kyc_verified           = coalesce(v.kyc, false),
    is_qualification_verified = coalesce(v.qual, false),
    is_skill_verified         = coalesce(v.skill, false),
    is_background_verified    = coalesce(v.bgv, false),
    is_insured                = coalesce(v.ins, false),
    verified_at = case
      when coalesce(v.kyc, false) and coalesce(v.bgv, false) then coalesce(w.verified_at, now())
      else null
    end
from (
  select
    w2.id as worker_id,
    bool_or(wv.type = 'IDENTITY_KYC'      and wv.status = 'APPROVED' and (wv.expires_at is null or wv.expires_at > now())) as kyc,
    bool_or(wv.type in ('ITI_CERTIFICATE','DIPLOMA') and wv.status = 'APPROVED' and (wv.expires_at is null or wv.expires_at > now())) as qual,
    bool_or(wv.type = 'RPL_SKILL'         and wv.status = 'APPROVED' and (wv.expires_at is null or wv.expires_at > now())) as skill,
    bool_or(wv.type = 'BACKGROUND_CHECK'  and wv.status = 'APPROVED' and (wv.expires_at is null or wv.expires_at > now())) as bgv,
    bool_or(wv.type = 'INSURANCE'         and wv.status = 'APPROVED' and (wv.expires_at is null or wv.expires_at > now())) as ins
  from public.workers w2
  left join public.worker_verifications wv on wv.worker_id = w2.id
  group by w2.id
) v
where v.worker_id = w.id;
