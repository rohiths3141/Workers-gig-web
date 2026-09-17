/**
 * Supabase database types.
 *
 * Hand-maintained to match supabase/migrations. Regenerate against a running
 * database with:
 *
 *     npm run db:types
 *
 * which runs `supabase gen types typescript --local` and overwrites this file.
 * Until then this definition is the contract the application compiles against,
 * and tests/domain-enums.test.ts checks the enum members against the migrations.
 */

import type {
  ActorType,
  AdminRole,
  BookingEventType,
  BookingStatus,
  ClaimStatus,
  ClaimType,
  ContactMessageStatus,
  CustomerStatus,
  InsuranceStatus,
  MaterialStatus,
  MediaPurpose,
  MediaSensitivity,
  MediaType,
  MediaUploadStatus,
  NotificationChannel,
  NotificationStatus,
  PaymentStatus,
  PayoutStatus,
  ProfileRole,
  ProfileStatus,
  SupportCategory,
  SupportPriority,
  SupportStatus,
  VerificationStatus,
  VerificationType,
  WalletTransactionType,
  WorkerAvailability,
  WorkerStatus,
} from './domain';

export type Json = string | number | boolean | null | { [key: string]: Json } | Json[];

/** Reads are fully typed; writes go through RPCs, so Insert/Update stay loose. */
type Table<Row> = {
  Row: Row;
  Insert: Partial<Row>;
  Update: Partial<Row>;
  Relationships: [];
};

// ---------------------------------------------------------------------------
// Row shapes
// ---------------------------------------------------------------------------

export type ProfileRow = {
  id: string;
  firebase_uid: string;
  role: ProfileRole;
  account_status: ProfileStatus;
  email: string | null;
  phone: string | null;
  display_name: string | null;
  last_login_at: string | null;
  created_at: string;
  updated_at: string;
};

export type AdminUserRow = {
  id: string;
  profile_id: string;
  firebase_uid: string;
  email: string;
  full_name: string;
  role: AdminRole;
  is_active: boolean;
  phone: string | null;
  avatar_media_id: string | null;
  last_login_at: string | null;
  permissions_version: number;
  created_by: string | null;
  created_at: string;
  updated_at: string;
};

export type PermissionRow = {
  key: string;
  resource: string;
  action: string;
  description: string;
  is_sensitive: boolean;
};

export type RolePermissionRow = {
  role: AdminRole;
  permission: string;
};

export type AdminUserPermissionRow = {
  admin_id: string;
  permission: string;
  granted: boolean;
  reason: string | null;
  created_by: string | null;
  created_at: string;
};

export type ServiceRow = {
  id: string;
  name: string;
  slug: string;
  short_description: string;
  description: string | null;
  icon_key: string;
  image_media_id: string | null;
  is_active: boolean;
  display_order: number;
  base_visit_fee_minor: number | null;
  currency: string;
  required_verifications: VerificationType[];
  seo_title: string | null;
  seo_description: string | null;
  created_at: string;
  updated_at: string;
};

export type ServiceProblemRow = {
  id: string;
  service_id: string;
  title: string;
  description: string | null;
  display_order: number;
};

export type FaqRow = {
  id: string;
  service_id: string | null;
  category: string;
  question: string;
  answer: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
};

export type CustomerRow = {
  id: string;
  profile_id: string;
  firebase_uid: string;
  full_name: string;
  phone: string;
  email: string | null;
  status: CustomerStatus;
  city: string | null;
  state: string | null;
  pincode: string | null;
  address_line: string | null;
  latitude: number | null;
  longitude: number | null;
  rating_avg: number | null;
  rating_count: number;
  restriction_reason: string | null;
  restricted_at: string | null;
  restricted_by: string | null;
  profile_media_id: string | null;
  created_at: string;
  updated_at: string;
};

export type WorkerRow = {
  id: string;
  profile_id: string;
  firebase_uid: string;
  worker_code: string;
  full_name: string;
  phone: string;
  email: string | null;
  status: WorkerStatus;
  availability: WorkerAvailability;
  primary_service_id: string | null;
  experience_years: number;
  bio: string | null;
  city: string | null;
  state: string | null;
  pincode: string | null;
  address_line: string | null;
  latitude: number | null;
  longitude: number | null;
  service_radius_km: number;
  rating_avg: number | null;
  rating_count: number;
  jobs_completed: number;
  jobs_cancelled: number;
  is_kyc_verified: boolean;
  is_qualification_verified: boolean;
  is_skill_verified: boolean;
  is_background_verified: boolean;
  is_insured: boolean;
  verified_at: string | null;
  restriction_reason: string | null;
  restricted_at: string | null;
  restricted_by: string | null;
  profile_media_id: string | null;
  last_active_at: string | null;
  created_at: string;
  updated_at: string;
};

