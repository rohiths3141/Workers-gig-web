-- ===========================================================================
-- 0002  Identity (Firebase UID) and the granular permission model
-- ---------------------------------------------------------------------------
-- AUTHENTICATION IS FIREBASE. This database contains no auth.users reference,
-- no Supabase Auth session, and no password material. The only identity anchor
-- is the Firebase UID.
--
--   Firebase Authentication
--            |  uid
--            v
--   public.profiles (firebase_uid)
--            |
--            +--> public.customers
--            +--> public.workers
--            +--> public.admin_users
--
-- How the UID reaches Postgres, on both access paths:
--
--   1. Direct client access (Flutter customer/worker apps, and any browser call
--      made with the anon key): the Firebase ID token is sent as the bearer
--      token. Supabase Third-Party Auth validates it against Google's JWKS, so
--      request.jwt.claims carries the Firebase claims and RLS applies normally.
--
--   2. Trusted backend access (Next.js admin route handlers, Edge Functions):
--      the server verifies the Firebase ID token or session cookie with the
--      Firebase Admin SDK, then sets request.firebase_uid for the transaction.
--
-- public.firebase_uid() resolves either path, and prefers the cryptographically
-- verified JWT claim. Authorization is then re-derived from this database on
-- every privileged call — a role or permission asserted by a client is ignored.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------
-- One row per Firebase user. Holds platform account state only; name, email,
-- phone and photo remain owned by Firebase Authentication and are mirrored here
-- purely so that operational screens and joins do not require a Firebase call.
create table public.profiles (
  id             uuid primary key default gen_random_uuid(),
  firebase_uid   text not null unique,
  role           public.profile_role not null,
  account_status public.profile_status not null default 'ACTIVE',

  -- Mirrored from the Firebase user record at sign-in. Never authoritative.
  email          citext,
  phone          text,
  display_name   text,

  last_login_at  timestamptz,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint profiles_firebase_uid_format check (
    length(firebase_uid) between 8 and 128 and firebase_uid !~ '\s'
  ),
  constraint profiles_phone_format check (phone is null or phone ~ '^[0-9]{10,15}$')
);

comment on table public.profiles is
  'Platform-side record bound to a Firebase UID. Firebase Authentication remains authoritative for identity.';
comment on column public.profiles.firebase_uid is
  'Firebase Authentication UID. The single identity reference across the web, admin, and both Flutter apps.';

-- Lets dependent tables carry firebase_uid alongside profile_id and have the
-- database guarantee both point at the same profile (composite FK below).
alter table public.profiles
  add constraint profiles_id_uid_unique unique (id, firebase_uid);

create index profiles_role_idx on public.profiles (role, account_status);
create index profiles_email_idx on public.profiles (email) where email is not null;
create index profiles_phone_idx on public.profiles (phone) where phone is not null;

-- ---------------------------------------------------------------------------
-- Identity resolution
-- ---------------------------------------------------------------------------
create or replace function public.firebase_uid()
returns text
language plpgsql
stable
set search_path = public, pg_temp
as $$
declare
  v_claims jsonb;
  v_sub    text;
  v_iss    text;
begin
  -- Path 1: verified Firebase ID token presented to PostgREST.
  begin
    v_claims := nullif(current_setting('request.jwt.claims', true), '')::jsonb;
  exception when others then
    v_claims := null;
  end;

  if v_claims is not null then
    v_sub := v_claims ->> 'sub';
    v_iss := v_claims ->> 'iss';

    -- Only honour a subject that was actually issued by Firebase. This rejects
    -- any token minted by some other issuer that happens to reach PostgREST.
    if v_sub is not null and v_iss like 'https://securetoken.google.com/%' then
      return v_sub;
    end if;
  end if;

  -- Path 2: trusted backend that already verified the token out of band and set
  -- the UID for this transaction. Clients cannot set this GUC through PostgREST.
  return nullif(current_setting('request.firebase_uid', true), '');
end;
$$;

comment on function public.firebase_uid is
  'The authenticated Firebase UID for this request, or NULL. Never derived from a client-supplied body field.';

create or replace function public.current_profile_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select p.id
  from public.profiles p
  where p.firebase_uid = public.firebase_uid()
    and p.account_status = 'ACTIVE'
$$;

