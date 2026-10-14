-- The worker app's "What you can do" onboarding step ticked itself.
--
-- The step counted as done once the worker had any row in worker_services,
-- and worker_set_primary_service inserts one. So choosing a main trade
-- finished the next step too, before the worker had ever seen it, and the
-- step was never really asked.
--
-- Record the moment the worker actually reviews their trade list instead.
-- It is stamped by an RPC rather than written through the column grant: the
-- server sets the time, and refuses while the worker has no trade at all.

alter table public.workers
  add column if not exists trades_confirmed_at timestamptz;

-- Everyone who already has a trade has been through the old flow. Without
-- this, every worker who finished onboarding before today would be sent back
-- to it on their next launch.
update public.workers w
set trades_confirmed_at = now()
where w.trades_confirmed_at is null
  and exists (select 1 from public.worker_services ws where ws.worker_id = w.id);

create or replace function public.worker_confirm_trades()
returns public.workers
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_worker public.workers%rowtype;
begin
  v_worker := public.require_current_worker();

  if not exists (select 1 from public.worker_services where worker_id = v_worker.id) then
    raise exception 'INVALID: choose at least one trade first' using errcode = '22023';
  end if;

  update public.workers
  set trades_confirmed_at = now()
  where id = v_worker.id
  returning * into v_worker;

  return v_worker;
end;
$$;

revoke all on function public.worker_confirm_trades() from public;
grant execute on function public.worker_confirm_trades() to authenticated;
