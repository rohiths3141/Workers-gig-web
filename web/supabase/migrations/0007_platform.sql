-- ===========================================================================
-- 0007  Platform: notifications, audit trail, settings, contact messages
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Notifications
-- ---------------------------------------------------------------------------
-- A row is the record of an attempt to deliver a message over one channel.
-- status advances only on evidence: SENT when the provider accepted the
-- message, DELIVERED only when a provider webhook says so. Nothing in the
-- application invents a delivery result.
create table public.notifications (
  id             uuid primary key default gen_random_uuid(),
  recipient_type public.actor_type not null,
  -- Platform profile of the recipient. Kept alongside the Firebase UID so a
  -- push token lookup does not need a join back through profiles.
  recipient_profile_id uuid references public.profiles (id) on delete cascade,
  recipient_firebase_uid text,

  channel        public.notification_channel not null,
  template_key   text not null,
  title          text not null,
  body           text not null,
  -- Deep link target inside the Flutter apps, e.g. booking id.
  payload        jsonb not null default '{}'::jsonb,

  status         public.notification_status not null default 'QUEUED',
  provider       text,
  provider_message_id text,
  -- Deduplicates retries of the same logical notification.
  idempotency_key text not null unique,

  queued_at      timestamptz not null default now(),
  sent_at        timestamptz,
  delivered_at   timestamptz,
  failed_at      timestamptz,
  failure_reason text,
  attempt_count  integer not null default 0,

  -- For IN_APP notifications only.
  read_at        timestamptz,

  created_by_type public.actor_type not null default 'SYSTEM',
  created_by_admin_id uuid references public.admin_users (id) on delete set null,
  created_at     timestamptz not null default now(),

  constraint notifications_sent_has_timestamp check (
    status not in ('SENT', 'DELIVERED') or sent_at is not null
  ),
  constraint notifications_delivered_has_evidence check (
    status <> 'DELIVERED' or (delivered_at is not null and provider_message_id is not null)
  ),
  constraint notifications_failed_has_reason check (
    status <> 'FAILED' or failure_reason is not null
  ),
  constraint notifications_attempts_non_negative check (attempt_count >= 0)
);

comment on constraint notifications_delivered_has_evidence on public.notifications is
  'DELIVERED requires a provider message id and timestamp, so the status cannot be fabricated.';

create index notifications_recipient_idx on public.notifications (recipient_profile_id, created_at desc);
create index notifications_status_idx on public.notifications (status, created_at desc);
create index notifications_channel_idx on public.notifications (channel, status);
create index notifications_unread_idx on public.notifications (recipient_profile_id, created_at desc)
  where channel = 'IN_APP' and read_at is null;
create index notifications_queue_idx on public.notifications (queued_at)
  where status in ('QUEUED', 'SENDING');

-- Device push tokens, registered by the Flutter apps through a trusted endpoint.
create table public.push_tokens (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid not null references public.profiles (id) on delete cascade,
  firebase_uid text not null,
  token        text not null unique,
  platform     text not null,
  device_label text,
  is_active    boolean not null default true,
  last_seen_at timestamptz not null default now(),
  created_at   timestamptz not null default now(),

  constraint push_tokens_platform_valid check (platform in ('ANDROID', 'IOS', 'WEB'))
);

create index push_tokens_profile_idx on public.push_tokens (profile_id) where is_active;

-- ---------------------------------------------------------------------------
-- Audit trail
-- ---------------------------------------------------------------------------
-- Append-only from every application path. UPDATE and DELETE are refused by
-- trigger for all roles including service_role, so the trail cannot be
-- rewritten to hide an action — only added to.
create table public.audit_logs (
  id             bigint generated always as identity primary key,

  actor_type     public.actor_type not null default 'ADMIN',
  actor_admin_id uuid references public.admin_users (id) on delete set null,
  -- Denormalised so the trail stays readable after an administrator is removed.
  actor_email    text,
  actor_role     public.admin_role,
  actor_firebase_uid text,

  action         text not null,
  resource_type  text not null,
  resource_id    text,

  -- Snapshots of only the fields that changed, with sensitive values redacted
  -- before they are written.
  before_state   jsonb,
  after_state    jsonb,
  -- Mandatory for sensitive actions; enforced by the callers in 0010.
  reason         text,

  ip_address     inet,
  user_agent     text,
  request_id     text,

  -- 'SUCCESS' | 'FAILURE'. Denied attempts are recorded too — an authorization
  -- failure on a sensitive resource is exactly what an investigation needs.
  outcome        text not null default 'SUCCESS',
  error_message  text,

  created_at     timestamptz not null default now(),

  constraint audit_logs_action_not_blank check (length(btrim(action)) > 0),
  constraint audit_logs_outcome_valid check (outcome in ('SUCCESS', 'FAILURE'))
);

create index audit_logs_actor_idx on public.audit_logs (actor_admin_id, created_at desc);
create index audit_logs_resource_idx on public.audit_logs (resource_type, resource_id, created_at desc);
create index audit_logs_action_idx on public.audit_logs (action, created_at desc);
create index audit_logs_created_idx on public.audit_logs (created_at desc);
create index audit_logs_failures_idx on public.audit_logs (created_at desc) where outcome = 'FAILURE';

