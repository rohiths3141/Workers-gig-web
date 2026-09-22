-- ===========================================================================
-- 0061  Sign-in for an account whose Firebase UID has changed
-- ---------------------------------------------------------------------------
-- Symptom: a registered worker could sign up but could never sign back in.
--
-- Identity on this platform is anchored on public.profiles.firebase_uid, and
-- the apps read their own row with
--
--     select ... from workers where firebase_uid = <uid from the ID token>
--
-- That is correct right up to the moment Firebase mints a *different* UID for
-- the same phone number — which it does whenever the Firebase user record is
-- deleted and the number signs in again (support deleting an account, a user
-- deleting their own, a test-number slot being recycled, a project migration).
--
-- From then on the person is locked out with no way back:
--
--   1. getCurrentWorker() matches nothing, so the app decides registration
--      never finished and sends them to the Register screen.
--   2. Registering raises 'CONFLICT: that number is already registered',
--      because the old row still holds the phone number.
--
-- There is no third option offered to them, and every job, rating and rupee on
-- the old row is unreachable. Observed live: +919292929292 and +919393939393
-- both had a Firebase UID that no longer matched public.workers.
--
-- The fix follows from what this platform actually treats as a credential.
-- There are no passwords anywhere; the only proof of identity is control of a
-- phone number, demonstrated by OTP. So when a caller proves control of a
-- number that already owns an account, the account is re-bound to their new
-- UID rather than refused.
--
-- The one thing that makes this safe is where the phone number comes from:
-- public.firebase_phone() reads the `phone_number` claim out of the verified
-- Firebase ID token, never the p_phone argument the client sent. A client can
-- type any number it likes into the app; it cannot put one into a Google-signed
-- token. If the claim is absent, no re-bind happens and the old refusal stands.
--
-- Known and accepted: if a Firebase user changes their phone number and a
-- second user later registers the number they gave up, the second user inherits
-- the account. That is inherent to phone-as-identity, and this platform has no
-- change-number flow, so the situation cannot arise through the apps.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- The caller's verified phone number
-- ---------------------------------------------------------------------------
-- Same two access paths as public.firebase_uid(), and the same rule: only a
-- subject issued by Firebase is honoured, so a token minted by some other
-- issuer that happens to reach PostgREST proves nothing here.
--
-- Normalised to the 10-digit national number, matching how workers.phone and
-- customers.phone are stored by the *_create_profile functions.
create or replace function public.firebase_phone()
returns text
language plpgsql
stable
set search_path = public, pg_temp
as $$
declare
  v_claims jsonb;
  v_phone  text;
begin
  begin
    v_claims := nullif(current_setting('request.jwt.claims', true), '')::jsonb;
  exception when others then
    v_claims := null;
  end;

  if v_claims is not null
     and (v_claims ->> 'iss') like 'https://securetoken.google.com/%'
  then
    -- Firebase puts the verified number in both places on a phone sign-in.
    -- The second is read as a fallback so this does not quietly become a
    -- no-op if the top-level claim is ever absent.
    v_phone := coalesce(
      v_claims ->> 'phone_number',
      v_claims -> 'firebase' -> 'identities' -> 'phone' ->> 0
    );
  end if;

  -- Trusted backend that verified the token out of band. Clients cannot set
  -- this GUC through PostgREST.
  if v_phone is null then
    v_phone := nullif(current_setting('request.firebase_phone', true), '');
  end if;

  if v_phone is null then
    return null;
  end if;

  v_phone := regexp_replace(v_phone, '[^0-9]', '', 'g');
  if length(v_phone) > 10 and left(v_phone, 2) = '91' then
    v_phone := right(v_phone, 10);
  end if;

  if v_phone !~ '^[0-9]{10,15}$' then
    return null;
  end if;

  return v_phone;
end;
$$;

comment on function public.firebase_phone is
  'The OTP-verified phone number on this request''s Firebase ID token, as 10 digits, or NULL. Never derived from a client-supplied body field.';

