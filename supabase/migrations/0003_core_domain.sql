-- ===========================================================================
-- 0003  Core domain: service catalogue, customers, workers, verification
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Service catalogue
-- ---------------------------------------------------------------------------
-- Drives both the public /services pages and worker trade assignment. The public
-- website reads this table; nothing about the catalogue is hard-coded in React.
create table public.services (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  slug            text not null unique,
  short_description text not null,
  description     text,
  icon_key        text not null default 'wrench',
  image_path      text,
  is_active       boolean not null default true,
  display_order   integer not null default 100,
  -- Indicative only; the binding price is quoted per booking.
  base_visit_fee_minor integer,
  currency        text not null default 'INR',
  -- Which qualification evidence a worker must hold to take this trade.
  required_verifications public.verification_type[] not null default
    array['IDENTITY_KYC', 'BACKGROUND_CHECK']::public.verification_type[],
  seo_title       text,
  seo_description text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  constraint services_slug_format check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  constraint services_base_fee_non_negative check (base_visit_fee_minor is null or base_visit_fee_minor >= 0)
);

create index services_active_order_idx on public.services (display_order, name) where is_active;

create trigger services_touch_updated_at
  before update on public.services
  for each row execute function public.touch_updated_at();

-- Common problems listed on a service detail page.
create table public.service_problems (
  id            uuid primary key default gen_random_uuid(),
  service_id    uuid not null references public.services (id) on delete cascade,
  title         text not null,
  description   text,
  display_order integer not null default 100
);

create index service_problems_service_idx on public.service_problems (service_id, display_order);

-- FAQs, optionally scoped to a service. service_id NULL = general /faq entry.
create table public.faqs (
  id            uuid primary key default gen_random_uuid(),
  service_id    uuid references public.services (id) on delete cascade,
  category      text not null default 'General',
  question      text not null,
  answer        text not null,
  display_order integer not null default 100,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now()
);

create index faqs_category_idx on public.faqs (category, display_order) where is_active;
create index faqs_service_idx on public.faqs (service_id, display_order) where is_active;

-- ---------------------------------------------------------------------------
-- Customers
-- ---------------------------------------------------------------------------
create table public.customers (
  id           uuid primary key default gen_random_uuid(),
  -- Identity comes from Firebase. See public.profiles.
  profile_id   uuid not null unique,
  firebase_uid text not null unique,
  full_name    text not null,
  phone        text not null unique,
  email        citext,
  status       public.customer_status not null default 'ACTIVE',
  city         text,
  state        text,
  pincode      text,
  -- Default service address. Individual bookings carry their own address.
  address_line text,
  latitude     double precision,
  longitude    double precision,
  rating_avg   numeric(3, 2),
  rating_count integer not null default 0,
  -- Set by trust and safety alongside a status change; surfaced in admin only.
  restriction_reason text,
  restricted_at      timestamptz,
  restricted_by      uuid references public.admin_users (id) on delete set null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),

  constraint customers_profile_fk
    foreign key (profile_id, firebase_uid)
    references public.profiles (id, firebase_uid)
    on update cascade on delete cascade,
  constraint customers_phone_format check (phone ~ '^[0-9]{10,15}$'),
  constraint customers_rating_range check (rating_avg is null or (rating_avg >= 0 and rating_avg <= 5)),
  constraint customers_latitude_range check (latitude is null or (latitude between -90 and 90)),
  constraint customers_longitude_range check (longitude is null or (longitude between -180 and 180))
);

create index customers_status_idx on public.customers (status, created_at desc);
create index customers_name_trgm_idx on public.customers using gin (full_name gin_trgm_ops);
create index customers_phone_trgm_idx on public.customers using gin (phone gin_trgm_ops);
create index customers_city_idx on public.customers (city) where city is not null;

