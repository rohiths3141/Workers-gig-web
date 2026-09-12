/**
 * Domain types.
 *
 * These mirror the Postgres enums defined in supabase/migrations/0001. They are
 * declared as `const` objects with derived union types rather than TypeScript
 * `enum`s, so the runtime value is a plain string that matches the database
 * exactly, and so status literals are never scattered through the codebase as
 * bare strings.
 *
 * tests/domain-enums.test.ts asserts that every member here exists in the
 * migration, so the two cannot drift apart silently.
 */

// ---------------------------------------------------------------------------
// Identity
// ---------------------------------------------------------------------------
export const ProfileRole = {
  CUSTOMER: 'CUSTOMER',
  WORKER: 'WORKER',
  ADMIN: 'ADMIN',
} as const;
export type ProfileRole = (typeof ProfileRole)[keyof typeof ProfileRole];

export const ProfileStatus = {
  ACTIVE: 'ACTIVE',
  DISABLED: 'DISABLED',
  PENDING_DELETION: 'PENDING_DELETION',
} as const;
export type ProfileStatus = (typeof ProfileStatus)[keyof typeof ProfileStatus];

export const AdminRole = {
  SUPER_ADMIN: 'SUPER_ADMIN',
  ADMIN: 'ADMIN',
  VERIFICATION_ADMIN: 'VERIFICATION_ADMIN',
  OPERATIONS_ADMIN: 'OPERATIONS_ADMIN',
  FINANCE_ADMIN: 'FINANCE_ADMIN',
  SUPPORT_ADMIN: 'SUPPORT_ADMIN',
} as const;
export type AdminRole = (typeof AdminRole)[keyof typeof AdminRole];

export const ActorType = {
  CUSTOMER: 'CUSTOMER',
  WORKER: 'WORKER',
  ADMIN: 'ADMIN',
  SYSTEM: 'SYSTEM',
} as const;
export type ActorType = (typeof ActorType)[keyof typeof ActorType];

// ---------------------------------------------------------------------------
// People
// ---------------------------------------------------------------------------
export const WorkerStatus = {
  REGISTERED: 'REGISTERED',
  VERIFICATION_PENDING: 'VERIFICATION_PENDING',
  ACTIVE: 'ACTIVE',
  INACTIVE: 'INACTIVE',
  RESTRICTED: 'RESTRICTED',
  SUSPENDED: 'SUSPENDED',
  REJECTED: 'REJECTED',
  DEACTIVATED: 'DEACTIVATED',
} as const;
export type WorkerStatus = (typeof WorkerStatus)[keyof typeof WorkerStatus];

export const CustomerStatus = {
  ACTIVE: 'ACTIVE',
  RESTRICTED: 'RESTRICTED',
  SUSPENDED: 'SUSPENDED',
  DEACTIVATED: 'DEACTIVATED',
} as const;
export type CustomerStatus = (typeof CustomerStatus)[keyof typeof CustomerStatus];

export const WorkerAvailability = {
  AVAILABLE: 'AVAILABLE',
  BUSY: 'BUSY',
  OFFLINE: 'OFFLINE',
} as const;
export type WorkerAvailability = (typeof WorkerAvailability)[keyof typeof WorkerAvailability];

// ---------------------------------------------------------------------------
// Verification
// ---------------------------------------------------------------------------
export const VerificationType = {
  IDENTITY_KYC: 'IDENTITY_KYC',
  ADDRESS: 'ADDRESS',
  ITI_CERTIFICATE: 'ITI_CERTIFICATE',
  DIPLOMA: 'DIPLOMA',
  RPL_SKILL: 'RPL_SKILL',
  BACKGROUND_CHECK: 'BACKGROUND_CHECK',
  INSURANCE: 'INSURANCE',
  BANK_ACCOUNT: 'BANK_ACCOUNT',
} as const;
export type VerificationType = (typeof VerificationType)[keyof typeof VerificationType];

export const VerificationStatus = {
  NOT_SUBMITTED: 'NOT_SUBMITTED',
  PENDING: 'PENDING',
  UNDER_REVIEW: 'UNDER_REVIEW',
  MORE_INFO_REQUIRED: 'MORE_INFO_REQUIRED',
  APPROVED: 'APPROVED',
  REJECTED: 'REJECTED',
  EXPIRED: 'EXPIRED',
  NOT_APPLICABLE: 'NOT_APPLICABLE',
} as const;
export type VerificationStatus = (typeof VerificationStatus)[keyof typeof VerificationStatus];