-- ---------------------------------------------------------------------------
-- Re-point a profile at a new Firebase UID
-- ---------------------------------------------------------------------------
-- Callers must already have established that the new UID is entitled to this
-- profile. This function only performs the move.
--
-- workers.firebase_uid and customers.firebase_uid follow automatically: both
-- carry a composite FK to profiles (id, firebase_uid) declared ON UPDATE
-- CASCADE, so updating the profile updates the child row in the same statement.
-- push_tokens.firebase_uid is a plain denormalised column and is updated here.
create or replace function public.rebind_profile_to_uid(
  p_profile_id uuid,
  p_new_uid    text,
  p_phone      text
)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_old_uid  text;
  v_existing public.profiles%rowtype;
begin
  select firebase_uid into v_old_uid
  from public.profiles
  where id = p_profile_id;

  if v_old_uid is null or v_old_uid = p_new_uid then
    return;
  end if;

  -- A profile may already exist for the new UID: sign-in on the web records
  -- one. If it carries an account of its own the two identities are genuinely
  -- distinct and must not be merged; if it is a bare stub it is discarded so
  -- the unique index on firebase_uid is free.
  select * into v_existing from public.profiles where firebase_uid = p_new_uid;

  if found then
    if exists (select 1 from public.workers     where profile_id = v_existing.id)
       or exists (select 1 from public.customers where profile_id = v_existing.id)
       or exists (select 1 from public.admin_users where profile_id = v_existing.id)
    then
      raise exception
        'CONFLICT: this sign-in already belongs to another account on this platform'
        using errcode = '23505';
    end if;

    delete from public.profiles where id = v_existing.id;
  end if;

  update public.profiles
  set firebase_uid = p_new_uid,
      phone        = coalesce(p_phone, phone),
      updated_at   = now()
  where id = p_profile_id;

  update public.push_tokens
  set firebase_uid = p_new_uid
  where profile_id = p_profile_id;

  -- A silent change of who owns an account is exactly the kind of thing an
  -- investigation needs to be able to see afterwards.
  perform public.write_audit_log(
    'profile.rebind_firebase_uid',
    'profiles',
    p_profile_id::text,
    jsonb_build_object('firebase_uid', v_old_uid),
    jsonb_build_object('firebase_uid', p_new_uid),
    'Firebase issued a new UID for the same OTP-verified number'
  );
end;
$$;

comment on function public.rebind_profile_to_uid is
  'Moves a profile onto a new Firebase UID after the caller has proven ownership. Child rows follow via ON UPDATE CASCADE.';

revoke all on function public.rebind_profile_to_uid(uuid, text, text) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- worker_claim_account
-- ---------------------------------------------------------------------------
-- Called by the worker app when the profile read comes back empty, before it
-- concludes that registration never happened. Returns the worker row if this
-- caller's verified number already owns one, NULL otherwise.
create or replace function public.worker_claim_account()
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid    text := public.firebase_uid();
  v_phone  text := public.firebase_phone();
  v_worker public.workers%rowtype;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before loading a profile'
      using errcode = '42501';
  end if;

  select * into v_worker from public.workers where firebase_uid = v_uid;
  if found then
    return v_worker;
  end if;

  -- No verified number on the token (an email or federated sign-in): there is
  -- nothing here that can be proven, so nothing is claimed.
  if v_phone is null then
    return null;
  end if;

  select * into v_worker from public.workers where phone = v_phone;
  if not found then
    return null;
  end if;

  perform public.rebind_profile_to_uid(v_worker.profile_id, v_uid, v_phone);

  select * into v_worker from public.workers where id = v_worker.id;
  return v_worker;
end;
$$;

comment on function public.worker_claim_account is
  'Re-binds an existing worker account to the caller''s Firebase UID when the OTP-verified number matches. NULL when there is nothing to claim.';

grant execute on function public.worker_claim_account() to authenticated;

