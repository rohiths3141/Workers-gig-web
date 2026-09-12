-- ===========================================================================
-- 0001  Extensions and domain enumerations
-- ---------------------------------------------------------------------------
-- Every status in the platform is a Postgres enum rather than free text so the
-- database itself rejects invalid states. The TypeScript unions in
-- src/types/domain.ts mirror these exactly.
-- ===========================================================================

create extension if not exists "pgcrypto";      -- gen_random_uuid()
create extension if not exists "citext";        -- case-insensitive email
create extension if not exists "pg_trgm";       -- trigram search on names/phones
create extension if not exists "cube";
create extension if not exists "earthdistance"; -- nearby-worker matching

-- ---------------------------------------------------------------------------
-- Identity
-- ---------------------------------------------------------------------------
-- Authentication is Firebase. A profile is the platform-side record bound to a
-- Firebase UID; this enum says which kind of principal that profile is.
create type public.profile_role as enum (
  'CUSTOMER',
  'WORKER',
  'ADMIN'
);

-- Lifecycle of the platform account, independent of the Firebase account state.
create type public.profile_status as enum (
  'ACTIVE',
  'DISABLED',
  'PENDING_DELETION'
);

-- ---------------------------------------------------------------------------
-- Administrative roles
-- ---------------------------------------------------------------------------
create type public.admin_role as enum (
  'SUPER_ADMIN',
  'ADMIN',
  'VERIFICATION_ADMIN',
  'OPERATIONS_ADMIN',
  'FINANCE_ADMIN',
  'SUPPORT_ADMIN'
);

-- Which kind of principal performed an action / owns a record.
create type public.actor_type as enum (
  'CUSTOMER',
  'WORKER',
  'ADMIN',
  'SYSTEM'
);

-- ---------------------------------------------------------------------------
-- People
-- ---------------------------------------------------------------------------
create type public.worker_status as enum (
  'REGISTERED',            -- account created, nothing submitted yet
  'VERIFICATION_PENDING',  -- documents submitted, awaiting review
  'ACTIVE',                -- eligible to receive jobs
  'INACTIVE',              -- voluntarily unavailable
  'RESTRICTED',            -- limited by trust and safety
  'SUSPENDED',
  'REJECTED',
  'DEACTIVATED'
);

create type public.customer_status as enum (
  'ACTIVE',
  'RESTRICTED',
  'SUSPENDED',
  'DEACTIVATED'
);

create type public.worker_availability as enum (
  'AVAILABLE',
  'BUSY',
  'OFFLINE'
);

-- ---------------------------------------------------------------------------
-- Verification
-- ---------------------------------------------------------------------------
create type public.verification_type as enum (
  'IDENTITY_KYC',      -- government identity document plus liveness
  'ADDRESS',
  'ITI_CERTIFICATE',   -- Industrial Training Institute trade certificate
  'DIPLOMA',
  'RPL_SKILL',         -- Recognition of Prior Learning skill assessment
  'BACKGROUND_CHECK',
  'INSURANCE',
  'BANK_ACCOUNT'
);

create type public.verification_status as enum (
  'NOT_SUBMITTED',
  'PENDING',
  'UNDER_REVIEW',
  'MORE_INFO_REQUIRED',
  'APPROVED',
  'REJECTED',
  'EXPIRED',
  'NOT_APPLICABLE'
);

-- ---------------------------------------------------------------------------
-- Bookings
-- ---------------------------------------------------------------------------
create type public.booking_status as enum (
  'REQUESTED',
  'ACCEPTED',
  'CONFIRMED',
  'TRAVELING',
  'ARRIVED',
  'IN_PROGRESS',
  'AWAITING_APPROVAL',
  'COMPLETED',
  'PAYMENT_PENDING',
  'PAID',
  'CLOSED',
  'CANCELLED',
  'DISPUTED',
  'EXPIRED'
);

create type public.booking_event_type as enum (
  'REQUEST_CREATED',
  'MATCHING_STARTED',
  'WORKER_MATCHED',
  'WORKER_OFFERED',
  'WORKER_ACCEPTED',
  'WORKER_DECLINED',
  'WORKER_SELECTED',
  'BOOKING_CONFIRMED',
  'TRAVEL_STARTED',
  'WORKER_ARRIVED',
  'ARRIVAL_VERIFIED',
  'WORK_STARTED',
  'MATERIAL_REQUESTED',
  'MATERIAL_APPROVED',
  'MATERIAL_REJECTED',
  'WORK_COMPLETED',
  'CUSTOMER_APPROVED',
  'PAYMENT_INITIATED',
  'PAYMENT_COMPLETED',
  'PAYMENT_FAILED',
  'RATING_SUBMITTED',
  'BOOKING_CLOSED',
  'BOOKING_CANCELLED',
  'DISPUTE_RAISED',
  'ADMIN_OVERRIDE'
);

-- ---------------------------------------------------------------------------
-- Materials
-- ---------------------------------------------------------------------------
create type public.material_status as enum (
  'REQUESTED',
  'CUSTOMER_REVIEW',
  'APPROVED',
  'REJECTED',
  'PURCHASED',
  'COST_RECORDED',
  'BILLED',
  'CANCELLED'
);