export type WorkerPublicCardRow = {
  id: string;
  worker_code: string;
  full_name: string;
  primary_service_id: string | null;
  experience_years: number;
  bio: string | null;
  city: string | null;
  state: string | null;
  rating_avg: number | null;
  rating_count: number;
  jobs_completed: number;
  is_kyc_verified: boolean;
  is_qualification_verified: boolean;
  is_skill_verified: boolean;
  is_background_verified: boolean;
  is_insured: boolean;
  verified_at: string | null;
  profile_media_id: string | null;
};

export type WorkerServiceRow = {
  worker_id: string;
  service_id: string;
  is_approved: boolean;
  approved_by: string | null;
  approved_at: string | null;
  created_at: string;
};

export type WorkerVerificationRow = {
  id: string;
  worker_id: string;
  type: VerificationType;
  status: VerificationStatus;
  details: Json;
  submitted_at: string | null;
  reviewed_by: string | null;
  reviewed_at: string | null;
  assigned_to: string | null;
  assigned_at: string | null;
  decision_note: string | null;
  rejection_reason: string | null;
  info_requested: string | null;
  expires_at: string | null;
  provider: string | null;
  provider_reference: string | null;
  created_at: string;
  updated_at: string;
};

export type InsurancePolicyRow = {
  id: string;
  worker_id: string;
  provider_name: string;
  policy_number: string;
  coverage_amount_minor: number;
  currency: string;
  premium_amount_minor: number | null;
  start_date: string;
  end_date: string;
  status: InsuranceStatus;
  document_media_id: string | null;
  notes: string | null;
  recorded_by: string | null;
  created_at: string;
  updated_at: string;
};

export type BookingRow = {
  id: string;
  booking_code: string;
  customer_id: string;
  worker_id: string | null;
  service_id: string;
  status: BookingStatus;
  problem_description: string;
  scheduled_at: string | null;
  address_line: string;
  city: string | null;
  state: string | null;
  pincode: string | null;
  latitude: number | null;
  longitude: number | null;
  quoted_amount_minor: number | null;
  labour_amount_minor: number | null;
  material_amount_minor: number;
  platform_fee_minor: number;
  worker_amount_minor: number | null;
  final_amount_minor: number | null;
  currency: string;
  arrival_code: string | null;
  arrival_verified_at: string | null;
  accepted_at: string | null;
  confirmed_at: string | null;
  travel_started_at: string | null;
  arrived_at: string | null;
  work_started_at: string | null;
  completed_at: string | null;
  paid_at: string | null;
  closed_at: string | null;
  cancelled_at: string | null;
  cancelled_by_type: ActorType | null;
  cancellation_reason: string | null;
  dispute_reason: string | null;
  disputed_at: string | null;
  created_at: string;
  updated_at: string;
};

export type BookingEventRow = {
  id: number;
  booking_id: string;
  event_type: BookingEventType;
  from_status: BookingStatus | null;
  to_status: BookingStatus | null;
  actor_type: ActorType;
  actor_id: string | null;
  note: string | null;
  metadata: Json;
  created_at: string;
};

export type BookingTransitionRow = {
  from_status: BookingStatus;
  to_status: BookingStatus;
  allowed_actors: ActorType[];
  event_type: BookingEventType;
  requires_reason: boolean;
  description: string;
};

export type BookingMatchCandidateRow = {
  id: string;
  booking_id: string;
  worker_id: string;
  distance_km: number;
  trade_match_score: number;
  skill_score: number;
  qualification_score: number;
  kyc_score: number;
  background_score: number;
  insurance_score: number;
  availability_score: number;
  rating_score: number;
  proximity_score: number;
  total_score: number;
  rank: number;
  was_offered: boolean;
  offered_at: string | null;
  response: string | null;
  responded_at: string | null;
  scoring_snapshot: Json;
  created_at: string;
};