-- ---------------------------------------------------------------------------
-- admin_users
-- ---------------------------------------------------------------------------
-- Authorization rule of the platform:
--
--   authenticated  !=  admin
--   admin          !=  authorized for a specific action
--
-- Holding a valid Firebase session grants nothing here. An administrator is an
-- is_active row in this table, and each individual action is gated on a named
-- permission resolved from the role plus per-user grants and revocations.
create table public.admin_users (
  id            uuid primary key default gen_random_uuid(),
  profile_id    uuid not null unique,
  firebase_uid  text not null unique,
  email         citext not null unique,
  full_name     text not null,
  role          public.admin_role not null,
  is_active     boolean not null default true,
  phone         text,
  -- Firebase Storage object path of the avatar, resolved through media_assets.
  avatar_media_id uuid,
  last_login_at timestamptz,
  -- Rotate-on-demand kill switch: bumping this invalidates any cached
  -- permission snapshot held by a live session.
  permissions_version integer not null default 1,
  created_by    uuid references public.admin_users (id) on delete set null,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),

  constraint admin_users_full_name_not_blank check (length(btrim(full_name)) > 0),
  -- Composite FK: guarantees profile_id and firebase_uid name the same profile.
  constraint admin_users_profile_fk
    foreign key (profile_id, firebase_uid)
    references public.profiles (id, firebase_uid)
    on update cascade on delete cascade
);

comment on table public.admin_users is
  'A Firebase-authenticated user is an administrator only if an is_active row exists here.';

create index admin_users_role_idx on public.admin_users (role) where is_active;
create index admin_users_email_trgm_idx on public.admin_users using gin (email gin_trgm_ops);

-- ---------------------------------------------------------------------------
-- Permission catalogue
-- ---------------------------------------------------------------------------
-- Permissions are rows, not hard-coded strings, so the catalogue can be audited
-- and extended without a deploy.
create table public.permissions (
  key         text primary key,
  resource    text not null,
  action      text not null,
  description text not null,
  -- Actions that move money, change a verification outcome, or restrict an
  -- account. Forces a reason string and heightened audit detail.
  is_sensitive boolean not null default false,

  constraint permissions_key_format check (key = resource || '.' || action)
);

insert into public.permissions (key, resource, action, description, is_sensitive) values
  ('workers.read',            'workers',      'read',    'View worker profiles and lists', false),
  ('workers.update',          'workers',      'update',  'Edit worker profile fields', false),
  ('workers.verify',          'workers',      'verify',  'Change a worker verification outcome', true),
  ('workers.restrict',        'workers',      'restrict','Restrict, suspend or reinstate a worker account', true),
  ('workers.documents.read',  'workers',      'documents.read', 'Open worker identity and qualification documents', true),

  ('customers.read',          'customers',    'read',    'View customer profiles and lists', false),
  ('customers.update',        'customers',    'update',  'Edit customer profile fields', false),
  ('customers.restrict',      'customers',    'restrict','Restrict, suspend or reinstate a customer account', true),

  ('bookings.read',           'bookings',     'read',    'View bookings and their timeline', false),
  ('bookings.update',         'bookings',     'update',  'Transition a booking through its state machine', true),
  ('bookings.cancel',         'bookings',     'cancel',  'Cancel a booking on behalf of a party', true),
  ('bookings.reassign',       'bookings',     'reassign','Reassign a booking to a different worker', true),

  ('matching.read',           'matching',     'read',    'Inspect match candidates and scores', false),
  ('matching.rerun',          'matching',     'rerun',   'Re-run the matching engine for a booking', false),

  ('materials.read',          'materials',    'read',    'View material requests and receipts', false),
  ('materials.update',        'materials',    'update',  'Correct material costs and billing state', true),

  ('payments.read',           'payments',     'read',    'View payments and gateway references', false),
  ('payments.refund',         'payments',     'refund',  'Issue a full or partial refund', true),

  ('wallets.read',            'wallets',      'read',    'View worker wallets and ledger entries', false),
  ('wallets.adjust',          'wallets',      'adjust',  'Post a manual wallet adjustment', true),

  ('payouts.read',            'payouts',      'read',    'View payout requests', false),
  ('payouts.approve',         'payouts',      'approve', 'Approve a payout for disbursement', true),
  ('payouts.reject',          'payouts',      'reject',  'Reject a payout request', true),

  ('claims.read',             'claims',       'read',    'View damage claims and evidence', false),
  ('claims.review',           'claims',       'review',  'Take a claim under review or request information', false),
  ('claims.approve',          'claims',       'approve', 'Approve or partially approve a claim', true),
  ('claims.reject',           'claims',       'reject',  'Reject a claim', true),

  ('insurance.read',          'insurance',    'read',    'View worker insurance policies', false),
  ('insurance.update',        'insurance',    'update',  'Record or correct an insurance policy', true),

  ('verification.read',       'verification', 'read',    'View the verification queue', false),
  ('verification.review',     'verification', 'review',  'Claim a verification case for review', false),
  ('verification.approve',    'verification', 'approve', 'Approve a verification case', true),
  ('verification.reject',     'verification', 'reject',  'Reject a verification case', true),

  ('support.read',            'support',      'read',    'View support tickets', false),
  ('support.respond',         'support',      'respond', 'Reply to and resolve support tickets', false),
  ('support.assign',          'support',      'assign',  'Assign tickets to administrators', false),

  ('notifications.read',      'notifications','read',    'View the notification delivery log', false),
  ('notifications.send',      'notifications','send',    'Queue an operational notification', true),

  ('media.read',              'media',        'read',    'Open non-sensitive platform media', false),
  ('media.read_sensitive',    'media',        'read_sensitive', 'Open KYC, claim and background-check media', true),

  ('services.read',           'services',     'read',    'View the service catalogue', false),
  ('services.update',         'services',     'update',  'Edit the service catalogue', false),

  ('audit_logs.read',         'audit_logs',   'read',    'Read the audit trail', false),

  ('settings.read',           'settings',     'read',    'View platform settings', false),
  ('settings.update',         'settings',     'update',  'Change platform settings', true),

  ('admins.read',             'admins',       'read',    'View administrator accounts', false),
  ('admins.manage',           'admins',       'manage',  'Create, disable and re-role administrators', true);

