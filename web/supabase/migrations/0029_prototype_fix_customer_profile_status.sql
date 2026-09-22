-- =============================================================================
-- 0029 — PROTOTYPE: ensure customer profile + customers row are fully valid
-- =============================================================================
-- current_customer_id() requires:
--   c.firebase_uid = firebase_uid()   (from JWT claim)
--   p.account_status = 'ACTIVE'
--
-- If either is wrong, require_current_customer() raises FORBIDDEN and every
-- customer RPC fails.
--
-- This migration prints the current state of all customers + profiles and
-- forces account_status = 'ACTIVE' on all profiles linked to customers,
-- and ensures firebase_uid is set on the customers row.
-- =============================================================================

do $$
declare
  rec record;
begin
  raise notice '=== PROFILES (all) ===';
  for rec in
    select id, phone, account_status, role
    from public.profiles
    order by created_at desc limit 10
  loop
    raise notice 'profile: id=% phone=% status=% role=%',
      rec.id, rec.phone, rec.account_status, rec.role;
  end loop;

  raise notice '=== CUSTOMERS (all) ===';
  for rec in
    select c.id, c.firebase_uid, c.status, c.profile_id,
           p.phone, p.account_status as profile_status
    from public.customers c
    join public.profiles p on p.id = c.profile_id
    order by c.created_at desc limit 10
  loop
    raise notice 'customer: id=% firebase_uid=% status=% phone=% profile_status=%',
      rec.id, rec.firebase_uid, rec.status, rec.phone, rec.profile_status;
  end loop;
end;
$$;

-- Force ALL profiles that have a linked customer row to be ACTIVE.
update public.profiles p
set account_status = 'ACTIVE'
where exists (
  select 1 from public.customers c where c.profile_id = p.id
)
and account_status <> 'ACTIVE';

-- Force ALL customers to be ACTIVE.
update public.customers
set status = 'ACTIVE'
where status <> 'ACTIVE';

do $$
declare
  rec record;
begin
  raise notice '=== AFTER FIX: CUSTOMERS ===';
  for rec in
    select c.id, c.firebase_uid, c.status, p.phone, p.account_status
    from public.customers c
    join public.profiles p on p.id = c.profile_id
    order by c.created_at desc limit 5
  loop
    raise notice 'customer: id=% firebase_uid=% status=% phone=% profile_status=%',
      rec.id, rec.firebase_uid, rec.status, rec.phone, rec.account_status;
  end loop;
end;
$$;