-- ---------------------------------------------------------------------------
-- Money
-- ---------------------------------------------------------------------------
create type public.payment_status as enum (
  'PENDING',
  'PROCESSING',
  'SUCCESS',
  'FAILED',
  'REFUNDED',
  'PARTIALLY_REFUNDED'
);

create type public.payout_status as enum (
  'REQUESTED',
  'PROCESSING',
  'COMPLETED',
  'FAILED',
  'REJECTED'
);

-- Signed ledger entry classification. CREDIT_* increase the worker balance,
-- DEBIT_* decrease it. The sign is enforced by a check constraint on the ledger.
create type public.wallet_transaction_type as enum (
  'CREDIT_JOB_EARNING',
  'CREDIT_MATERIAL_REIMBURSEMENT',
  'CREDIT_ADJUSTMENT',
  'CREDIT_PAYOUT_REVERSAL',
  'DEBIT_PLATFORM_FEE',
  'DEBIT_PAYOUT',
  'DEBIT_ADJUSTMENT',
  'DEBIT_CLAIM_RECOVERY'
);

-- ---------------------------------------------------------------------------
-- Trust and safety
-- ---------------------------------------------------------------------------
create type public.claim_type as enum (
  'PROPERTY_DAMAGE',
  'THEFT',
  'INJURY',
  'POOR_WORKMANSHIP',
  'OVERCHARGING',
  'OTHER'
);

create type public.claim_status as enum (
  'SUBMITTED',
  'UNDER_REVIEW',
  'MORE_INFORMATION_REQUIRED',
  'APPROVED',
  'PARTIALLY_APPROVED',
  'REJECTED',
  'CLOSED'
);

create type public.insurance_status as enum (
  'PENDING',
  'ACTIVE',
  'EXPIRING_SOON',
  'EXPIRED',
  'LAPSED',
  'CANCELLED'
);

-- ---------------------------------------------------------------------------
-- Support and notifications
-- ---------------------------------------------------------------------------
create type public.support_status as enum (
  'OPEN',
  'IN_PROGRESS',
  'WAITING_FOR_USER',
  'RESOLVED',
  'CLOSED'
);

create type public.support_priority as enum (
  'LOW',
  'MEDIUM',
  'HIGH',
  'URGENT'
);

create type public.support_category as enum (
  'BOOKING',
  'PAYMENT',
  'PAYOUT',
  'VERIFICATION',
  'ACCOUNT',
  'SAFETY',
  'CLAIM',
  'APP_ISSUE',
  'OTHER'
);

create type public.notification_channel as enum (
  'PUSH',
  'SMS',
  'EMAIL',
  'IN_APP'
);

-- Delivery states are only ever written by the trusted delivery worker acting on
-- a provider webhook. The application never fabricates a DELIVERED status.
create type public.notification_status as enum (
  'QUEUED',
  'SENDING',
  'SENT',
  'DELIVERED',
  'FAILED',
  'CANCELLED'
);

create type public.contact_message_status as enum (
  'NEW',
  'IN_PROGRESS',
  'RESOLVED',
  'SPAM'
);

-- ---------------------------------------------------------------------------
-- Media (files live in Firebase Storage; this database stores only references)
-- ---------------------------------------------------------------------------
create type public.media_type as enum (
  'IMAGE',
  'VIDEO',
  'DOCUMENT',
  'AUDIO'
);

-- What the file is for. Drives the Firebase Storage path, the retention rule,
-- and which permission is required to open it.
create type public.media_purpose as enum (
  'WORKER_PROFILE_PHOTO',
  'WORKER_KYC_DOCUMENT',
  'WORKER_QUALIFICATION',
  'WORKER_RPL_CREDENTIAL',
  'WORKER_BACKGROUND_CHECK',
  'WORKER_INSURANCE_DOCUMENT',
  'CUSTOMER_PROFILE_PHOTO',
  'BOOKING_BEFORE_WORK',
  'BOOKING_DURING_WORK',
  'BOOKING_AFTER_WORK',
  'BOOKING_ARRIVAL_PROOF',
  'BOOKING_MATERIAL_PHOTO',
  'BOOKING_RECEIPT',
  'CLAIM_EVIDENCE',
  'SUPPORT_ATTACHMENT',
  'SERVICE_CATALOGUE_IMAGE'
);

-- How exposed a file may be.
--   PUBLIC    - service catalogue artwork; safe to serve from a CDN
--   INTERNAL  - job evidence and receipts; parties to the booking plus staff
--   SENSITIVE - identity, qualification, background, insurance, claim evidence
create type public.media_sensitivity as enum (
  'PUBLIC',
  'INTERNAL',
  'SENSITIVE'
);

-- An upload is only usable once Firebase confirms the object exists. Rows are
-- created PENDING, and only the trusted backend may mark one COMPLETED.
create type public.media_upload_status as enum (
  'PENDING',
  'UPLOADING',
  'COMPLETED',
  'FAILED',
  'QUARANTINED',
  'DELETED'
);