-- ---------------------------------------------------------------------------
-- Role -> permission mapping
-- ---------------------------------------------------------------------------
create table public.role_permissions (
  role       public.admin_role not null,
  permission text not null references public.permissions (key) on delete cascade,
  primary key (role, permission)
);

-- SUPER_ADMIN receives the full catalogue.
insert into public.role_permissions (role, permission)
select 'SUPER_ADMIN'::public.admin_role, key from public.permissions;

-- ADMIN: broad operational reach, but not administrator management and not the
-- ability to unilaterally move money out of the platform.
insert into public.role_permissions (role, permission)
select 'ADMIN'::public.admin_role, key
from public.permissions
where key not in ('admins.manage', 'payouts.approve', 'wallets.adjust', 'settings.update');

insert into public.role_permissions (role, permission) values
  ('VERIFICATION_ADMIN', 'workers.read'),
  ('VERIFICATION_ADMIN', 'workers.verify'),
  ('VERIFICATION_ADMIN', 'workers.documents.read'),
  ('VERIFICATION_ADMIN', 'verification.read'),
  ('VERIFICATION_ADMIN', 'verification.review'),
  ('VERIFICATION_ADMIN', 'verification.approve'),
  ('VERIFICATION_ADMIN', 'verification.reject'),
  ('VERIFICATION_ADMIN', 'insurance.read'),
  ('VERIFICATION_ADMIN', 'insurance.update'),
  ('VERIFICATION_ADMIN', 'media.read'),
  ('VERIFICATION_ADMIN', 'media.read_sensitive'),
  ('VERIFICATION_ADMIN', 'services.read'),
  ('VERIFICATION_ADMIN', 'audit_logs.read'),

  ('OPERATIONS_ADMIN', 'workers.read'),
  ('OPERATIONS_ADMIN', 'workers.update'),
  ('OPERATIONS_ADMIN', 'customers.read'),
  ('OPERATIONS_ADMIN', 'bookings.read'),
  ('OPERATIONS_ADMIN', 'bookings.update'),
  ('OPERATIONS_ADMIN', 'bookings.cancel'),
  ('OPERATIONS_ADMIN', 'bookings.reassign'),
  ('OPERATIONS_ADMIN', 'matching.read'),
  ('OPERATIONS_ADMIN', 'matching.rerun'),
  ('OPERATIONS_ADMIN', 'materials.read'),
  ('OPERATIONS_ADMIN', 'materials.update'),
  ('OPERATIONS_ADMIN', 'media.read'),
  ('OPERATIONS_ADMIN', 'services.read'),
  ('OPERATIONS_ADMIN', 'notifications.read'),
  ('OPERATIONS_ADMIN', 'audit_logs.read'),

  ('FINANCE_ADMIN', 'workers.read'),
  ('FINANCE_ADMIN', 'customers.read'),
  ('FINANCE_ADMIN', 'bookings.read'),
  ('FINANCE_ADMIN', 'materials.read'),
  ('FINANCE_ADMIN', 'media.read'),
  ('FINANCE_ADMIN', 'payments.read'),
  ('FINANCE_ADMIN', 'payments.refund'),
  ('FINANCE_ADMIN', 'wallets.read'),
  ('FINANCE_ADMIN', 'wallets.adjust'),
  ('FINANCE_ADMIN', 'payouts.read'),
  ('FINANCE_ADMIN', 'payouts.approve'),
  ('FINANCE_ADMIN', 'payouts.reject'),
  ('FINANCE_ADMIN', 'audit_logs.read'),

  ('SUPPORT_ADMIN', 'workers.read'),
  ('SUPPORT_ADMIN', 'customers.read'),
  ('SUPPORT_ADMIN', 'bookings.read'),
  ('SUPPORT_ADMIN', 'materials.read'),
  ('SUPPORT_ADMIN', 'media.read'),
  ('SUPPORT_ADMIN', 'payments.read'),
  ('SUPPORT_ADMIN', 'claims.read'),
  ('SUPPORT_ADMIN', 'claims.review'),
  ('SUPPORT_ADMIN', 'support.read'),
  ('SUPPORT_ADMIN', 'support.respond'),
  ('SUPPORT_ADMIN', 'support.assign'),
  ('SUPPORT_ADMIN', 'notifications.read'),
  ('SUPPORT_ADMIN', 'services.read');

