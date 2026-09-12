-- ===========================================================================
-- 0008  Media assets — references to files held in Firebase Storage
-- ---------------------------------------------------------------------------
-- No binary is stored in Postgres. Every photo, video, certificate and receipt
-- lives in Firebase Storage; this table holds the path plus the metadata the
-- platform needs to authorize access to it.
--
--   Firebase Storage                          Supabase
--   bookings/bk_123/before-work/m_456.jpg  <- media_assets.firebase_storage_path
--
-- Three rules are enforced here rather than left to application code:
--
--   1. A client-supplied path is never trusted. The storage path must match the
--      prefix implied by the purpose and the owning resource, so a row can
--      never point at workers/someone-else/kyc/id.jpg.
--   2. Sensitivity is derived from purpose by trigger, never supplied. A caller
--      cannot label a KYC document PUBLIC to widen access to it.
--   3. A row starts PENDING and becomes COMPLETED only when the trusted backend
--      confirms the object exists in Firebase Storage.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Purpose metadata
-- ---------------------------------------------------------------------------
-- Single source of truth for where a file lives, how sensitive it is, and which
-- permission an administrator needs to open it.
create table public.media_purpose_rules (
  purpose            public.media_purpose primary key,
  -- Root segment of the storage path: 'workers', 'bookings', 'claims', ...
  path_root          text not null,
  -- Folder under the owner id, e.g. 'kyc' in workers/{id}/kyc/.
  path_folder        text not null,
  -- Which column on media_assets must be populated for this purpose.
  owner_column       text not null,
  sensitivity        public.media_sensitivity not null,
  -- Permission an administrator must hold to obtain a signed URL.
  required_permission text not null references public.permissions (key),
  allowed_mime_types text[] not null,
  max_size_bytes     bigint not null,

  constraint media_purpose_rules_size_positive check (max_size_bytes > 0)
);

insert into public.media_purpose_rules
  (purpose, path_root, path_folder, owner_column, sensitivity, required_permission, allowed_mime_types, max_size_bytes)
values
  ('WORKER_PROFILE_PHOTO',      'workers',   'profile',        'worker_id',          'INTERNAL',  'workers.read',
   array['image/jpeg','image/png','image/webp'], 5242880),
  ('WORKER_KYC_DOCUMENT',       'workers',   'kyc',            'worker_id',          'SENSITIVE', 'workers.documents.read',
   array['image/jpeg','image/png','image/webp','application/pdf'], 15728640),
  ('WORKER_QUALIFICATION',      'workers',   'qualifications', 'worker_id',          'SENSITIVE', 'workers.documents.read',
   array['image/jpeg','image/png','image/webp','application/pdf'], 15728640),
  ('WORKER_RPL_CREDENTIAL',     'workers',   'rpl',            'worker_id',          'SENSITIVE', 'workers.documents.read',
   array['image/jpeg','image/png','image/webp','application/pdf'], 15728640),
  ('WORKER_BACKGROUND_CHECK',   'workers',   'background',     'worker_id',          'SENSITIVE', 'workers.documents.read',
   array['application/pdf'], 15728640),
  ('WORKER_INSURANCE_DOCUMENT', 'workers',   'insurance',      'worker_id',          'SENSITIVE', 'insurance.read',
   array['image/jpeg','image/png','application/pdf'], 15728640),

  ('CUSTOMER_PROFILE_PHOTO',    'customers', 'profile',        'customer_id',        'INTERNAL',  'customers.read',
   array['image/jpeg','image/png','image/webp'], 5242880),

  ('BOOKING_BEFORE_WORK',       'bookings',  'before-work',    'booking_id',         'INTERNAL',  'media.read',
   array['image/jpeg','image/png','image/webp','video/mp4','video/quicktime'], 104857600),
  ('BOOKING_DURING_WORK',       'bookings',  'during-work',    'booking_id',         'INTERNAL',  'media.read',
   array['image/jpeg','image/png','image/webp','video/mp4','video/quicktime'], 104857600),
  ('BOOKING_AFTER_WORK',        'bookings',  'after-work',     'booking_id',         'INTERNAL',  'media.read',
   array['image/jpeg','image/png','image/webp','video/mp4','video/quicktime'], 104857600),
  ('BOOKING_ARRIVAL_PROOF',     'bookings',  'arrival',        'booking_id',         'INTERNAL',  'media.read',
   array['image/jpeg','image/png','image/webp'], 10485760),
  ('BOOKING_MATERIAL_PHOTO',    'bookings',  'materials',      'booking_id',         'INTERNAL',  'materials.read',
   array['image/jpeg','image/png','image/webp'], 10485760),
  ('BOOKING_RECEIPT',           'bookings',  'receipts',       'booking_id',         'INTERNAL',  'materials.read',
   array['image/jpeg','image/png','image/webp','application/pdf'], 10485760),

  ('CLAIM_EVIDENCE',            'claims',    'evidence',       'claim_id',           'SENSITIVE', 'claims.read',
   array['image/jpeg','image/png','image/webp','video/mp4','application/pdf'], 104857600),

  ('SUPPORT_ATTACHMENT',        'support',   'attachments',    'support_ticket_id',  'SENSITIVE', 'support.read',
   array['image/jpeg','image/png','image/webp','application/pdf','text/plain'], 20971520),

  ('SERVICE_CATALOGUE_IMAGE',   'services',  'catalogue',      'service_id',         'PUBLIC',    'services.read',
   array['image/jpeg','image/png','image/webp','image/svg+xml'], 5242880);

