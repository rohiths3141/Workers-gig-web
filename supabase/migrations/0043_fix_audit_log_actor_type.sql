-- ===========================================================================
-- 0043  Fix write_audit_log: actor_type CASE never coerced to the enum
-- ---------------------------------------------------------------------------
-- write_audit_log() built actor_type as:
--
--     case when v_admin.id is not null then 'ADMIN' else 'SYSTEM' end
--
-- PostgreSQL resolves the two unknown literals in a CASE to a common type of
-- `text`, and text does not implicitly coerce into the public.actor_type enum
-- on insert, so every call raised:
--
--     42804: column "actor_type" is of type actor_type but expression is of
--            type text
--
-- A plain `insert ... values ('SYSTEM', ...)` coerces the unknown literal to
-- the enum and works, which is why the bootstrap script and the migrations
-- inserted audit rows without trouble and this stayed hidden. Only the CASE
-- form failed -- meaning write_audit_log() had never once succeeded, and every
-- privileged operation that records an audit entry (verification decisions,
-- booking transitions, payout decisions, wallet adjustments) aborted with an
-- untagged 42804 that the API layer could only report as a generic 500.
--
-- The fix is the explicit cast the enum column requires. Nothing else about
-- the function changes.
-- ===========================================================================

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
    -- Explicit cast: a CASE over unknown literals resolves to text, which the
    -- actor_type enum column will not accept.
    (case when v_admin.id is not null then 'ADMIN' else 'SYSTEM' end)::public.actor_type,
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