export type MaterialRow = {
  id: string;
  booking_id: string;
  worker_id: string;
  name: string;
  description: string | null;
  quantity: number;
  unit: string;
  estimated_cost_minor: number;
  actual_cost_minor: number | null;
  currency: string;
  status: MaterialStatus;
  customer_decision_at: string | null;
  customer_rejection_reason: string | null;
  purchased_at: string | null;
  cost_recorded_at: string | null;
  billed_at: string | null;
  receipt_media_id: string | null;
  created_at: string;
  updated_at: string;
};

export type RatingRow = {
  id: string;
  booking_id: string;
  rater_type: ActorType;
  worker_id: string;
  customer_id: string;
  rating: number;
  comment: string | null;
  is_hidden: boolean;
  hidden_reason: string | null;
  hidden_by: string | null;
  created_at: string;
};

export type PaymentRow = {
  id: string;
  payment_code: string;
  booking_id: string;
  customer_id: string;
  amount_minor: number;
  platform_fee_minor: number;
  worker_amount_minor: number;
  material_amount_minor: number;
  currency: string;
  status: PaymentStatus;
  method: string | null;
  gateway: string;
  gateway_order_id: string | null;
  gateway_payment_id: string | null;
  gateway_signature_verified: boolean;
  gateway_verified_at: string | null;
  gateway_payload: Json;
  idempotency_key: string;
  failure_code: string | null;
  failure_reason: string | null;
  refunded_amount_minor: number;
  initiated_at: string;
  captured_at: string | null;
  failed_at: string | null;
  created_at: string;
  updated_at: string;
};

export type RefundRow = {
  id: string;
  payment_id: string;
  amount_minor: number;
  currency: string;
  reason: string;
  status: PaymentStatus;
  gateway_refund_id: string | null;
  gateway_payload: Json;
  idempotency_key: string;
  requested_by: string | null;
  completed_at: string | null;
  failure_reason: string | null;
  created_at: string;
  updated_at: string;
};

export type WalletRow = {
  id: string;
  worker_id: string;
  balance_minor: number;
  total_credited_minor: number;
  total_debited_minor: number;
  currency: string;
  is_frozen: boolean;
  frozen_reason: string | null;
  frozen_by: string | null;
  last_transaction_at: string | null;
  created_at: string;
  updated_at: string;
};

export type WalletTransactionRow = {
  id: string;
  wallet_id: string;
  worker_id: string;
  type: WalletTransactionType;
  amount_minor: number;
  balance_after_minor: number;
  currency: string;
  description: string;
  reference_type: string | null;
  reference_id: string | null;
  idempotency_key: string;
  created_by_type: ActorType;
  created_by_id: string | null;
  reason: string | null;
  created_at: string;
};

export type PayoutRow = {
  id: string;
  payout_code: string;
  worker_id: string;
  wallet_id: string;
  amount_minor: number;
  currency: string;
  status: PayoutStatus;
  method: string;
  account_last4: string | null;
  account_holder_name: string | null;
  bank_name: string | null;
  gateway: string | null;
  gateway_payout_id: string | null;
  gateway_payload: Json;
  idempotency_key: string;
  requested_at: string;
  decided_by: string | null;
  decided_at: string | null;
  decision_reason: string | null;
  processed_at: string | null;
  completed_at: string | null;
  failure_reason: string | null;
  ledger_transaction_id: string | null;
  created_at: string;
  updated_at: string;
};

export type ClaimRow = {
  id: string;
  claim_code: string;
  booking_id: string;
  customer_id: string;
  worker_id: string | null;
  type: ClaimType;
  status: ClaimStatus;
  incident_at: string;
  description: string;
  amount_claimed_minor: number;
  amount_approved_minor: number | null;
  currency: string;
  assigned_to: string | null;
  assigned_at: string | null;
  decided_by: string | null;
  decided_at: string | null;
  decision_note: string | null;
  rejection_reason: string | null;
  info_requested: string | null;
  insurance_policy_id: string | null;
  insurer_reference: string | null;
  insurer_decision: string | null;
  insurer_decided_at: string | null;
  recovery_transaction_id: string | null;
  closed_at: string | null;
  created_at: string;
  updated_at: string;
};

export type ClaimEventRow = {
  id: number;
  claim_id: string;
  from_status: ClaimStatus | null;
  to_status: ClaimStatus | null;
  actor_type: ActorType;
  actor_admin_id: string | null;
  note: string | null;
  metadata: Json;
  created_at: string;
};

