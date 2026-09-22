-- ===========================================================================
-- Bootstrap the first SUPER_ADMIN
-- ---------------------------------------------------------------------------
-- There is no self-service path to becoming an administrator, by design. The
-- very first one has to be created directly in the database. Run this once per
-- environment (development, staging, production).
--
-- 1. Sign in to the admin panel once with the Google account or phone number
--    that should become the first administrator. The sign-in is refused (not an
--    admin yet), but it creates that person's row in public.profiles.
-- 2. Copy their Firebase UID from Firebase Console > Authentication > Users.
-- 3. Replace the three values below and run this script in the SQL editor.
-- 4. Sign in again. You now land on the dashboard.
--
-- Every later administrator should be created by a SUPER_ADMIN, not by
-- repeating this script.
-- ===========================================================================

do $$
declare
  v_firebase_uid text := 'Azc0jy0AjJhToqvZTZGdBjJM2082';
  v_full_name    text := 'Rohith';
  v_email        text := 's.rohith9814@gmail.com';
  v_profile_id   uuid;
begin
  if v_firebase_uid like 'REPLACE_%' or v_full_name like 'REPLACE_%' or v_email like 'REPLACE_%' then
    raise exception 'Edit the three values at the top of this script before running it.';
  end if;

  if exists (select 1 from public.admin_users where role = 'SUPER_ADMIN' and is_active) then
    raise exception 'An active SUPER_ADMIN already exists. Create further administrators from the admin panel.';
  end if;

  insert into public.profiles (firebase_uid, role, account_status, email, display_name)
  values (v_firebase_uid, 'ADMIN', 'ACTIVE', v_email, v_full_name)
  on conflict (firebase_uid) do update
    set role = 'ADMIN', account_status = 'ACTIVE'
  returning id into v_profile_id;

  insert into public.admin_users (profile_id, firebase_uid, email, full_name, role)
  values (v_profile_id, v_firebase_uid, v_email, v_full_name, 'SUPER_ADMIN');

  insert into public.audit_logs (actor_type, action, resource_type, resource_id, after_state, reason)
  values ('SYSTEM', 'admin.bootstrapped', 'admin_user', v_firebase_uid,
          jsonb_build_object('role', 'SUPER_ADMIN', 'email', v_email),
          'First SUPER_ADMIN created by bootstrap script');

  raise notice 'SUPER_ADMIN created for %', v_email;
end;
$$;