create or replace function public.reject_audit_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception 'IMMUTABLE: the audit trail is append-only (% attempted on %)',
    tg_op, tg_table_name
    using errcode = '42501';
end;
$$;

create trigger audit_logs_immutable
  before update or delete on public.audit_logs
  for each row execute function public.reject_audit_mutation();

-- The single writer used by every privileged operation in 0010.
create or replace function public.write_audit_log(
  p_action        text,
  p_resource_type text,
  p_resource_id   text,
  p_before        jsonb default null,
  p_after         jsonb default null,
  p_reason        text default null,
  p_outcome       text default 'SUCCESS',
  p_error         text default null
)
returns bigint
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin   public.admin_users%rowtype;
  v_headers jsonb;
  v_id      bigint;
begin
  select * into v_admin
  from public.admin_users
  where id = public.current_admin_id();

  -- PostgREST exposes the incoming request headers here. The trusted backend
  -- populates x-client-ip and x-request-id from the real request before calling.
  -- Treated as advisory context for an investigation, never as an authorization
  -- input, since a direct client could set these itself.
  begin
    v_headers := nullif(current_setting('request.headers', true), '')::jsonb;
  exception when others then
    v_headers := null;
  end;

  insert into public.audit_logs (
    actor_type, actor_admin_id, actor_email, actor_role, actor_firebase_uid,
    action, resource_type, resource_id,
    before_state, after_state, reason,
    ip_address, user_agent, request_id,
    outcome, error_message
  )
  values (
    case when v_admin.id is not null then 'ADMIN' else 'SYSTEM' end,
    v_admin.id, v_admin.email, v_admin.role, v_admin.firebase_uid,
    p_action, p_resource_type, p_resource_id,
    p_before, p_after, p_reason,
    -- inet cast is tolerant: a malformed value records NULL rather than
    -- aborting the business transaction the audit entry belongs to.
    (select case
       when v_headers ->> 'x-client-ip' ~ '^[0-9a-fA-F:.]+$'
       then (v_headers ->> 'x-client-ip')::inet
       else null
     end),
    left(v_headers ->> 'user-agent', 512),
    v_headers ->> 'x-request-id',
    p_outcome, p_error
  )
  returning id into v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Platform settings
-- ---------------------------------------------------------------------------
-- Operational knobs only. No secret, key, or credential is ever stored here —
-- those live in the deployment environment.
create table public.platform_settings (
  key          text primary key,
  value        jsonb not null,
  description  text not null,
  -- Safe to read from the public website (e.g. the support email).
  is_public    boolean not null default false,
  updated_by   uuid references public.admin_users (id) on delete set null,
  updated_at   timestamptz not null default now(),

  constraint platform_settings_key_format check (key ~ '^[a-z][a-z0-9_.]*$')
);

insert into public.platform_settings (key, value, description, is_public) values
  ('platform.commission_percent', '15'::jsonb,
   'Platform commission on the labour component of a completed job, in percent.', false),
  ('payout.minimum_amount_minor', '50000'::jsonb,
   'Smallest payout a worker may request, in minor units.', false),
  ('payout.cooling_period_hours', '24'::jsonb,
   'Hours a job earning is held before it becomes withdrawable.', false),
  ('matching.max_candidates', '10'::jsonb,
   'Maximum number of workers scored and offered per booking.', false),
  ('matching.max_radius_km', '25'::jsonb,
   'Hard distance ceiling for the matching engine.', false),
  ('booking.arrival_code_required', 'true'::jsonb,
   'Require the customer arrival code before work may start.', false),
  ('verification.certificate_validity_months', '60'::jsonb,
   'How long an approved qualification stays valid before re-verification.', false),
  ('verification.background_check_validity_months', '24'::jsonb,
   'How long an approved background check stays valid.', false),
  ('support.first_response_target_minutes', '120'::jsonb,
   'Operational target for a first human response on a support ticket.', false);

create trigger platform_settings_touch_updated_at
  before update on public.platform_settings
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Contact messages from the public website
-- ---------------------------------------------------------------------------
create table public.contact_messages (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  email        citext not null,
  phone        text,
  subject      text not null,
  message      text not null,
  status       public.contact_message_status not null default 'NEW',

  -- Salted hash, not the address itself: enough to rate-limit a source without
  -- retaining an identifier for everyone who used the contact form.
  ip_hash      text,
  user_agent   text,

  handled_by   uuid references public.admin_users (id) on delete set null,
  handled_at   timestamptz,
  internal_note text,
  created_at   timestamptz not null default now(),

  constraint contact_messages_name_length check (length(btrim(name)) between 2 and 120),
  constraint contact_messages_subject_length check (length(btrim(subject)) between 3 and 200),
  constraint contact_messages_message_length check (length(btrim(message)) between 10 and 5000),
  constraint contact_messages_email_format check (email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$')
);

create index contact_messages_status_idx on public.contact_messages (status, created_at desc);
create index contact_messages_rate_idx on public.contact_messages (ip_hash, created_at desc)
  where ip_hash is not null;
