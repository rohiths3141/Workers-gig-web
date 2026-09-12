-- ===========================================================================
-- 0005  Finance: payments, refunds, the wallet ledger, payouts
-- ---------------------------------------------------------------------------
-- Two rules govern this file.
--
--   1. A payment only reaches SUCCESS when a trusted server has verified the
--      gateway signature. A client asserting payment_success=true is worth
--      nothing; the column gateway_signature_verified records that the check
--      actually happened, and a constraint refuses SUCCESS without it.
--
--   2. wallets.balance_minor is never assigned. It is recomputed by trigger from
--      the append-only wallet_transactions ledger, so the balance and its
--      history cannot disagree.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Payments
-- ---------------------------------------------------------------------------
create table public.payments (
  id             uuid primary key default gen_random_uuid(),
  payment_code   text not null unique,
  booking_id     uuid not null references public.bookings (id) on delete restrict,
  customer_id    uuid not null references public.customers (id) on delete restrict,

  amount_minor         bigint not null,
  platform_fee_minor   bigint not null default 0,
  worker_amount_minor  bigint not null default 0,
  material_amount_minor bigint not null default 0,
  currency       text not null default 'INR',
  status         public.payment_status not null default 'PENDING',
  method         text,

  gateway              text not null,
  gateway_order_id     text,
  gateway_payment_id   text,
  -- Proof that the server verified the gateway signature or webhook HMAC.
  gateway_signature_verified boolean not null default false,
  gateway_verified_at  timestamptz,
  -- Raw provider payload, retained for dispute handling. Never shown verbatim
  -- in the UI.
  gateway_payload      jsonb not null default '{}'::jsonb,

  -- Deduplicates retried checkout attempts and replayed webhooks.
  idempotency_key text not null unique,

  failure_code   text,
  failure_reason text,
  refunded_amount_minor bigint not null default 0,

  initiated_at   timestamptz not null default now(),
  captured_at    timestamptz,
  failed_at      timestamptz,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint payments_amount_positive check (amount_minor > 0),
  constraint payments_fees_non_negative check (
    platform_fee_minor >= 0 and worker_amount_minor >= 0
    and material_amount_minor >= 0 and refunded_amount_minor >= 0
  ),
  constraint payments_refund_within_amount check (refunded_amount_minor <= amount_minor),
  -- The central anti-spoofing invariant.
  constraint payments_success_requires_verification check (
    status not in ('SUCCESS', 'REFUNDED', 'PARTIALLY_REFUNDED')
    or (gateway_signature_verified and gateway_payment_id is not null)
  ),
  constraint payments_failure_has_reason check (
    status <> 'FAILED' or failure_reason is not null
  )
);

comment on constraint payments_success_requires_verification on public.payments is
  'A payment cannot be marked successful unless a trusted server verified the gateway signature.';

create unique index payments_gateway_payment_id_idx
  on public.payments (gateway, gateway_payment_id)
  where gateway_payment_id is not null;
create index payments_status_idx on public.payments (status, created_at desc);
create index payments_booking_idx on public.payments (booking_id);
create index payments_customer_idx on public.payments (customer_id, created_at desc);
create index payments_code_trgm_idx on public.payments using gin (payment_code gin_trgm_ops);

create trigger payments_touch_updated_at
  before update on public.payments
  for each row execute function public.touch_updated_at();

create or replace function public.assign_payment_code()
returns trigger
language plpgsql
as $$
begin
  if new.payment_code is null or length(btrim(new.payment_code)) = 0 then
    new.payment_code := 'PAY-' || to_char(now(), 'YYMMDD') || '-' ||
                        upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger payments_assign_code
  before insert on public.payments
  for each row execute function public.assign_payment_code();

