-- ===========================================================================
-- 0045  admin_decide_gig: the operations side of gig review
-- ---------------------------------------------------------------------------
-- 0013 built the worker side of gig review (worker_upsert_gig sends a gig to
-- PENDING_REVIEW while gigs.require_review is true) and the review trail
-- columns (reviewed_by, reviewed_at, rejection_reason), but never the function
-- an operator uses to decide one. Every submitted gig therefore sat in
-- PENDING_REVIEW forever and could never go live.
--
-- Decisions reuse the verification permissions: reviewing what a worker offers
-- is the same trust job as reviewing who they are.
-- ===========================================================================

create or replace function public.admin_decide_gig(
  p_gig_id   uuid,
  p_decision text,          -- APPROVE | REJECT
  p_reason   text default null
)
returns public.worker_gigs
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_gig      public.worker_gigs%rowtype;
  v_admin_id uuid;
  v_status   public.gig_status;
begin
  if p_decision not in ('APPROVE', 'REJECT') then
    raise exception 'INVALID: unknown gig decision %', p_decision using errcode = '23514';
  end if;

  v_admin_id := public.require_permission(
    case p_decision when 'APPROVE' then 'verification.approve' else 'verification.reject' end
  );

  if p_decision = 'REJECT' and (p_reason is null or length(btrim(p_reason)) < 5) then
    raise exception 'INVALID: a rejection requires a reason of at least 5 characters'
      using errcode = '23514';
  end if;

  select * into v_gig from public.worker_gigs where id = p_gig_id for update;

  if not found then
    raise exception 'NOT_FOUND: that gig does not exist' using errcode = 'P0002';
  end if;

  if v_gig.status <> 'PENDING_REVIEW' then
    raise exception 'CONFLICT: this gig is % and is not awaiting review', v_gig.status
      using errcode = '23505';
  end if;

  if exists (
    select 1 from public.workers w
    where w.id = v_gig.worker_id and w.firebase_uid = public.firebase_uid()
  ) then
    raise exception 'FORBIDDEN: a worker may not review their own gig' using errcode = '42501';
  end if;

  v_status := case p_decision when 'APPROVE' then 'ACTIVE' else 'REJECTED' end::public.gig_status;

  update public.worker_gigs
  set status           = v_status,
      reviewed_by      = v_admin_id,
      reviewed_at      = now(),
      rejection_reason = case when p_decision = 'REJECT' then btrim(p_reason) else null end
  where id = p_gig_id
  returning * into v_gig;

  perform public.write_audit_log(
    'gig.' || lower(p_decision),
    'worker_gig',
    p_gig_id::text,
    jsonb_build_object('status', 'PENDING_REVIEW'),
    jsonb_build_object('status', v_status),
    p_reason
  );

  return v_gig;
end;
$$;

revoke all on function public.admin_decide_gig(uuid, text, text) from public, anon;
grant execute on function public.admin_decide_gig(uuid, text, text) to authenticated;