create trigger customers_touch_updated_at
  before update on public.customers
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Workers
-- ---------------------------------------------------------------------------
create table public.workers (
  id               uuid primary key default gen_random_uuid(),
  -- Identity comes from Firebase. Both columns are held together by a composite
  -- foreign key so they can never drift to different profiles.
  profile_id       uuid not null unique,
  firebase_uid     text not null unique,
  worker_code      text not null unique,
  full_name        text not null,
  phone            text not null unique,
  email            citext,
  status           public.worker_status not null default 'REGISTERED',
  availability     public.worker_availability not null default 'OFFLINE',
  primary_service_id uuid references public.services (id) on delete set null,
  experience_years integer not null default 0,
  bio              text,
  city             text,
  state            text,
  pincode          text,
  address_line     text,
  latitude         double precision,
  longitude        double precision,
  service_radius_km numeric(5, 2) not null default 10,
  rating_avg       numeric(3, 2),
  rating_count     integer not null default 0,
  jobs_completed   integer not null default 0,
  jobs_cancelled   integer not null default 0,
  -- Denormalised roll-up of worker_verifications, maintained by trigger in 0009.
  -- Read-only from the application's point of view.
  is_kyc_verified        boolean not null default false,
  is_qualification_verified boolean not null default false,
  is_skill_verified      boolean not null default false,
  is_background_verified boolean not null default false,
  is_insured             boolean not null default false,
  verified_at            timestamptz,
  restriction_reason text,
  restricted_at      timestamptz,
  restricted_by      uuid references public.admin_users (id) on delete set null,
  last_active_at   timestamptz,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  constraint workers_profile_fk
    foreign key (profile_id, firebase_uid)
    references public.profiles (id, firebase_uid)
    on update cascade on delete cascade,
  constraint workers_phone_format check (phone ~ '^[0-9]{10,15}$'),
  constraint workers_experience_sane check (experience_years >= 0 and experience_years <= 70),
  constraint workers_rating_range check (rating_avg is null or (rating_avg >= 0 and rating_avg <= 5)),
  constraint workers_radius_range check (service_radius_km > 0 and service_radius_km <= 100),
  constraint workers_latitude_range check (latitude is null or (latitude between -90 and 90)),
  constraint workers_longitude_range check (longitude is null or (longitude between -180 and 180))
);

comment on column public.workers.is_kyc_verified is
  'Derived from worker_verifications by trigger. Never written directly by a client.';

create index workers_status_idx on public.workers (status, created_at desc);
create index workers_availability_idx on public.workers (availability) where status = 'ACTIVE';
create index workers_primary_service_idx on public.workers (primary_service_id);
create index workers_name_trgm_idx on public.workers using gin (full_name gin_trgm_ops);
create index workers_phone_trgm_idx on public.workers using gin (phone gin_trgm_ops);
create index workers_city_idx on public.workers (city) where city is not null;
create index workers_rating_idx on public.workers (rating_avg desc nulls last) where status = 'ACTIVE';

-- Geospatial index for the nearby-worker query in the matching engine.
create index workers_location_idx
  on public.workers using gist (ll_to_earth(latitude, longitude))
  where latitude is not null and longitude is not null;

create trigger workers_touch_updated_at
  before update on public.workers
  for each row execute function public.touch_updated_at();

-- Human-readable worker code, assigned once on insert.
create or replace function public.assign_worker_code()
returns trigger
language plpgsql
as $$
begin
  if new.worker_code is null or length(btrim(new.worker_code)) = 0 then
    new.worker_code := 'WKR-' || to_char(now(), 'YY') || '-' ||
                       upper(substr(encode(gen_random_bytes(4), 'hex'), 1, 6));
  end if;
  return new;
end;
$$;

create trigger workers_assign_code
  before insert on public.workers
  for each row execute function public.assign_worker_code();

-- Trades a worker is approved to take, beyond their primary trade.
create table public.worker_services (
  worker_id  uuid not null references public.workers (id) on delete cascade,
  service_id uuid not null references public.services (id) on delete cascade,
  -- Set true only once the qualification evidence for that trade is approved.
  is_approved boolean not null default false,
  approved_by uuid references public.admin_users (id) on delete set null,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  primary key (worker_id, service_id)
);

