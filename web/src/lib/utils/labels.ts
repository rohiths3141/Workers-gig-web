import { humaniseEnum } from '@/lib/utils/format';

/**
 * Human labels for domain values whose enum name does not read well on its own.
 * Anything not listed falls back to humaniseEnum().
 */

export const VERIFICATION_TYPE_LABELS: Record<string, string> = {
  IDENTITY_KYC: 'Identity (KYC)',
  ADDRESS: 'Address',
  ITI_CERTIFICATE: 'ITI certificate',
  DIPLOMA: 'Diploma',
  RPL_SKILL: 'RPL skill assessment',
  BACKGROUND_CHECK: 'Background check',
  INSURANCE: 'Insurance',
  BANK_ACCOUNT: 'Bank account',
};

export function verificationTypeLabel(type: string | null | undefined): string {
  if (!type) return '—';
  return VERIFICATION_TYPE_LABELS[type] ?? humaniseEnum(type);
}

export const BOOKING_EVENT_LABELS: Record<string, string> = {
  REQUEST_CREATED: 'Request created',
  MATCHING_STARTED: 'Matching started',
  WORKER_MATCHED: 'Worker matched',
  WORKER_OFFERED: 'Job offered to worker',
  WORKER_ACCEPTED: 'Worker accepted',
  WORKER_DECLINED: 'Worker declined',
  WORKER_SELECTED: 'Worker selected',
  BOOKING_CONFIRMED: 'Booking confirmed',
  TRAVEL_STARTED: 'Worker started travel',
  WORKER_ARRIVED: 'Worker arrived',
  ARRIVAL_VERIFIED: 'Arrival verified',
  WORK_STARTED: 'Work started',
  MATERIAL_REQUESTED: 'Material requested',
  MATERIAL_APPROVED: 'Material approved',
  MATERIAL_REJECTED: 'Material rejected',
  WORK_COMPLETED: 'Work completed',
  CUSTOMER_APPROVED: 'Customer approved the work',
  PAYMENT_INITIATED: 'Payment initiated',
  PAYMENT_COMPLETED: 'Payment completed',
  PAYMENT_FAILED: 'Payment failed',
  RATING_SUBMITTED: 'Rating submitted',
  BOOKING_CLOSED: 'Booking closed',
  BOOKING_CANCELLED: 'Booking cancelled',
  DISPUTE_RAISED: 'Dispute raised',
  ADMIN_OVERRIDE: 'Administrative override',
};

export function bookingEventLabel(type: string): string {
  return BOOKING_EVENT_LABELS[type] ?? humaniseEnum(type);
}