// ---------------------------------------------------------------------------
// Bookings
// ---------------------------------------------------------------------------
export const BookingStatus = {
  REQUESTED: 'REQUESTED',
  ACCEPTED: 'ACCEPTED',
  CONFIRMED: 'CONFIRMED',
  TRAVELING: 'TRAVELING',
  ARRIVED: 'ARRIVED',
  IN_PROGRESS: 'IN_PROGRESS',
  AWAITING_APPROVAL: 'AWAITING_APPROVAL',
  COMPLETED: 'COMPLETED',
  PAYMENT_PENDING: 'PAYMENT_PENDING',
  PAID: 'PAID',
  CLOSED: 'CLOSED',
  CANCELLED: 'CANCELLED',
  DISPUTED: 'DISPUTED',
  EXPIRED: 'EXPIRED',
} as const;
export type BookingStatus = (typeof BookingStatus)[keyof typeof BookingStatus];

/** Statuses that represent a job currently in flight. */
export const ACTIVE_BOOKING_STATUSES: readonly BookingStatus[] = [
  BookingStatus.ACCEPTED,
  BookingStatus.CONFIRMED,
  BookingStatus.TRAVELING,
  BookingStatus.ARRIVED,
  BookingStatus.IN_PROGRESS,
  BookingStatus.AWAITING_APPROVAL,
];

/** Statuses from which a booking can no longer move. */
export const TERMINAL_BOOKING_STATUSES: readonly BookingStatus[] = [
  BookingStatus.CLOSED,
  BookingStatus.CANCELLED,
  BookingStatus.EXPIRED,
];

export const BookingEventType = {
  REQUEST_CREATED: 'REQUEST_CREATED',
  MATCHING_STARTED: 'MATCHING_STARTED',
  WORKER_MATCHED: 'WORKER_MATCHED',
  WORKER_OFFERED: 'WORKER_OFFERED',
  WORKER_ACCEPTED: 'WORKER_ACCEPTED',
  WORKER_DECLINED: 'WORKER_DECLINED',
  WORKER_SELECTED: 'WORKER_SELECTED',
  BOOKING_CONFIRMED: 'BOOKING_CONFIRMED',
  TRAVEL_STARTED: 'TRAVEL_STARTED',
  WORKER_ARRIVED: 'WORKER_ARRIVED',
  ARRIVAL_VERIFIED: 'ARRIVAL_VERIFIED',
  WORK_STARTED: 'WORK_STARTED',
  MATERIAL_REQUESTED: 'MATERIAL_REQUESTED',
  MATERIAL_APPROVED: 'MATERIAL_APPROVED',
  MATERIAL_REJECTED: 'MATERIAL_REJECTED',
  WORK_COMPLETED: 'WORK_COMPLETED',
  CUSTOMER_APPROVED: 'CUSTOMER_APPROVED',
  PAYMENT_INITIATED: 'PAYMENT_INITIATED',
  PAYMENT_COMPLETED: 'PAYMENT_COMPLETED',
  PAYMENT_FAILED: 'PAYMENT_FAILED',
  RATING_SUBMITTED: 'RATING_SUBMITTED',
  BOOKING_CLOSED: 'BOOKING_CLOSED',
  BOOKING_CANCELLED: 'BOOKING_CANCELLED',
  DISPUTE_RAISED: 'DISPUTE_RAISED',
  ADMIN_OVERRIDE: 'ADMIN_OVERRIDE',
} as const;
export type BookingEventType = (typeof BookingEventType)[keyof typeof BookingEventType];

// ---------------------------------------------------------------------------
// Materials
// ---------------------------------------------------------------------------
export const MaterialStatus = {
  REQUESTED: 'REQUESTED',
  CUSTOMER_REVIEW: 'CUSTOMER_REVIEW',
  APPROVED: 'APPROVED',
  REJECTED: 'REJECTED',
  PURCHASED: 'PURCHASED',
  COST_RECORDED: 'COST_RECORDED',
  BILLED: 'BILLED',
  CANCELLED: 'CANCELLED',
} as const;
export type MaterialStatus = (typeof MaterialStatus)[keyof typeof MaterialStatus];

