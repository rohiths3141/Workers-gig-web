-- ===========================================================================
-- 0006  Trust and safety: damage claims and the support desk
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Damage claims
-- ---------------------------------------------------------------------------
-- A claim is a request by a customer for redress after a job. Nothing here is
-- automatic: every status change is a deliberate decision made by an
-- administrator holding the matching permission, recorded in claim_events and
-- in the audit log. There is no auto-approval path.
create table public.claims (
  id             uuid primary key default gen_random_uuid(),
  claim_code     text not null unique,
  booking_id     uuid not null references public.bookings (id) on delete restrict,
  customer_id    uuid not null references public.customers (id) on delete restrict,
  worker_id      uuid references public.workers (id) on delete restrict,

  type           public.claim_type not null,
  status         public.claim_status not null default 'SUBMITTED',
  incident_at    timestamptz not null,
  description    text not null,

  amount_claimed_minor  bigint not null,
  amount_approved_minor bigint,
  currency       text not null default 'INR',

  assigned_to    uuid references public.admin_users (id) on delete set null,
  assigned_at    timestamptz,

  -- Populated when a decision is taken. decided_by is mandatory for every
  -- terminal status, enforced below.
  decided_by     uuid references public.admin_users (id) on delete set null,
  decided_at     timestamptz,
  decision_note  text,
  rejection_reason text,
  info_requested text,

  -- The platform is not the insurer. If the loss was routed to a provider, the
  -- provider's own decision is recorded separately and is not implied by the
  -- platform status above.
  insurance_policy_id uuid references public.insurance_policies (id) on delete set null,
  insurer_reference   text,
  insurer_decision    text,
  insurer_decided_at  timestamptz,

  -- Recovery from the worker wallet, when that was the agreed outcome.
  recovery_transaction_id uuid,

  closed_at      timestamptz,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint claims_amount_positive check (amount_claimed_minor > 0),
  constraint claims_approved_within_claimed check (
    amount_approved_minor is null
    or (amount_approved_minor >= 0 and amount_approved_minor <= amount_claimed_minor)
  ),
  -- An approval must carry an amount; a partial approval must be strictly less.
  constraint claims_approval_has_amount check (
    status not in ('APPROVED', 'PARTIALLY_APPROVED') or amount_approved_minor is not null
  ),
  constraint claims_partial_is_partial check (
    status <> 'PARTIALLY_APPROVED'
    or (amount_approved_minor > 0 and amount_approved_minor < amount_claimed_minor)
  ),
  constraint claims_rejection_has_reason check (
    status <> 'REJECTED' or (rejection_reason is not null and length(btrim(rejection_reason)) > 0)
  ),
  constraint claims_decision_attributed check (
    status not in ('APPROVED', 'PARTIALLY_APPROVED', 'REJECTED') or decided_by is not null
  ),
  constraint claims_incident_not_future check (incident_at <= now())
);

create index claims_status_idx on public.claims (status, created_at desc);
create index claims_booking_idx on public.claims (booking_id);
create index claims_customer_idx on public.claims (customer_id, created_at desc);
create index claims_worker_idx on public.claims (worker_id, created_at desc);
create index claims_assigned_idx on public.claims (assigned_to) where status in ('UNDER_REVIEW', 'MORE_INFORMATION_REQUIRED');
create index claims_open_idx on public.claims (created_at)
  where status in ('SUBMITTED', 'UNDER_REVIEW', 'MORE_INFORMATION_REQUIRED');

create trigger claims_touch_updated_at
  before update on public.claims
  for each row execute function public.touch_updated_at();

create or replace function public.assign_claim_code()
returns trigger
language plpgsql
as $$
begin
  if new.claim_code is null or length(btrim(new.claim_code)) = 0 then
    new.claim_code := 'CLM-' || to_char(now(), 'YYMMDD') || '-' ||
                      upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger claims_assign_code
  before insert on public.claims
  for each row execute function public.assign_claim_code();

