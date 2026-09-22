import { Badge, type BadgeTone } from '@/components/ui/badge';
import { humaniseEnum } from '@/lib/utils/format';
import type {
  BookingStatus,
  ClaimStatus,
  CustomerStatus,
  InsuranceStatus,
  MaterialStatus,
  NotificationStatus,
  PaymentStatus,
  PayoutStatus,
  SupportStatus,
  VerificationStatus,
  WorkerStatus,
} from '@/types/domain';

/**
 * One place where a domain status becomes a colour and a label.
 *
 * Colour is never the only signal: every badge carries its label, so the state
 * is readable without colour perception and by a screen reader.
 *
 * The tone vocabulary is consistent across domains:
 *   neutral  - nothing is happening yet, or the record is closed uneventfully
 *   info     - in flight, no action needed from the operator
 *   warning  - waiting on someone, or needs an operator decision
 *   success  - completed as intended
 *   danger   - failed, rejected, disputed or restricted
 */

const BOOKING_TONES: Record<BookingStatus, BadgeTone> = {
  REQUESTED: 'warning',
  ACCEPTED: 'info',
  CONFIRMED: 'info',
  TRAVELING: 'info',
  ARRIVED: 'info',
  IN_PROGRESS: 'info',
  AWAITING_APPROVAL: 'warning',
  COMPLETED: 'success',
  PAYMENT_PENDING: 'warning',
  PAID: 'success',
  CLOSED: 'neutral',
  CANCELLED: 'neutral',
  DISPUTED: 'danger',
  EXPIRED: 'neutral',
};

const BOOKING_LABELS: Partial<Record<BookingStatus, string>> = {
  AWAITING_APPROVAL: 'Awaiting approval',
  PAYMENT_PENDING: 'Payment pending',
  IN_PROGRESS: 'In progress',
};

const PAYMENT_TONES: Record<PaymentStatus, BadgeTone> = {
  PENDING: 'warning',
  PROCESSING: 'info',
  SUCCESS: 'success',
  FAILED: 'danger',
  REFUNDED: 'neutral',
  PARTIALLY_REFUNDED: 'warning',
};

const PAYOUT_TONES: Record<PayoutStatus, BadgeTone> = {
  REQUESTED: 'warning',
  PROCESSING: 'info',
  COMPLETED: 'success',
  FAILED: 'danger',
  REJECTED: 'danger',
};

const CLAIM_TONES: Record<ClaimStatus, BadgeTone> = {
  SUBMITTED: 'warning',
  UNDER_REVIEW: 'info',
  MORE_INFORMATION_REQUIRED: 'warning',
  APPROVED: 'success',
  PARTIALLY_APPROVED: 'success',
  REJECTED: 'danger',
  CLOSED: 'neutral',
};

const CLAIM_LABELS: Partial<Record<ClaimStatus, string>> = {
  MORE_INFORMATION_REQUIRED: 'More info required',
  PARTIALLY_APPROVED: 'Partially approved',
};

const VERIFICATION_TONES: Record<VerificationStatus, BadgeTone> = {
  NOT_SUBMITTED: 'neutral',
  PENDING: 'warning',
  UNDER_REVIEW: 'info',
  MORE_INFO_REQUIRED: 'warning',
  APPROVED: 'success',
  REJECTED: 'danger',
  EXPIRED: 'danger',
  NOT_APPLICABLE: 'neutral',
};

const VERIFICATION_LABELS: Partial<Record<VerificationStatus, string>> = {
  NOT_SUBMITTED: 'Not submitted',
  MORE_INFO_REQUIRED: 'More info required',
  NOT_APPLICABLE: 'Not applicable',
  UNDER_REVIEW: 'Under review',
};

const WORKER_TONES: Record<WorkerStatus, BadgeTone> = {
  REGISTERED: 'neutral',
  VERIFICATION_PENDING: 'warning',
  ACTIVE: 'success',
  INACTIVE: 'neutral',
  RESTRICTED: 'danger',
  SUSPENDED: 'danger',
  REJECTED: 'danger',
  DEACTIVATED: 'neutral',
};