-- ---------------------------------------------------------------------------
-- media_assets
-- ---------------------------------------------------------------------------
create table public.media_assets (
  id             uuid primary key default gen_random_uuid(),

  -- Object path inside the Firebase Storage bucket. Unique so the same object
  -- cannot be claimed by two records.
  firebase_storage_path text not null unique,
  storage_bucket text not null,

  media_type     public.media_type not null,
  purpose        public.media_purpose not null references public.media_purpose_rules (purpose),
  -- Derived from purpose by trigger. Any supplied value is overwritten.
  sensitivity    public.media_sensitivity not null default 'SENSITIVE',
  upload_status  public.media_upload_status not null default 'PENDING',

  -- Uploader identity, from the verified Firebase token — never from the body.
  uploaded_by_type       public.actor_type not null,
  uploaded_by_firebase_uid text,
  uploaded_by_profile_id uuid references public.profiles (id) on delete set null,

  -- Owning resource. Exactly one must match the purpose rule.
  worker_id         uuid references public.workers (id) on delete cascade,
  customer_id       uuid references public.customers (id) on delete cascade,
  verification_id   uuid references public.worker_verifications (id) on delete cascade,
  booking_id        uuid references public.bookings (id) on delete cascade,
  material_id       uuid references public.materials (id) on delete set null,
  claim_id          uuid references public.claims (id) on delete cascade,
  support_ticket_id uuid references public.support_tickets (id) on delete cascade,
  service_id        uuid references public.services (id) on delete cascade,

  original_file_name text not null,
  mime_type      text not null,
  file_size_bytes bigint not null,
  checksum_sha256 text,
  width          integer,
  height         integer,
  duration_seconds numeric(10, 2),

  -- When the media was actually captured, if the client reported it. Useful for
  -- claim assessment, where a photo taken days later matters.
  captured_at    timestamptz,
  completed_at   timestamptz,
  failure_reason text,
  deleted_at     timestamptz,
  deleted_by     uuid references public.admin_users (id) on delete set null,

  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint media_assets_size_positive check (file_size_bytes > 0),
  constraint media_assets_dimensions_sane check (
    (width is null or width > 0) and (height is null or height > 0)
  ),
  constraint media_assets_duration_sane check (duration_seconds is null or duration_seconds > 0),
  constraint media_assets_completed_has_timestamp check (
    upload_status <> 'COMPLETED' or completed_at is not null
  ),
  constraint media_assets_failed_has_reason check (
    upload_status <> 'FAILED' or failure_reason is not null
  ),
  constraint media_assets_path_not_traversable check (
    firebase_storage_path !~ '\.\.'
    and firebase_storage_path !~ '^/'
    and firebase_storage_path !~ '\s'
    and length(firebase_storage_path) between 8 and 1024
  ),
  constraint media_assets_file_name_safe check (
    original_file_name !~ '[/\\]' and length(btrim(original_file_name)) > 0
  )
);

comment on table public.media_assets is
  'Reference to a file in Firebase Storage. Postgres stores the path and metadata; Firebase stores the bytes.';
comment on column public.media_assets.sensitivity is
  'Derived from purpose by trigger. A caller cannot relabel a KYC document as PUBLIC.';