// ---------------------------------------------------------------------------
// Money
// ---------------------------------------------------------------------------
export const PaymentStatus = {
  PENDING: 'PENDING',
  PROCESSING: 'PROCESSING',
  SUCCESS: 'SUCCESS',
  FAILED: 'FAILED',
  REFUNDED: 'REFUNDED',
  PARTIALLY_REFUNDED: 'PARTIALLY_REFUNDED',
} as const;
export type PaymentStatus = (typeof PaymentStatus)[keyof typeof PaymentStatus];

export const PayoutStatus = {
  REQUESTED: 'REQUESTED',
  PROCESSING: 'PROCESSING',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  REJECTED: 'REJECTED',
} as const;
export type PayoutStatus = (typeof PayoutStatus)[keyof typeof PayoutStatus];

export const WalletTransactionType = {
  CREDIT_JOB_EARNING: 'CREDIT_JOB_EARNING',
  CREDIT_MATERIAL_REIMBURSEMENT: 'CREDIT_MATERIAL_REIMBURSEMENT',
  CREDIT_ADJUSTMENT: 'CREDIT_ADJUSTMENT',
  CREDIT_PAYOUT_REVERSAL: 'CREDIT_PAYOUT_REVERSAL',
  DEBIT_PLATFORM_FEE: 'DEBIT_PLATFORM_FEE',
  DEBIT_PAYOUT: 'DEBIT_PAYOUT',
  DEBIT_ADJUSTMENT: 'DEBIT_ADJUSTMENT',
  DEBIT_CLAIM_RECOVERY: 'DEBIT_CLAIM_RECOVERY',
} as const;
export type WalletTransactionType =
  (typeof WalletTransactionType)[keyof typeof WalletTransactionType];

// ---------------------------------------------------------------------------
// Trust and safety
// ---------------------------------------------------------------------------
export const ClaimType = {
  PROPERTY_DAMAGE: 'PROPERTY_DAMAGE',
  THEFT: 'THEFT',
  INJURY: 'INJURY',
  POOR_WORKMANSHIP: 'POOR_WORKMANSHIP',
  OVERCHARGING: 'OVERCHARGING',
  OTHER: 'OTHER',
} as const;
export type ClaimType = (typeof ClaimType)[keyof typeof ClaimType];

export const ClaimStatus = {
  SUBMITTED: 'SUBMITTED',
  UNDER_REVIEW: 'UNDER_REVIEW',
  MORE_INFORMATION_REQUIRED: 'MORE_INFORMATION_REQUIRED',
  APPROVED: 'APPROVED',
  PARTIALLY_APPROVED: 'PARTIALLY_APPROVED',
  REJECTED: 'REJECTED',
  CLOSED: 'CLOSED',
} as const;
export type ClaimStatus = (typeof ClaimStatus)[keyof typeof ClaimStatus];

export const InsuranceStatus = {
  PENDING: 'PENDING',
  ACTIVE: 'ACTIVE',
  EXPIRING_SOON: 'EXPIRING_SOON',
  EXPIRED: 'EXPIRED',
  LAPSED: 'LAPSED',
  CANCELLED: 'CANCELLED',
} as const;
export type InsuranceStatus = (typeof InsuranceStatus)[keyof typeof InsuranceStatus];

// ---------------------------------------------------------------------------
// Support and notifications
// ---------------------------------------------------------------------------
export const SupportStatus = {
  OPEN: 'OPEN',
  IN_PROGRESS: 'IN_PROGRESS',
  WAITING_FOR_USER: 'WAITING_FOR_USER',
  RESOLVED: 'RESOLVED',
  CLOSED: 'CLOSED',
} as const;
export type SupportStatus = (typeof SupportStatus)[keyof typeof SupportStatus];

export const SupportPriority = {
  LOW: 'LOW',
  MEDIUM: 'MEDIUM',
  HIGH: 'HIGH',
  URGENT: 'URGENT',
} as const;
export type SupportPriority = (typeof SupportPriority)[keyof typeof SupportPriority];