const WORKER_LABELS: Partial<Record<WorkerStatus, string>> = {
  VERIFICATION_PENDING: 'Verification pending',
};

const CUSTOMER_TONES: Record<CustomerStatus, BadgeTone> = {
  ACTIVE: 'success',
  RESTRICTED: 'danger',
  SUSPENDED: 'danger',
  DEACTIVATED: 'neutral',
};

const SUPPORT_TONES: Record<SupportStatus, BadgeTone> = {
  OPEN: 'warning',
  IN_PROGRESS: 'info',
  WAITING_FOR_USER: 'warning',
  RESOLVED: 'success',
  CLOSED: 'neutral',
};

const SUPPORT_LABELS: Partial<Record<SupportStatus, string>> = {
  IN_PROGRESS: 'In progress',
  WAITING_FOR_USER: 'Waiting for user',
};

const MATERIAL_TONES: Record<MaterialStatus, BadgeTone> = {
  REQUESTED: 'warning',
  CUSTOMER_REVIEW: 'warning',
  APPROVED: 'info',
  REJECTED: 'danger',
  PURCHASED: 'info',
  COST_RECORDED: 'info',
  BILLED: 'success',
  CANCELLED: 'neutral',
};

const MATERIAL_LABELS: Partial<Record<MaterialStatus, string>> = {
  CUSTOMER_REVIEW: 'Customer review',
  COST_RECORDED: 'Cost recorded',
};

const INSURANCE_TONES: Record<InsuranceStatus, BadgeTone> = {
  PENDING: 'warning',
  ACTIVE: 'success',
  EXPIRING_SOON: 'warning',
  EXPIRED: 'danger',
  LAPSED: 'danger',
  CANCELLED: 'neutral',
};

const INSURANCE_LABELS: Partial<Record<InsuranceStatus, string>> = {
  EXPIRING_SOON: 'Expiring soon',
};

const NOTIFICATION_TONES: Record<NotificationStatus, BadgeTone> = {
  QUEUED: 'neutral',
  SENDING: 'info',
  SENT: 'info',
  DELIVERED: 'success',
  FAILED: 'danger',
  CANCELLED: 'neutral',
};

type StatusKind =
  | 'booking'
  | 'payment'
  | 'payout'
  | 'claim'
  | 'verification'
  | 'worker'
  | 'customer'
  | 'support'
  | 'material'
  | 'insurance'
  | 'notification';

const REGISTRY: Record<
  StatusKind,
  { tones: Record<string, BadgeTone>; labels?: Partial<Record<string, string>> }
> = {
  booking: { tones: BOOKING_TONES, labels: BOOKING_LABELS },
  payment: { tones: PAYMENT_TONES },
  payout: { tones: PAYOUT_TONES },
  claim: { tones: CLAIM_TONES, labels: CLAIM_LABELS },
  verification: { tones: VERIFICATION_TONES, labels: VERIFICATION_LABELS },
  worker: { tones: WORKER_TONES, labels: WORKER_LABELS },
  customer: { tones: CUSTOMER_TONES },
  support: { tones: SUPPORT_TONES, labels: SUPPORT_LABELS },
  material: { tones: MATERIAL_TONES, labels: MATERIAL_LABELS },
  insurance: { tones: INSURANCE_TONES, labels: INSURANCE_LABELS },
  notification: { tones: NOTIFICATION_TONES },
};

export interface StatusBadgeProps {
  kind: StatusKind;
  status: string | null | undefined;
  className?: string;
}

export function StatusBadge({ kind, status, className }: StatusBadgeProps) {
  if (!status) {
    return (
      <Badge tone="neutral" className={className}>
        Unknown
      </Badge>
    );
  }

  const entry = REGISTRY[kind];
  const tone = entry.tones[status] ?? 'neutral';
  const label = entry.labels?.[status] ?? humaniseEnum(status);

  return (
    <Badge tone={tone} dot className={className}>
      {label}
    </Badge>
  );
}