create index worker_services_service_idx on public.worker_services (service_id) where is_approved;

-- ---------------------------------------------------------------------------
-- Verification cases
-- ---------------------------------------------------------------------------
-- One row per (worker, verification type). The lifecycle of a single case is
-- enforced by public.decide_verification() in 0009 — never by a client update.
create table public.worker_verifications (
  id              uuid primary key default gen_random_uuid(),
  worker_id       uuid not null references public.workers (id) on delete cascade,
  type            public.verification_type not null,
  status          public.verification_status not null default 'NOT_SUBMITTED',
  -- Free-form, type-specific captured fields (certificate number, issuing
  -- institute, trade, year of passing, assessment agency, and so on).
  details         jsonb not null default '{}'::jsonb,
  submitted_at    timestamptz,
  reviewed_by     uuid references public.admin_users (id) on delete set null,
  reviewed_at     timestamptz,
  -- Who currently holds the case, to stop two reviewers duplicating work.
  assigned_to     uuid references public.admin_users (id) on delete set null,
  assigned_at     timestamptz,
  decision_note   text,
  rejection_reason text,
  info_requested  text,
  -- Certificates and background checks go stale; a nightly job expires them.
  expires_at      timestamptz,
  -- Reference from an external KYC/BGV provider, when one was used.
  provider        text,
  provider_reference text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  constraint worker_verifications_unique_type unique (worker_id, type),
  -- A terminal decision must record who made it.
  constraint worker_verifications_decision_attributed check (
    status not in ('APPROVED', 'REJECTED') or reviewed_by is not null
  ),
  constraint worker_verifications_rejection_has_reason check (
    status <> 'REJECTED' or (rejection_reason is not null and length(btrim(rejection_reason)) > 0)
  )
);

create index worker_verifications_status_idx on public.worker_verifications (status, submitted_at desc nulls last);
create index worker_verifications_worker_idx on public.worker_verifications (worker_id);
create index worker_verifications_queue_idx
  on public.worker_verifications (submitted_at)
  where status in ('PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED');
create index worker_verifications_expiring_idx
  on public.worker_verifications (expires_at)
  where status = 'APPROVED' and expires_at is not null;

create trigger worker_verifications_touch_updated_at
  before update on public.worker_verifications
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Verification documents
-- ---------------------------------------------------------------------------
-- Files are NOT stored here and NOT stored in Postgres at all. Every document
-- lives in Firebase Storage and is referenced through public.media_assets
-- (migration 0008), which carries verification_id. Access is always a
-- short-lived signed URL minted server-side after a permission check.

-- ---------------------------------------------------------------------------
-- Insurance
-- ---------------------------------------------------------------------------
-- A record of a policy held with an external insurer. The platform is not the
-- insurer: coverage decisions belong to the provider, and that separation is
-- stated explicitly in the admin UI and on the public pages.
create table public.insurance_policies (
  id             uuid primary key default gen_random_uuid(),
  worker_id      uuid not null references public.workers (id) on delete cascade,
  provider_name  text not null,
  policy_number  text not null,
  coverage_amount_minor bigint not null,
  currency       text not null default 'INR',
  premium_amount_minor  bigint,
  start_date     date not null,
  end_date       date not null,
  status         public.insurance_status not null default 'PENDING',
  notes          text,
  recorded_by    uuid references public.admin_users (id) on delete set null,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),

  constraint insurance_unique_policy unique (provider_name, policy_number),
  constraint insurance_dates_ordered check (end_date > start_date),
  constraint insurance_coverage_positive check (coverage_amount_minor > 0)
);

create index insurance_worker_idx on public.insurance_policies (worker_id, end_date desc);
create index insurance_expiry_idx on public.insurance_policies (end_date) where status = 'ACTIVE';

create trigger insurance_touch_updated_at
  before update on public.insurance_policies
  for each row execute function public.touch_updated_at();
