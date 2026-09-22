-- ===========================================================================
-- 0048  media_assets.firebase_storage_path -> storage_path
-- ---------------------------------------------------------------------------
-- Files moved from Firebase Storage to Supabase Storage in 0017, but the column
-- kept its Firebase name. Renaming it carries the table's check constraints,
-- unique index and column-level INSERT grant with it automatically; the two
-- trigger functions below name the column in their bodies, so they are
-- re-created in the same transaction.
-- ===========================================================================

alter table public.media_assets rename column firebase_storage_path to storage_path;

create or replace function public.enforce_media_asset_integrity()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_rule     public.media_purpose_rules%rowtype;
  v_owner_id uuid;
  v_prefix   text;
begin
  select * into v_rule
  from public.media_purpose_rules
  where purpose = new.purpose;

  if not found then
    raise exception 'INVALID: no media purpose rule for %', new.purpose
      using errcode = '23514';
  end if;

  -- Sensitivity is not the caller's to choose.
  new.sensitivity := v_rule.sensitivity;

  -- Resolve the owning resource id named by the rule.
  v_owner_id := case v_rule.owner_column
    when 'worker_id'         then new.worker_id
    when 'customer_id'       then new.customer_id
    when 'booking_id'        then new.booking_id
    when 'claim_id'          then new.claim_id
    when 'support_ticket_id' then new.support_ticket_id
    when 'service_id'        then new.service_id
  end;

  if v_owner_id is null then
    raise exception 'INVALID: % is required for media purpose %', v_rule.owner_column, new.purpose
      using errcode = '23502';
  end if;

  -- Expected: <root>/<owner-id>/<folder>/<object>
  v_prefix := v_rule.path_root || '/' || v_owner_id::text || '/' || v_rule.path_folder || '/';

  if position(v_prefix in new.storage_path) <> 1 then
    raise exception 'FORBIDDEN: storage path % does not belong under % for this resource',
      new.storage_path, v_prefix
      using errcode = '42501';
  end if;

  -- The object segment must be a single non-empty name, not a nested path that
  -- could climb into another resource's folder.
  if position('/' in substr(new.storage_path, length(v_prefix) + 1)) > 0
     or length(new.storage_path) <= length(v_prefix) then
    raise exception 'FORBIDDEN: storage path % must name a single object under %',
      new.storage_path, v_prefix
      using errcode = '42501';
  end if;

  if not (new.mime_type = any (v_rule.allowed_mime_types)) then
    raise exception 'INVALID: mime type % is not permitted for purpose %', new.mime_type, new.purpose
      using errcode = '23514';
  end if;

  if new.file_size_bytes > v_rule.max_size_bytes then
    raise exception 'INVALID: file of % bytes exceeds the % byte limit for purpose %',
      new.file_size_bytes, v_rule.max_size_bytes, new.purpose
      using errcode = '23514';
  end if;

  return new;
end;
$$;

create or replace function public.reject_media_path_change()
returns trigger
language plpgsql
as $$
begin
  if new.storage_path is distinct from old.storage_path then
    raise exception 'IMMUTABLE: storage_path cannot be changed; register a new asset instead'
      using errcode = '42501';
  end if;
  if new.purpose is distinct from old.purpose then
    raise exception 'IMMUTABLE: media purpose cannot be changed after creation'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

comment on column public.media_assets.storage_path is
  'Object path inside the Supabase Storage bucket named by storage_bucket.';
