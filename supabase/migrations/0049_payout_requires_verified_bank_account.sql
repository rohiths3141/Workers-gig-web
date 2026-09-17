-- ===========================================================================
-- 0049  Payouts require a verified bank account
-- ---------------------------------------------------------------------------
-- 0047 added the BANK_ACCOUNT check, but request_payout() never looked at it,
-- so a worker could request a withdrawal with no account on file, and the
-- payouts table's account_last4 / account_holder_name / bank_name columns were
-- never filled in. The payout now records which verified account it is for,
-- so an admin deciding it can see where the money is going.
-- ===========================================================================

create or replace function public.request_payout(
  p_amount_minor bigint,
  p_idempotency_key text
)
returns public.payouts
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker_id uuid := public.current_worker_id();
  v_wallet    public.wallets%rowtype;
  v_minimum   bigint;
  v_payout    public.payouts%rowtype;
  v_bank      jsonb;
begin
  if v_worker_id is null then
    raise exception 'FORBIDDEN: only a worker may request a payout' using errcode = '42501';
  end if;

  select * into v_payout from public.payouts where idempotency_key = p_idempotency_key;
  if found then
    return v_payout;
  end if;

  select details into v_bank
  from public.worker_verifications
  where worker_id = v_worker_id
    and type = 'BANK_ACCOUNT'
    and status = 'APPROVED'
    and (expires_at is null or expires_at > now());

  if v_bank is null then
    raise exception 'INVALID: add a bank account and wait for it to be verified before withdrawing'
      using errcode = '23514';
  end if;

  select * into v_wallet from public.wallets where worker_id = v_worker_id for update;

  if v_wallet.is_frozen then
    raise exception 'FORBIDDEN: this wallet is on hold; contact support' using errcode = '42501';
  end if;

  v_minimum := coalesce(
    (select value::bigint from public.platform_settings where key = 'payout.minimum_amount_minor'), 0);

  if p_amount_minor < v_minimum then
    raise exception 'INVALID: the minimum payout is % minor units', v_minimum using errcode = '23514';
  end if;

  if p_amount_minor > v_wallet.balance_minor then
    raise exception 'INSUFFICIENT_FUNDS: requested % but the wallet holds %',
      p_amount_minor, v_wallet.balance_minor using errcode = '23514';
  end if;

  insert into public.payouts (
    worker_id, wallet_id, amount_minor, currency, idempotency_key,
    account_last4, account_holder_name, bank_name
  )
  values (
    v_worker_id, v_wallet.id, p_amount_minor, v_wallet.currency, p_idempotency_key,
    v_bank ->> 'account_last4', v_bank ->> 'account_holder_name', v_bank ->> 'bank_name'
  )
  returning * into v_payout;

  return v_payout;
end;
$$;

grant execute on function public.request_payout(bigint, text) to authenticated;
