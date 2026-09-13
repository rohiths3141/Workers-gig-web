-- ===========================================================================
-- DEVELOPMENT SEED — NEVER RUN AGAINST PRODUCTION
-- ---------------------------------------------------------------------------
-- Sample customers, workers, verification records and one open booking, so the
-- admin panel has something to render locally. The Firebase UIDs are fake and
-- belong to no real account; these users cannot sign in.
--
-- The application never falls back to this data. If the database is empty, the
-- admin panel shows empty states and zeros. This file exists only to be run by
-- a developer on a local or disposable database.
--
-- Prerequisites: migrations applied, and bootstrap_super_admin.sql run (the
-- sample verification decisions are attributed to that administrator).
-- ===========================================================================

do $$
declare
  v_admin     uuid;
  v_electric  uuid;
  v_plumbing  uuid;
  v_profile   uuid;
  v_customer  uuid;
  v_worker    uuid;
  v_booking   uuid;
  r           record;
begin
  -- Hosted Supabase databases are also named "postgres", so the database name
  -- proves nothing. Require an explicit, session-local opt-in instead. Run
  -- this line first, and only against a development database:
  --   set app.allow_dev_seed = 'on';
  if coalesce(current_setting('app.allow_dev_seed', true), '') <> 'on' then
    raise exception 'Refusing to seed. Run: set app.allow_dev_seed = ''on''; first, and only on a development database.';
  end if;

  select id into v_admin from public.admin_users where role = 'SUPER_ADMIN' and is_active limit 1;
  if v_admin is null then
    raise exception 'Run bootstrap_super_admin.sql first.';
  end if;

  if exists (select 1 from public.profiles where firebase_uid like 'dev-seed-%') then
    raise notice 'Development seed already applied; nothing to do.';
    return;
  end if;

  select id into v_electric from public.services where slug = 'electrical';
  select id into v_plumbing from public.services where slug = 'plumbing';

  -- Customers --------------------------------------------------------------
  for r in select * from (values
    ('dev-seed-customer-0001', 'Ananya Rao', '9000000001', 'Bengaluru', 12.9716, 77.5946),
    ('dev-seed-customer-0002', 'Rahul Menon', '9000000002', 'Bengaluru', 12.9352, 77.6245)
  ) as t(uid, name, phone, city, lat, lng)
  loop
    insert into public.profiles (firebase_uid, role, phone, display_name)
    values (r.uid, 'CUSTOMER', r.phone, r.name) returning id into v_profile;

    insert into public.customers (profile_id, firebase_uid, full_name, phone, city, state, latitude, longitude, address_line)
    values (v_profile, r.uid, r.name, r.phone, r.city, 'Karnataka', r.lat, r.lng, 'Development address, not real');
  end loop;

  -- Workers ----------------------------------------------------------------
  for r in select * from (values
    ('dev-seed-worker-0001', 'Suresh Kumar',  '9100000001', v_electric, 8,  12.9650, 77.6000, true),
    ('dev-seed-worker-0002', 'Imran Shaikh',  '9100000002', v_electric, 4,  12.9800, 77.5800, false),
    ('dev-seed-worker-0003', 'Lakshmi Devi',  '9100000003', v_plumbing, 11, 12.9400, 77.6200, true)
  ) as t(uid, name, phone, service_id, years, lat, lng, qualified)
  loop
    insert into public.profiles (firebase_uid, role, phone, display_name)
    values (r.uid, 'WORKER', r.phone, r.name) returning id into v_profile;

    insert into public.workers (profile_id, firebase_uid, full_name, phone, status, availability, primary_service_id,
                                experience_years, city, state, latitude, longitude, service_radius_km)
    values (v_profile, r.uid, r.name, r.phone, 'ACTIVE', 'AVAILABLE', r.service_id,
            r.years, 'Bengaluru', 'Karnataka', r.lat, r.lng, 15)
    returning id into v_worker;

    insert into public.worker_verifications (worker_id, type, status, submitted_at, reviewed_by, reviewed_at, expires_at, details)
    values
      (v_worker, 'IDENTITY_KYC', 'APPROVED', now() - interval '20 days', v_admin, now() - interval '18 days', null, '{"document":"development sample"}'),
      (v_worker, 'BACKGROUND_CHECK', 'APPROVED', now() - interval '20 days', v_admin, now() - interval '15 days', now() + interval '700 days', '{"provider":"development sample"}');

    if r.qualified then
      insert into public.worker_verifications (worker_id, type, status, submitted_at, reviewed_by, reviewed_at, details)
      values (v_worker, 'ITI_CERTIFICATE', 'APPROVED', now() - interval '19 days', v_admin, now() - interval '14 days', '{"trade":"development sample"}');
    else
      insert into public.worker_verifications (worker_id, type, status, submitted_at, details)
      values (v_worker, 'ITI_CERTIFICATE', 'PENDING', now() - interval '2 days', '{"trade":"development sample"}');
    end if;
  end loop;

  -- One open booking, then let the real matching engine score it -----------
  select id into v_customer from public.customers where firebase_uid = 'dev-seed-customer-0001';

  insert into public.bookings (customer_id, service_id, status, problem_description, address_line, city, state, latitude, longitude, quoted_amount_minor)
  values (v_customer, v_electric, 'REQUESTED', 'Development sample: MCB trips when the geyser is switched on.',
          'Development address, not real', 'Bengaluru', 'Karnataka', 12.9716, 77.5946, 49900)
  returning id into v_booking;

  insert into public.booking_events (booking_id, event_type, to_status, actor_type, note)
  values (v_booking, 'REQUEST_CREATED', 'REQUESTED', 'CUSTOMER', 'Development seed');

  perform public.run_matching(v_booking);

  raise notice 'Development seed applied.';
end;
$$;