export const SupportCategory = {
  BOOKING: 'BOOKING',
  PAYMENT: 'PAYMENT',
  PAYOUT: 'PAYOUT',
  VERIFICATION: 'VERIFICATION',
  ACCOUNT: 'ACCOUNT',
  SAFETY: 'SAFETY',
  CLAIM: 'CLAIM',
  APP_ISSUE: 'APP_ISSUE',
  OTHER: 'OTHER',
} as const;
export type SupportCategory = (typeof SupportCategory)[keyof typeof SupportCategory];

export const NotificationChannel = {
  PUSH: 'PUSH',
  SMS: 'SMS',
  EMAIL: 'EMAIL',
  IN_APP: 'IN_APP',
} as const;
export type NotificationChannel = (typeof NotificationChannel)[keyof typeof NotificationChannel];

export const NotificationStatus = {
  QUEUED: 'QUEUED',
  SENDING: 'SENDING',
  SENT: 'SENT',
  DELIVERED: 'DELIVERED',
  FAILED: 'FAILED',
  CANCELLED: 'CANCELLED',
} as const;
export type NotificationStatus = (typeof NotificationStatus)[keyof typeof NotificationStatus];

export const ContactMessageStatus = {
  NEW: 'NEW',
  IN_PROGRESS: 'IN_PROGRESS',
  RESOLVED: 'RESOLVED',
  SPAM: 'SPAM',
} as const;
export type ContactMessageStatus =
  (typeof ContactMessageStatus)[keyof typeof ContactMessageStatus];

// ---------------------------------------------------------------------------
// Media
// ---------------------------------------------------------------------------
export const MediaType = {
  IMAGE: 'IMAGE',
  VIDEO: 'VIDEO',
  DOCUMENT: 'DOCUMENT',
  AUDIO: 'AUDIO',
} as const;
export type MediaType = (typeof MediaType)[keyof typeof MediaType];

export const MediaPurpose = {
  WORKER_PROFILE_PHOTO: 'WORKER_PROFILE_PHOTO',
  WORKER_KYC_DOCUMENT: 'WORKER_KYC_DOCUMENT',
  WORKER_QUALIFICATION: 'WORKER_QUALIFICATION',
  WORKER_RPL_CREDENTIAL: 'WORKER_RPL_CREDENTIAL',
  WORKER_BACKGROUND_CHECK: 'WORKER_BACKGROUND_CHECK',
  WORKER_INSURANCE_DOCUMENT: 'WORKER_INSURANCE_DOCUMENT',
  CUSTOMER_PROFILE_PHOTO: 'CUSTOMER_PROFILE_PHOTO',
  BOOKING_BEFORE_WORK: 'BOOKING_BEFORE_WORK',
  BOOKING_DURING_WORK: 'BOOKING_DURING_WORK',
  BOOKING_AFTER_WORK: 'BOOKING_AFTER_WORK',
  BOOKING_ARRIVAL_PROOF: 'BOOKING_ARRIVAL_PROOF',
  BOOKING_MATERIAL_PHOTO: 'BOOKING_MATERIAL_PHOTO',
  BOOKING_RECEIPT: 'BOOKING_RECEIPT',
  CLAIM_EVIDENCE: 'CLAIM_EVIDENCE',
  SUPPORT_ATTACHMENT: 'SUPPORT_ATTACHMENT',
  SERVICE_CATALOGUE_IMAGE: 'SERVICE_CATALOGUE_IMAGE',
} as const;
export type MediaPurpose = (typeof MediaPurpose)[keyof typeof MediaPurpose];

export const MediaSensitivity = {
  PUBLIC: 'PUBLIC',
  INTERNAL: 'INTERNAL',
  SENSITIVE: 'SENSITIVE',
} as const;
export type MediaSensitivity = (typeof MediaSensitivity)[keyof typeof MediaSensitivity];

export const MediaUploadStatus = {
  PENDING: 'PENDING',
  UPLOADING: 'UPLOADING',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  QUARANTINED: 'QUARANTINED',
  DELETED: 'DELETED',
} as const;
export type MediaUploadStatus = (typeof MediaUploadStatus)[keyof typeof MediaUploadStatus];