export type SupportTicketRow = {
  id: string;
  ticket_code: string;
  subject: string;
  category: SupportCategory;
  priority: SupportPriority;
  status: SupportStatus;
  requester_type: ActorType;
  customer_id: string | null;
  worker_id: string | null;
  booking_id: string | null;
  claim_id: string | null;
  assigned_admin_id: string | null;
  assigned_at: string | null;
  first_response_at: string | null;
  last_message_at: string;
  resolved_at: string | null;
  closed_at: string | null;
  resolution_note: string | null;
  created_at: string;
  updated_at: string;
};

export type SupportMessageRow = {
  id: string;
  ticket_id: string;
  author_type: ActorType;
  author_admin_id: string | null;
  author_profile_id: string | null;
  body: string;
  is_internal: boolean;
  created_at: string;
};

export type NotificationRow = {
  id: string;
  recipient_type: ActorType;
  recipient_profile_id: string | null;
  recipient_firebase_uid: string | null;
  channel: NotificationChannel;
  template_key: string;
  title: string;
  body: string;
  payload: Json;
  status: NotificationStatus;
  provider: string | null;
  provider_message_id: string | null;
  idempotency_key: string;
  queued_at: string;
  sent_at: string | null;
  delivered_at: string | null;
  failed_at: string | null;
  failure_reason: string | null;
  attempt_count: number;
  read_at: string | null;
  created_by_type: ActorType;
  created_by_admin_id: string | null;
  created_at: string;
};

export type AuditLogRow = {
  id: number;
  actor_type: ActorType;
  actor_admin_id: string | null;
  actor_email: string | null;
  actor_role: AdminRole | null;
  actor_firebase_uid: string | null;
  action: string;
  resource_type: string;
  resource_id: string | null;
  before_state: Json | null;
  after_state: Json | null;
  reason: string | null;
  ip_address: string | null;
  user_agent: string | null;
  request_id: string | null;
  outcome: 'SUCCESS' | 'FAILURE';
  error_message: string | null;
  created_at: string;
};

export type PlatformSettingRow = {
  key: string;
  value: Json;
  description: string;
  is_public: boolean;
  updated_by: string | null;
  updated_at: string;
};

export type ContactMessageRow = {
  id: string;
  name: string;
  email: string;
  phone: string | null;
  subject: string;
  message: string;
  status: ContactMessageStatus;
  ip_hash: string | null;
  user_agent: string | null;
  handled_by: string | null;
  handled_at: string | null;
  internal_note: string | null;
  created_at: string;
};

export type MediaAssetRow = {
  id: string;
  firebase_storage_path: string;
  storage_bucket: string;
  media_type: MediaType;
  purpose: MediaPurpose;
  sensitivity: MediaSensitivity;
  upload_status: MediaUploadStatus;
  uploaded_by_type: ActorType;
  uploaded_by_firebase_uid: string | null;
  uploaded_by_profile_id: string | null;
  worker_id: string | null;
  customer_id: string | null;
  verification_id: string | null;
  booking_id: string | null;
  material_id: string | null;
  claim_id: string | null;
  support_ticket_id: string | null;
  service_id: string | null;
  original_file_name: string;
  mime_type: string;
  file_size_bytes: number;
  checksum_sha256: string | null;
  width: number | null;
  height: number | null;
  duration_seconds: number | null;
  captured_at: string | null;
  completed_at: string | null;
  failure_reason: string | null;
  deleted_at: string | null;
  deleted_by: string | null;
  created_at: string;
  updated_at: string;
};

export type MediaPurposeRuleRow = {
  purpose: MediaPurpose;
  path_root: string;
  path_folder: string;
  owner_column: string;
  sensitivity: MediaSensitivity;
  required_permission: string;
  allowed_mime_types: string[];
  max_size_bytes: number;
};

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

