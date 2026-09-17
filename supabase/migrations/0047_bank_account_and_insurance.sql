-- ===========================================================================
-- 0047  Bank account (worker submits, admin verifies) and insurance (admin
--       records)
-- ---------------------------------------------------------------------------
-- Both checks existed as verification types but neither had a working path:
--
--   BANK_ACCOUNT  the worker app had no way to enter details, and the generic
--                 worker_submit_verification() demands an uploaded document,
--                 which a bank account does not have.
--   INSURANCE     the admin Insurance page could only list policies; nothing
--                 could record one, so no worker could ever be insured.
--
-- worker_submit_bank_account() sends validated details to PENDING, where an
-- admin decides the case in the verification queue with decide_verification().
-- admin_record_insurance() records a policy and approves the INSURANCE case in
-- one transaction, expiring when the policy does.
-- ===========================================================================

create or replace function public.worker_submit_bank_account(
  p_account_holder_name text,
  p_account_number      text,
  p_ifsc                text,
  p_bank_name           text default null
)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker  public.workers%rowtype;
  v_case    public.worker_verifications%rowtype;
  v_holder  text := btrim(coalesce(p_account_holder_name, ''));
  v_number  text := regexp_replace(coalesce(p_account_number, ''), '\s', '', 'g');
  v_ifsc    text := upper(btrim(coalesce(p_ifsc, '')));
begin
  v_worker := public.require_current_worker();

  if length(v_holder) < 2 then
    raise exception 'INVALID: enter the account holder name as it appears on the account'
      using errcode = '23514';
  end if;

  if v_number !~ '^[0-9]{9,18}$' then
    raise exception 'INVALID: an account number is 9 to 18 digits' using errcode = '23514';
  end if;

  if v_ifsc !~ '^[A-Z]{4}0[A-Z0-9]{6}$' then
    raise exception 'INVALID: enter a valid 11-character IFSC code' using errcode = '23514';
  end if;

  select * into v_case
  from public.worker_verifications
  where worker_id = v_worker.id and type = 'BANK_ACCOUNT'
  for update;

  if found and v_case.status in ('PENDING', 'UNDER_REVIEW') then
    raise exception 'CONFLICT: your bank account is already with our team for review'
      using errcode = '23505';
  end if;

  -- An approved account may be replaced: submitting new details sends the
  -- case back to review, so payouts never go to an unverified account.
  insert into public.worker_verifications (worker_id, type, status, details, submitted_at)
  values (
    v_worker.id, 'BANK_ACCOUNT', 'PENDING',
    jsonb_build_object(
      'account_holder_name', v_holder,
      'account_number',      v_number,
      'account_last4',       right(v_number, 4),
      'ifsc',                v_ifsc,
      'bank_name',           nullif(btrim(coalesce(p_bank_name, '')), '')
    ),
    now()
  )
  on conflict (worker_id, type) do update
    set status           = 'PENDING',
        details          = excluded.details,
        submitted_at     = now(),
        reviewed_by      = null,
        reviewed_at      = null,
        expires_at       = null,
        decision_note    = null,
        rejection_reason = null,
        info_requested   = null
  returning * into v_case;

  return v_case;
end;
$$;

revoke all on function public.worker_submit_bank_account(text, text, text, text) from public, anon;
grant execute on function public.worker_submit_bank_account(text, text, text, text) to authenticated;


create or replace function public.admin_record_insurance(
  p_worker_id             uuid,
  p_provider_name         text,
  p_policy_number         text,
  p_coverage_amount_minor bigint,
  p_start_date            date,
  p_end_date              date,
  p_premium_amount_minor  bigint default null,
  p_notes                 text default null
)
returns public.insurance_policies
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_admin_id uuid;
  v_policy   public.insurance_policies%rowtype;
  v_status   public.insurance_status;
begin
  v_admin_id := public.require_permission('insurance.update');

  if not exists (select 1 from public.workers where id = p_worker_id) then
    raise exception 'NOT_FOUND: no such worker' using errcode = 'P0002';
  end if;

  if length(btrim(coalesce(p_provider_name, ''))) < 2
     or length(btrim(coalesce(p_policy_number, ''))) < 3 then
    raise exception 'INVALID: enter the insurer and the policy number' using errcode = '23514';
  end if;

  if p_coverage_amount_minor is null or p_coverage_amount_minor <= 0 then
    raise exception 'INVALID: coverage must be greater than zero' using errcode = '23514';
  end if;

  if p_start_date is null or p_end_date is null or p_end_date <= p_start_date then
    raise exception 'INVALID: the policy must end after it starts' using errcode = '23514';
  end if;

  if p_end_date < current_date then
    raise exception 'INVALID: that policy has already ended' using errcode = '23514';
  end if;

  v_status := case when p_start_date <= current_date then 'ACTIVE' else 'PENDING' end::public.insurance_status;

  insert into public.insurance_policies (
    worker_id, provider_name, policy_number, coverage_amount_minor,
    premium_amount_minor, start_date, end_date, status, notes, recorded_by
  )
  values (
    p_worker_id, btrim(p_provider_name), btrim(p_policy_number), p_coverage_amount_minor,
    p_premium_amount_minor, p_start_date, p_end_date, v_status,
    nullif(btrim(coalesce(p_notes, '')), ''), v_admin_id
  )
  returning * into v_policy;

  -- The INSURANCE check is what workers.is_insured is derived from; it lapses
  -- with the policy.
  insert into public.worker_verifications (
    worker_id, type, status, details, submitted_at, reviewed_by, reviewed_at, expires_at
  )
  values (
    p_worker_id, 'INSURANCE', 'APPROVED',
    jsonb_build_object(
      'insurance_policy_id', v_policy.id,
      'provider_name',       v_policy.provider_name,
      'policy_number',       v_policy.policy_number
    ),
    now(), v_admin_id, now(), (p_end_date + 1)::timestamptz
  )
  on conflict (worker_id, type) do update
    set status           = 'APPROVED',
        details          = excluded.details,
        submitted_at     = now(),
        reviewed_by      = v_admin_id,
        reviewed_at      = now(),
        expires_at       = excluded.expires_at,
        rejection_reason = null,
        info_requested   = null;

  perform public.write_audit_log(
    'insurance.record',
    'insurance_policy',
    v_policy.id::text,
    null,
    jsonb_build_object(
      'worker_id', p_worker_id,
      'provider_name', v_policy.provider_name,
      'policy_number', v_policy.policy_number,
      'end_date', p_end_date,
      'status', v_status
    ),
    p_notes
  );

  return v_policy;
end;
$$;

revoke all on function public.admin_record_insurance(uuid, text, text, bigint, date, date, bigint, text) from public, anon;
grant execute on function public.admin_record_insurance(uuid, text, text, bigint, date, date, bigint, text) to authenticated;