-- ---------------------------------------------------------------------------
-- Per-administrator grants and revocations
-- ---------------------------------------------------------------------------
-- Lets an operator hold one extra permission without promoting their whole role,
-- and lets a permission be pulled from one person without re-roling them.
create table public.admin_user_permissions (
  admin_id   uuid not null references public.admin_users (id) on delete cascade,
  permission text not null references public.permissions (key) on delete cascade,
  -- true  = grant in addition to the role
  -- false = revoke even though the role grants it (revocation always wins)
  granted    boolean not null,
  reason     text,
  created_by uuid references public.admin_users (id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (admin_id, permission)
);

-- ---------------------------------------------------------------------------
-- Authorization helper functions
-- ---------------------------------------------------------------------------
-- SECURITY DEFINER so RLS policies on admin_users cannot recurse into
-- themselves. search_path is pinned to defeat search-path hijacking.

create or replace function public.current_admin_id()
returns uuid
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select a.id
  from public.admin_users a
  join public.profiles p on p.id = a.profile_id
  where a.firebase_uid = public.firebase_uid()
    and a.is_active
    and p.account_status = 'ACTIVE'
$$;

comment on function public.current_admin_id is
  'The calling Firebase users admin id, or NULL when they are not an active administrator.';

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select public.current_admin_id() is not null
$$;

create or replace function public.current_admin_role()
returns public.admin_role
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select a.role
  from public.admin_users a
  where a.id = public.current_admin_id()
$$;

-- Effective permission set = role grants + explicit grants - explicit revocations.
create or replace function public.admin_permissions(p_admin_id uuid)
returns setof text
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select rp.permission
  from public.admin_users a
  join public.role_permissions rp on rp.role = a.role
  where a.id = p_admin_id and a.is_active
  union
  select aup.permission
  from public.admin_user_permissions aup
  where aup.admin_id = p_admin_id and aup.granted
  except
  select aup.permission
  from public.admin_user_permissions aup
  where aup.admin_id = p_admin_id and not aup.granted
$$;

create or replace function public.admin_has_permission(p_permission text)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.admin_permissions(public.current_admin_id()) p
    where p = p_permission
  )
$$;

comment on function public.admin_has_permission is
  'The authorization primitive. Every admin RLS policy and every privileged RPC calls this. Permissions are read from this database, never from the request body.';

-- Raises instead of returning false. Used at the top of every SECURITY DEFINER
-- mutation so an unauthorized call fails loudly rather than silently no-opping.
create or replace function public.require_permission(p_permission text)
returns uuid
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
begin
  if public.firebase_uid() is null then
    raise exception 'UNAUTHENTICATED: no verified Firebase identity on this request'
      using errcode = '28000';
  end if;

  v_admin_id := public.current_admin_id();

  if v_admin_id is null then
    raise exception 'FORBIDDEN: caller is not an active administrator'
      using errcode = '42501';
  end if;

  if not public.admin_has_permission(p_permission) then
    raise exception 'FORBIDDEN: missing permission %', p_permission
      using errcode = '42501';
  end if;

  return v_admin_id;
end;
$$;

grant execute on function
  public.firebase_uid,
  public.current_profile_id,
  public.current_admin_id,
  public.is_admin,
  public.current_admin_role,
  public.admin_has_permission,
  public.require_permission
to authenticated, anon;

grant execute on function public.admin_permissions(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- updated_at maintenance
-- ---------------------------------------------------------------------------
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger profiles_touch_updated_at
  before update on public.profiles
  for each row execute function public.touch_updated_at();

create trigger admin_users_touch_updated_at
  before update on public.admin_users
  for each row execute function public.touch_updated_at();