-- ---------------------------------------------------------------------------
-- Refunds
-- ---------------------------------------------------------------------------
create table public.refunds (
  id              uuid primary key default gen_random_uuid(),
  payment_id      uuid not null references public.payments (id) on delete restrict,
  amount_minor    bigint not null,
  currency        text not null default 'INR',
  reason          text not null,
  status          public.payment_status not null default 'PENDING',
  gateway_refund_id text,
  gateway_payload jsonb not null default '{}'::jsonb,
  idempotency_key text not null unique,
  requested_by    uuid references public.admin_users (id) on delete set null,
  completed_at    timestamptz,
  failure_reason  text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  constraint refunds_amount_positive check (amount_minor > 0),
  constraint refunds_reason_not_blank check (length(btrim(reason)) > 0)
);

create index refunds_payment_idx on public.refunds (payment_id, created_at desc);
create index refunds_status_idx on public.refunds (status, created_at desc);

create trigger refunds_touch_updated_at
  before update on public.refunds
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Wallets
-- ---------------------------------------------------------------------------
create table public.wallets (
  id                    uuid primary key default gen_random_uuid(),
  worker_id             uuid not null unique references public.workers (id) on delete cascade,
  -- Derived. See sync_wallet_balance() below.
  balance_minor         bigint not null default 0,
  total_credited_minor  bigint not null default 0,
  total_debited_minor   bigint not null default 0,
  currency              text not null default 'INR',
  -- Set by trust and safety to stop payouts while a claim is open.
  is_frozen             boolean not null default false,
  frozen_reason         text,
  frozen_by             uuid references public.admin_users (id) on delete set null,
  last_transaction_at   timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),

  constraint wallets_totals_non_negative check (
    total_credited_minor >= 0 and total_debited_minor >= 0
  )
);

comment on column public.wallets.balance_minor is
  'Derived from wallet_transactions by trigger. Never assigned by application code.';

create index wallets_frozen_idx on public.wallets (is_frozen) where is_frozen;

create trigger wallets_touch_updated_at
  before update on public.wallets
  for each row execute function public.touch_updated_at();

-- Every worker gets a wallet the moment they exist.
create or replace function public.create_wallet_for_worker()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.wallets (worker_id)
  values (new.id)
  on conflict (worker_id) do nothing;
  return new;
end;
$$;

create trigger workers_create_wallet
  after insert on public.workers
  for each row execute function public.create_wallet_for_worker();

-- ---------------------------------------------------------------------------
-- Wallet ledger
-- ---------------------------------------------------------------------------
-- Append-only, double-entry-style signed ledger. UPDATE and DELETE are blocked
-- by trigger for every role including service_role, so a balance can be
-- corrected only by posting a compensating entry that stays visible.
create table public.wallet_transactions (
  id              uuid primary key default gen_random_uuid(),
  wallet_id       uuid not null references public.wallets (id) on delete restrict,
  worker_id       uuid not null references public.workers (id) on delete restrict,
  type            public.wallet_transaction_type not null,
  -- Signed: positive for CREDIT_*, negative for DEBIT_*. Enforced below.
  amount_minor    bigint not null,
  -- Running balance captured at insert time, for statement reconciliation.
  balance_after_minor bigint not null,
  currency        text not null default 'INR',
  description     text not null,
  -- 'BOOKING' | 'PAYMENT' | 'PAYOUT' | 'CLAIM' | 'MANUAL'
  reference_type  text,
  reference_id    uuid,
  -- Makes every ledger write safely retryable.
  idempotency_key text not null unique,
  created_by_type public.actor_type not null default 'SYSTEM',
  created_by_id   uuid,
  reason          text,
  created_at      timestamptz not null default now(),

  constraint wallet_transactions_amount_nonzero check (amount_minor <> 0),
  constraint wallet_transactions_sign_matches_type check (
    (type::text like 'CREDIT%' and amount_minor > 0)
    or (type::text like 'DEBIT%' and amount_minor < 0)
  )
);

