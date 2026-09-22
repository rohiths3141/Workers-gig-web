-- ===========================================================================
-- 0036  Pluggable third-party KYC / background-check provider adapter
-- ===========================================================================
-- Design goal: a verification decision must never be something a worker (or
-- their client app) can produce. decide_verification() already enforces that
-- for human review. This migration adds a second, parallel decision path for
-- an *automated* provider, with the same guarantee: only a trusted server
-- process — never the authenticated worker role — can call it.
--
-- Pipeline:
--   1. Worker submits documents -> worker_submit_verification() (unchanged,
--      already real) -> case reaches PENDING.
--   2. A trigger on worker_verifications fires a webhook (via pg_net) to an
--      Edge Function, passing only the case id, worker id, type and details.
--   3. The Edge Function (supabase/functions/kyc-provider) calls a pluggable
--      provider adapter — today a documented mock, swappable later for a real
--      KYC/BGV vendor — and decides APPROVED or REJECTED.
--   4. The Edge Function calls record_provider_kyc_result() using the
--      project's service_role key. That RPC is not reachable by `anon` or
--      `authenticated` at all, only by service_role, so no client (worker,
--      customer or otherwise) can ever call it.
--   5. sync_worker_verification_flags() (from 0010) picks up the status
--      change exactly as it would for a human decision.
--
-- If the webhook is not yet configured (kyc_webhook_url unset), the trigger is
-- a no-op and the case simply waits for a human reviewer via
-- decide_verification() — the automated path is additive, never required.
-- ===========================================================================

create extension if not exists pg_net with schema extensions;

-- ---------------------------------------------------------------------------
-- Server-only configuration. Never granted to anon/authenticated: this is
-- read only by SECURITY DEFINER functions running as the table owner.
-- ---------------------------------------------------------------------------
create table if not exists public.integration_settings (
  key        text primary key,
  value      text,
  updated_at timestamptz not null default now()
);

comment on table public.integration_settings is
  'Server-only integration config (e.g. the KYC provider webhook URL and its bearer key). Not readable or writable by anon/authenticated. Populate after deploying supabase/functions/kyc-provider, e.g.:
     update public.integration_settings set value = ''https://<project>.functions.supabase.co/kyc-provider'' where key = ''kyc_webhook_url'';
     update public.integration_settings set value = ''<service_role_key>''                                where key = ''kyc_webhook_service_key'';';

insert into public.integration_settings (key, value) values
  ('kyc_webhook_url', null),
  ('kyc_webhook_service_key', null)
on conflict (key) do nothing;

revoke all on public.integration_settings from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Allow a provider-attributed decision alongside a human-reviewer one.
-- ---------------------------------------------------------------------------
alter table public.worker_verifications
  drop constraint if exists worker_verifications_decision_attributed;

alter table public.worker_verifications
  add constraint worker_verifications_decision_attributed check (
    status not in ('APPROVED', 'REJECTED')
    or reviewed_by is not null
    or provider is not null
  );

-- ---------------------------------------------------------------------------
-- record_provider_kyc_result: the only way an automated decision is written.
-- ---------------------------------------------------------------------------
create or replace function public.record_provider_kyc_result(
  p_verification_id    uuid,
  p_decision           text,   -- APPROVED | REJECTED
  p_provider           text,
  p_provider_reference text default null,
  p_raw_response       jsonb default '{}'::jsonb,
  p_rejection_reason   text default null
)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_case   public.worker_verifications%rowtype;
  v_status public.verification_status;
begin
  if p_decision not in ('APPROVED', 'REJECTED') then
    raise exception 'INVALID: unknown provider decision %', p_decision
      using errcode = '23514';
  end if;

  if p_provider is null or length(btrim(p_provider)) = 0 then
    raise exception 'INVALID: provider name is required' using errcode = '23514';
  end if;

  select * into v_case
  from public.worker_verifications
  where id = p_verification_id
  for update;

  if not found then
    raise exception 'NOT_FOUND: verification case % does not exist', p_verification_id
      using errcode = 'P0002';
  end if;

  if v_case.status in ('APPROVED', 'REJECTED') then
    raise exception 'CONFLICT: verification case is already %', v_case.status
      using errcode = '23505';
  end if;

  if p_decision = 'REJECTED' and (p_rejection_reason is null or length(btrim(p_rejection_reason)) < 5) then
    raise exception 'INVALID: a rejection requires a reason of at least 5 characters'
      using errcode = '23514';
  end if;

  v_status := p_decision::public.verification_status;

  update public.worker_verifications
  set status             = v_status,
      reviewed_at        = now(),
      provider           = p_provider,
      provider_reference = coalesce(p_provider_reference, provider_reference),
      details            = details || jsonb_build_object('provider_raw_response', p_raw_response),
      rejection_reason   = case when p_decision = 'REJECTED' then p_rejection_reason else null end
  where id = p_verification_id
  returning * into v_case;

  perform public.write_audit_log(
    'verification.provider_' || lower(p_decision),
    'worker_verification',
    p_verification_id::text,
    jsonb_build_object('status', 'PENDING'),
    jsonb_build_object('status', v_status, 'provider', p_provider),
    p_rejection_reason
  );

  return v_case;
end;
$$;

-- Deliberately no grant to anon/authenticated: reachable only via the
-- Edge Function's service_role connection, which bypasses grants entirely.
revoke all on function
  public.record_provider_kyc_result(uuid, text, text, text, jsonb, text)
from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Trigger: notify the provider webhook when a case reaches PENDING.
-- ---------------------------------------------------------------------------
create or replace function public.trigger_kyc_provider_webhook()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, pg_temp
as $$
declare
  v_url text;
  v_key text;
begin
  select value into v_url from public.integration_settings where key = 'kyc_webhook_url';
  select value into v_key from public.integration_settings where key = 'kyc_webhook_service_key';

  -- Not configured yet: leave the case for a human reviewer, do not fail.
  if v_url is null or v_key is null then
    return new;
  end if;

  begin
    perform net.http_post(
      url     := v_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || v_key
      ),
      body := jsonb_build_object(
        'verification_id', new.id,
        'worker_id',       new.worker_id,
        'type',            new.type,
        'details',         new.details
      )
    );
  exception when others then
    -- A webhook outage must never block a worker's submission.
    raise warning 'kyc provider webhook call failed: %', sqlerrm;
  end;

  return new;
end;
$$;

drop trigger if exists worker_verifications_notify_provider on public.worker_verifications;

create trigger worker_verifications_notify_provider
  after insert or update of status on public.worker_verifications
  for each row
  when (new.status = 'PENDING' and new.type in ('IDENTITY_KYC', 'BACKGROUND_CHECK'))
  execute function public.trigger_kyc_provider_webhook();