export interface Database {
  public: {
    Tables: {
      profiles: Table<ProfileRow>;
      admin_users: Table<AdminUserRow>;
      permissions: Table<PermissionRow>;
      role_permissions: Table<RolePermissionRow>;
      admin_user_permissions: Table<AdminUserPermissionRow>;
      services: Table<ServiceRow>;
      service_problems: Table<ServiceProblemRow>;
      faqs: Table<FaqRow>;
      customers: Table<CustomerRow>;
      workers: Table<WorkerRow>;
      worker_services: Table<WorkerServiceRow>;
      worker_verifications: Table<WorkerVerificationRow>;
      insurance_policies: Table<InsurancePolicyRow>;
      bookings: Table<BookingRow>;
      booking_events: Table<BookingEventRow>;
      booking_transitions: Table<BookingTransitionRow>;
      booking_match_candidates: Table<BookingMatchCandidateRow>;
      materials: Table<MaterialRow>;
      ratings: Table<RatingRow>;
      payments: Table<PaymentRow>;
      refunds: Table<RefundRow>;
      wallets: Table<WalletRow>;
      wallet_transactions: Table<WalletTransactionRow>;
      payouts: Table<PayoutRow>;
      claims: Table<ClaimRow>;
      claim_events: Table<ClaimEventRow>;
      support_tickets: Table<SupportTicketRow>;
      support_messages: Table<SupportMessageRow>;
      notifications: Table<NotificationRow>;
      audit_logs: Table<AuditLogRow>;
      platform_settings: Table<PlatformSettingRow>;
      contact_messages: Table<ContactMessageRow>;
      media_assets: Table<MediaAssetRow>;
      media_purpose_rules: Table<MediaPurposeRuleRow>;
    };
    Views: {
      worker_public_cards: {
        Row: WorkerPublicCardRow;
        Relationships: [];
      };
    };
    Functions: {
      // Worker app contracts. See supabase/migrations/0013.
      worker_complete_media_upload: {
        Args: { p_media_id: string };
        Returns: MediaAssetRow;
      };
      worker_fail_media_upload: {
        Args: { p_media_id: string; p_reason: string };
        Returns: undefined;
      };
      admin_has_permission: {
        Args: { p_permission: string };
        Returns: boolean;
      };
      admin_permissions: {
        Args: { p_admin_id: string };
        Returns: string[];
      };
      admin_transition_booking: {
        Args: { p_booking_id: string; p_to_status: BookingStatus; p_reason: string };
        Returns: BookingRow;
      };
      admin_open_background_check: {
        Args: { p_worker_id: string };
        Returns: WorkerVerificationRow;
      };
      decide_verification: {
        Args: {
          p_verification_id: string;
          p_decision: 'APPROVE' | 'REJECT' | 'REQUEST_INFO' | 'TAKE_REVIEW';
          p_note?: string | null;
          p_rejection_reason?: string | null;
          p_info_requested?: string | null;
          p_expires_at?: string | null;
        };
        Returns: WorkerVerificationRow;
      };
      decide_payout: {
        Args: { p_payout_id: string; p_decision: 'APPROVE' | 'REJECT'; p_reason?: string | null };
        Returns: PayoutRow;
      };
      decide_claim: {
        Args: {
          p_claim_id: string;
          p_decision:
            | 'TAKE_REVIEW'
            | 'REQUEST_INFO'
            | 'APPROVE'
            | 'PARTIALLY_APPROVE'
            | 'REJECT'
            | 'CLOSE';
          p_amount_minor?: number | null;
          p_note?: string | null;
          p_reason?: string | null;
        };
        Returns: ClaimRow;
      };
      admin_adjust_wallet: {
        Args: {
          p_worker_id: string;
          p_amount_minor: number;
          p_direction: 'CREDIT' | 'DEBIT';
          p_reason: string;
          p_idempotency_key: string;
        };
        Returns: WalletTransactionRow;
      };
      admin_set_worker_status: {
        Args: { p_worker_id: string; p_status: WorkerStatus; p_reason: string };
        Returns: WorkerRow;
      };
      admin_set_customer_status: {
        Args: { p_customer_id: string; p_status: CustomerStatus; p_reason: string };
        Returns: CustomerRow;
      };
      admin_rerun_matching: {
        Args: { p_booking_id: string };
        Returns: BookingMatchCandidateRow[];
      };
      admin_post_support_message: {
        Args: { p_ticket_id: string; p_body: string; p_is_internal?: boolean };
        Returns: SupportMessageRow;
      };
      admin_set_ticket_status: {
        Args: { p_ticket_id: string; p_status: SupportStatus; p_note?: string | null };
        Returns: SupportTicketRow;
      };
      admin_assign_ticket: {
        Args: { p_ticket_id: string; p_admin_id: string };
        Returns: SupportTicketRow;
      };
      write_audit_log: {
        Args: {
          p_action: string;
          p_resource_type: string;
          p_resource_id?: string | null;
          p_before?: Json | null;
          p_after?: Json | null;
          p_reason?: string | null;
          p_outcome?: string;
          p_error?: string | null;
        };
        Returns: number;
      };
    };
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
}