-- ---------------------------------------------------------------------------
-- customer_claim_account
-- ---------------------------------------------------------------------------
create or replace function public.customer_claim_account()
returns public.customers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid      text := public.firebase_uid();
  v_phone    text := public.firebase_phone();
  v_customer public.customers%rowtype;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before loading a profile'
      using errcode = '42501';
  end if;

  select * into v_customer from public.customers where firebase_uid = v_uid;
  if found then
    return v_customer;
  end if;

  if v_phone is null then
    return null;
  end if;

  select * into v_customer from public.customers where phone = v_phone;
  if not found then
    return null;
  end if;

  perform public.rebind_profile_to_uid(v_customer.profile_id, v_uid, v_phone);

  select * into v_customer from public.customers where id = v_customer.id;
  return v_customer;
end;
$$;

comment on function public.customer_claim_account is
  'Re-binds an existing customer account to the caller''s Firebase UID when the OTP-verified number matches. NULL when there is nothing to claim.';

grant execute on function public.customer_claim_account() to authenticated;

-- ---------------------------------------------------------------------------
-- Registration stops being a dead end
-- ---------------------------------------------------------------------------
-- The apps now claim before they ever show the Register screen, so this path
-- should not be reached. It is fixed anyway: an old build, a stale session or
-- a race must not be able to strand someone on an error with no way forward.
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
  v_uid       text := public.firebase_uid();
  v_verified  text := public.firebase_phone();
  v_profile   public.profiles%rowtype;
  v_worker    public.workers%rowtype;
  v_phone     text;
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

  -- The number already owns an account. If it is this caller's own number,
  -- hand the account back instead of refusing; otherwise the refusal stands.
  select * into v_worker from public.workers where phone = v_phone;
  if found then
    if v_verified is not null and v_verified = v_worker.phone then
      perform public.rebind_profile_to_uid(v_worker.profile_id, v_uid, v_verified);
      select * into v_worker from public.workers where id = v_worker.id;
      return v_worker;
    end if;

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

  -- A new worker starts REGISTERED and must go through verification before
  -- they can ever reach ACTIVE.
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

create or replace function public.customer_create_profile(
  p_full_name text,
  p_phone     text,
  p_email     text default null
)
returns public.customers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid      text := public.firebase_uid();
  v_verified text := public.firebase_phone();
  v_profile  public.profiles%rowtype;
  v_customer public.customers%rowtype;
  v_phone    text;
begin
  if v_uid is null then
    raise exception 'FORBIDDEN: sign in before creating a profile'
      using errcode = '42501';
  end if;

  select * into v_customer from public.customers where firebase_uid = v_uid;
  if found then
    return v_customer;
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

  select * into v_customer from public.customers where phone = v_phone;
  if found then
    if v_verified is not null and v_verified = v_customer.phone then
      perform public.rebind_profile_to_uid(v_customer.profile_id, v_uid, v_verified);
      select * into v_customer from public.customers where id = v_customer.id;
      return v_customer;
    end if;

    raise exception 'CONFLICT: that number is already registered as a customer account'
      using errcode = '23505';
  end if;

  -- Workers and customers share the profiles table but may not share a UID
  -- (the apps are separate: one person cannot be both on the same account).
  select * into v_profile from public.profiles where firebase_uid = v_uid;

  if not found then
    insert into public.profiles (firebase_uid, role, phone, email, display_name)
    values (v_uid, 'CUSTOMER', v_phone, nullif(btrim(coalesce(p_email, '')), ''), btrim(p_full_name))
    returning * into v_profile;
  elsif v_profile.role <> 'CUSTOMER' then
    raise exception 'FORBIDDEN: this account is registered as a worker account'
      using errcode = '42501';
  end if;

  insert into public.customers
    (profile_id, firebase_uid, full_name, phone, email, status)
  values
    (v_profile.id, v_uid, btrim(p_full_name), v_phone,
     nullif(btrim(coalesce(p_email, '')), ''), 'ACTIVE')
  returning * into v_customer;

  return v_customer;
end;
$$;

grant execute on function public.customer_create_profile(text, text, text) to authenticated;