create index media_assets_worker_idx on public.media_assets (worker_id, purpose) where deleted_at is null;
create index media_assets_booking_idx on public.media_assets (booking_id, purpose) where deleted_at is null;
create index media_assets_claim_idx on public.media_assets (claim_id) where deleted_at is null;
create index media_assets_ticket_idx on public.media_assets (support_ticket_id) where deleted_at is null;
create index media_assets_verification_idx on public.media_assets (verification_id) where deleted_at is null;
create index media_assets_customer_idx on public.media_assets (customer_id, purpose) where deleted_at is null;
create index media_assets_status_idx on public.media_assets (upload_status, created_at desc);
create index media_assets_uploader_idx on public.media_assets (uploaded_by_profile_id, created_at desc);
-- Sweeper for uploads that were authorized but never completed.
create index media_assets_stale_pending_idx on public.media_assets (created_at)
  where upload_status in ('PENDING', 'UPLOADING');

create trigger media_assets_touch_updated_at
  before update on public.media_assets
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Path and sensitivity enforcement
-- ---------------------------------------------------------------------------
-- Rebuilds the expected path prefix from the purpose rule and the owning
-- resource id, then refuses any row whose path does not sit under it. This is
-- what stops a caller from registering someone else's object.
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

  if position(v_prefix in new.firebase_storage_path) <> 1 then
    raise exception 'FORBIDDEN: storage path % does not belong under % for this resource',
      new.firebase_storage_path, v_prefix
      using errcode = '42501';
  end if;

  -- The object segment must be a single non-empty name, not a nested path that
  -- could climb into another resource's folder.
  if position('/' in substr(new.firebase_storage_path, length(v_prefix) + 1)) > 0
     or length(new.firebase_storage_path) <= length(v_prefix) then
    raise exception 'FORBIDDEN: storage path % must name a single object under %',
      new.firebase_storage_path, v_prefix
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

create trigger media_assets_enforce_integrity
  before insert or update on public.media_assets
  for each row execute function public.enforce_media_asset_integrity();

-- The storage path is the identity of the object. Repointing an existing row at
-- a different file would silently rewrite evidence, so it is refused.
create or replace function public.reject_media_path_change()
returns trigger
language plpgsql
as $$
begin
  if new.firebase_storage_path is distinct from old.firebase_storage_path then
    raise exception 'IMMUTABLE: firebase_storage_path cannot be changed; register a new asset instead'
      using errcode = '42501';
  end if;
  if new.purpose is distinct from old.purpose then
    raise exception 'IMMUTABLE: media purpose cannot be changed after creation'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger media_assets_path_immutable
  before update on public.media_assets
  for each row execute function public.reject_media_path_change();

-- ---------------------------------------------------------------------------
-- Wire media references into the domain tables
-- ---------------------------------------------------------------------------
-- Stored as a stable media id rather than a URL, so Firebase download URLs are
-- never scattered through the database and every read goes back through the
-- authorization path.
alter table public.workers
  add column profile_media_id uuid references public.media_assets (id) on delete set null;

alter table public.customers
  add column profile_media_id uuid references public.media_assets (id) on delete set null;

alter table public.admin_users
  add constraint admin_users_avatar_media_fk
  foreign key (avatar_media_id) references public.media_assets (id) on delete set null;

alter table public.insurance_policies
  add column document_media_id uuid references public.media_assets (id) on delete set null;

alter table public.materials
  add column receipt_media_id uuid references public.media_assets (id) on delete set null;

-- Now that receipts are modelled, restore the full billing invariant: a material
-- cannot be billed to a customer without a recorded cost and a receipt on file.
alter table public.materials
  drop constraint materials_billed_requires_cost;

alter table public.materials
  add constraint materials_billed_requires_cost_and_receipt check (
    status <> 'BILLED' or (actual_cost_minor is not null and receipt_media_id is not null)
  );

alter table public.services
  drop column image_path,
  add column image_media_id uuid references public.media_assets (id) on delete set null;

alter table public.claims
  add constraint claims_recovery_transaction_fk
  foreign key (recovery_transaction_id)
  references public.wallet_transactions (id) on delete set null;

create index workers_profile_media_idx on public.workers (profile_media_id) where profile_media_id is not null;
create index materials_receipt_media_idx on public.materials (receipt_media_id) where receipt_media_id is not null;