-- Append-only decision history for a claim, rendered as the admin timeline.
create table public.claim_events (
  id           bigint generated always as identity primary key,
  claim_id     uuid not null references public.claims (id) on delete cascade,
  from_status  public.claim_status,
  to_status    public.claim_status,
  actor_type   public.actor_type not null,
  actor_admin_id uuid references public.admin_users (id) on delete set null,
  note         text,
  metadata     jsonb not null default '{}'::jsonb,
  created_at   timestamptz not null default now()
);

create index claim_events_claim_idx on public.claim_events (claim_id, created_at);

-- ---------------------------------------------------------------------------
-- Support desk
-- ---------------------------------------------------------------------------
create table public.support_tickets (
  id             uuid primary key default gen_random_uuid(),
  ticket_code    text not null unique,
  subject        text not null,
  category       public.support_category not null default 'OTHER',
  priority       public.support_priority not null default 'MEDIUM',
  status         public.support_status not null default 'OPEN',

  -- Exactly one requester, matching requester_type. Enforced below.
  requester_type public.actor_type not null,
  customer_id    uuid references public.customers (id) on delete set null,
  worker_id      uuid references public.workers (id) on delete set null,

  booking_id     uuid references public.bookings (id) on delete set null,
  claim_id       uuid references public.claims (id) on delete set null,

  assigned_admin_id uuid references public.admin_users (id) on delete set null,
  assigned_at    timestamptz,

  first_response_at timestamptz,
  last_message_at   timestamptz not null default now(),
  resolved_at    timestamptz,
  closed_at      timestamptz,
  resolution_note text,

  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint support_requester_matches_type check (
    (requester_type = 'CUSTOMER' and customer_id is not null and worker_id is null)
    or (requester_type = 'WORKER' and worker_id is not null and customer_id is null)
  ),
  constraint support_subject_not_blank check (length(btrim(subject)) > 0)
);

create index support_tickets_status_idx on public.support_tickets (status, priority desc, created_at desc);
create index support_tickets_assigned_idx on public.support_tickets (assigned_admin_id, status);
create index support_tickets_customer_idx on public.support_tickets (customer_id, created_at desc);
create index support_tickets_worker_idx on public.support_tickets (worker_id, created_at desc);
create index support_tickets_open_idx on public.support_tickets (last_message_at desc)
  where status in ('OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER');
create index support_tickets_code_trgm_idx on public.support_tickets using gin (ticket_code gin_trgm_ops);

create trigger support_tickets_touch_updated_at
  before update on public.support_tickets
  for each row execute function public.touch_updated_at();

create or replace function public.assign_ticket_code()
returns trigger
language plpgsql
as $$
begin
  if new.ticket_code is null or length(btrim(new.ticket_code)) = 0 then
    new.ticket_code := 'TKT-' || to_char(now(), 'YYMMDD') || '-' ||
                       upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger support_tickets_assign_code
  before insert on public.support_tickets
  for each row execute function public.assign_ticket_code();

-- Threaded conversation. is_internal notes are visible to staff only and are
-- filtered out by the RLS policy that serves the customer and worker apps.
create table public.support_messages (
  id             uuid primary key default gen_random_uuid(),
  ticket_id      uuid not null references public.support_tickets (id) on delete cascade,
  author_type    public.actor_type not null,
  author_admin_id uuid references public.admin_users (id) on delete set null,
  author_profile_id uuid references public.profiles (id) on delete set null,
  body           text not null,
  is_internal    boolean not null default false,
  created_at     timestamptz not null default now(),

  constraint support_messages_body_not_blank check (length(btrim(body)) > 0),
  constraint support_messages_admin_author check (
    author_type <> 'ADMIN' or author_admin_id is not null
  ),
  constraint support_messages_internal_is_admin check (
    not is_internal or author_type = 'ADMIN'
  )
);

create index support_messages_ticket_idx on public.support_messages (ticket_id, created_at);

-- Keep the ticket's activity clock accurate without a second round trip.
create or replace function public.touch_ticket_on_message()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  update public.support_tickets
  set last_message_at = new.created_at,
      first_response_at = case
        when first_response_at is null and new.author_type = 'ADMIN' and not new.is_internal
        then new.created_at
        else first_response_at
      end
  where id = new.ticket_id;
  return null;
end;
$$;

create trigger support_messages_touch_ticket
  after insert on public.support_messages
  for each row execute function public.touch_ticket_on_message();