create index wallet_transactions_wallet_idx on public.wallet_transactions (wallet_id, created_at desc);
create index wallet_transactions_worker_idx on public.wallet_transactions (worker_id, created_at desc);
create index wallet_transactions_reference_idx on public.wallet_transactions (reference_type, reference_id);

-- Balance is a projection of the ledger, maintained inside the same transaction
-- as the insert, under a row lock on the wallet.
create or replace function public.sync_wallet_balance()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  update public.wallets
  set balance_minor        = balance_minor + new.amount_minor,
      total_credited_minor = total_credited_minor + greatest(new.amount_minor, 0),
      total_debited_minor  = total_debited_minor + greatest(-new.amount_minor, 0),
      last_transaction_at  = new.created_at
  where id = new.wallet_id;

  return null;
end;
$$;

create trigger wallet_transactions_sync_balance
  after insert on public.wallet_transactions
  for each row execute function public.sync_wallet_balance();

-- Immutability guard.
create or replace function public.reject_ledger_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception 'IMMUTABLE: % on % is not permitted; post a compensating entry instead',
    tg_op, tg_table_name
    using errcode = '42501';
end;
$$;

create trigger wallet_transactions_immutable
  before update or delete on public.wallet_transactions
  for each row execute function public.reject_ledger_mutation();

-- ---------------------------------------------------------------------------
-- Payouts
-- ---------------------------------------------------------------------------
create table public.payouts (
  id              uuid primary key default gen_random_uuid(),
  payout_code     text not null unique,
  worker_id       uuid not null references public.workers (id) on delete restrict,
  wallet_id       uuid not null references public.wallets (id) on delete restrict,
  amount_minor    bigint not null,
  currency        text not null default 'INR',
  status          public.payout_status not null default 'REQUESTED',

  method          text not null default 'BANK_TRANSFER',
  -- Only the masked tail is stored here. Full bank details live with the
  -- disbursement provider, never in this table.
  account_last4   text,
  account_holder_name text,
  bank_name       text,

  gateway         text,
  gateway_payout_id text,
  gateway_payload jsonb not null default '{}'::jsonb,
  -- Guarantees a double-clicked approval disburses once.
  idempotency_key text not null unique,

  requested_at    timestamptz not null default now(),
  decided_by      uuid references public.admin_users (id) on delete set null,
  decided_at      timestamptz,
  decision_reason text,
  processed_at    timestamptz,
  completed_at    timestamptz,
  failure_reason  text,
  -- Ledger entry that actually moved the money out of the wallet.
  ledger_transaction_id uuid references public.wallet_transactions (id) on delete set null,

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  constraint payouts_amount_positive check (amount_minor > 0),
  constraint payouts_rejection_has_reason check (
    status <> 'REJECTED' or (decision_reason is not null and length(btrim(decision_reason)) > 0)
  ),
  constraint payouts_decision_attributed check (
    status not in ('PROCESSING', 'COMPLETED', 'REJECTED') or decided_by is not null
  ),
  constraint payouts_account_last4_format check (
    account_last4 is null or account_last4 ~ '^[0-9]{4}$'
  )
);

create index payouts_status_idx on public.payouts (status, requested_at desc);
create index payouts_worker_idx on public.payouts (worker_id, requested_at desc);
create index payouts_pending_idx on public.payouts (requested_at) where status = 'REQUESTED';

create trigger payouts_touch_updated_at
  before update on public.payouts
  for each row execute function public.touch_updated_at();

create or replace function public.assign_payout_code()
returns trigger
language plpgsql
as $$
begin
  if new.payout_code is null or length(btrim(new.payout_code)) = 0 then
    new.payout_code := 'PO-' || to_char(now(), 'YYMMDD') || '-' ||
                       upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger payouts_assign_code
  before insert on public.payouts
  for each row execute function public.assign_payout_code();

-- A worker may only have one payout in flight at a time.
create unique index payouts_one_in_flight_per_worker
  on public.payouts (worker_id)
  where status in ('REQUESTED', 'PROCESSING');
