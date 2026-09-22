-- ===========================================================================
-- 0044  admin_open_background_check: let an operator start the check
-- ---------------------------------------------------------------------------
-- BACKGROUND_CHECK is run by the platform, not submitted by the worker (the
-- worker app shows it as "We run this ourselves"), but nothing ever opened the
-- case, so it sat NOT_SUBMITTED forever and could never reach the queue.
--
-- This opens it as PENDING. From there the existing pipeline takes over: the
-- worker_verifications_notify_provider trigger hands it to the provider
-- adapter, or an operator decides it in the verification queue.
-- ===========================================================================

create or replace function public.admin_open_background_check(p_worker_id uuid)
returns public.worker_verifications
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_existing public.worker_verifications%rowtype;
  v_case     public.worker_verifications%rowtype;
begin
  perform public.require_permission('verification.review');

  if not exists (select 1 from public.workers where id = p_worker_id) then
    raise exception 'NOT_FOUND: no such worker' using errcode = 'P0002';
  end if;

  select * into v_existing
  from public.worker_verifications
  where worker_id = p_worker_id and type = 'BACKGROUND_CHECK'
  for update;

  if found and v_existing.status in ('PENDING', 'UNDER_REVIEW') then
    raise exception 'CONFLICT: a background check is already open for this worker'
      using errcode = '23505';
  end if;

  if found and v_existing.status = 'APPROVED'
     and (v_existing.expires_at is null or v_existing.expires_at > now()) then
    raise exception 'CONFLICT: this worker already holds a current background check'
      using errcode = '23505';
  end if;

  insert into public.worker_verifications (worker_id, type, status, submitted_at)
  values (p_worker_id, 'BACKGROUND_CHECK', 'PENDING', now())
  on conflict (worker_id, type) do update
    set status           = 'PENDING',
        submitted_at     = now(),
        reviewed_by      = null,
        reviewed_at      = null,
        provider         = null,
        provider_reference = null,
        decision_note    = null,
        rejection_reason = null,
        info_requested   = null,
        expires_at       = null
  returning * into v_case;

  perform public.write_audit_log(
    'verification.open_background_check',
    'worker_verification',
    v_case.id::text,
    case when v_existing.id is null then null
         else jsonb_build_object('status', v_existing.status) end,
    jsonb_build_object('status', v_case.status, 'worker_id', p_worker_id)
  );

  return v_case;
end;
$$;

revoke all on function public.admin_open_background_check(uuid) from public, anon;
grant execute on function public.admin_open_background_check(uuid) to authenticated;
