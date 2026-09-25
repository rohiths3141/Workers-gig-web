library;

import '../../core/localization/app_locale.dart';

/// Enumerations mirroring the Postgres types in migration 0001 and 0013.
///
/// Each one parses from the database's wire value and refuses to guess: an
/// unknown value throws rather than silently mapping to a default, because a
/// booking quietly displayed in the wrong state is worse than a visible error.
/// Where a sensible neutral exists it is named explicitly (`unknown`) and the
/// UI treats it as "cannot act".

T _parse<T>(Map<String, T> values, String? raw, String typeName) {
  if (raw == null) {
    throw ArgumentError('Missing $typeName in server response');
  }
  final value = values[raw];
  if (value == null) {
    throw ArgumentError('Unknown $typeName "$raw" from server');
  }
  return value;
}

/// public.worker_status
enum WorkerStatus {
  registered('REGISTERED'),
  verificationPending('VERIFICATION_PENDING'),
  active('ACTIVE'),
  inactive('INACTIVE'),
  restricted('RESTRICTED'),
  suspended('SUSPENDED'),
  rejected('REJECTED'),
  deactivated('DEACTIVATED');

  const WorkerStatus(this.wire);
  final String wire;

  static WorkerStatus parse(String? raw) => _parse(_byWire, raw, 'worker_status');
  static final _byWire = {for (final v in WorkerStatus.values) v.wire: v};

  /// Whether the worker may take on new work at all. Note this is *not* the
  /// same question as "is the worker available" — see [WorkerAvailability].
  bool get canReceiveJobs => this == WorkerStatus.active;

  /// A restricted worker keeps profile, support and gig management; only job
  /// actions are withheld. Hiding the whole app would leave them with no way to
  /// resolve the restriction.
  bool get canUseApp => this != WorkerStatus.deactivated;
}

/// public.worker_availability
enum WorkerAvailability {
  available('AVAILABLE'),
  busy('BUSY'),
  offline('OFFLINE');

  const WorkerAvailability(this.wire);
  final String wire;

  static WorkerAvailability parse(String? raw) =>
      _parse(_byWire, raw, 'worker_availability');
  static final _byWire = {for (final v in WorkerAvailability.values) v.wire: v};

  bool get isAvailable => this == WorkerAvailability.available;
}

/// public.booking_status
enum BookingStatus {
  requested('REQUESTED'),
  accepted('ACCEPTED'),
  confirmed('CONFIRMED'),
  traveling('TRAVELING'),
  arrived('ARRIVED'),
  inProgress('IN_PROGRESS'),
  awaitingApproval('AWAITING_APPROVAL'),
  completed('COMPLETED'),
  paymentPending('PAYMENT_PENDING'),
  paid('PAID'),
  closed('CLOSED'),
  cancelled('CANCELLED'),
  disputed('DISPUTED'),
  expired('EXPIRED');

  const BookingStatus(this.wire);
  final String wire;

  static BookingStatus parse(String? raw) => _parse(_byWire, raw, 'booking_status');
  static final _byWire = {for (final v in BookingStatus.values) v.wire: v};

  /// The job is still open for this worker — either they are doing something
  /// right now, or they are waiting on the customer before it is really over.
  ///
  /// `awaitingApproval` belongs here: the work is done but nothing has settled
  /// yet. Filing it under "Done" claimed more than had happened, and left the
  /// Active tab empty the moment a worker finished a job.
  bool get isActive => const {
        BookingStatus.accepted,
        BookingStatus.confirmed,
        BookingStatus.traveling,
        BookingStatus.arrived,
        BookingStatus.inProgress,
        BookingStatus.awaitingApproval,
      }.contains(this);

  /// Nothing further will happen.
  bool get isTerminal => const {
        BookingStatus.closed,
        BookingStatus.cancelled,
        BookingStatus.expired,
      }.contains(this);

  /// Work is done; what remains is money and paperwork.
  bool get isFinished => const {
        BookingStatus.completed,
        BookingStatus.paymentPending,
        BookingStatus.paid,
        BookingStatus.closed,
      }.contains(this);

  /// The next move this worker can make, if any. The server is authoritative —
  /// this only decides which button to draw, and an attempt is still validated
  /// by `worker_advance_booking`.
  BookingStatus? get workerNextStatus => switch (this) {
        BookingStatus.confirmed => BookingStatus.traveling,
        BookingStatus.traveling => BookingStatus.arrived,
        BookingStatus.arrived => BookingStatus.inProgress,
        BookingStatus.inProgress => BookingStatus.awaitingApproval,
        _ => null,
      };
}

/// public.verification_type
enum VerificationType {
  identityKyc('IDENTITY_KYC'),
  address('ADDRESS'),
  itiCertificate('ITI_CERTIFICATE'),
  diploma('DIPLOMA'),
  rplSkill('RPL_SKILL'),
  backgroundCheck('BACKGROUND_CHECK'),
  insurance('INSURANCE'),
  bankAccount('BANK_ACCOUNT');

  const VerificationType(this.wire);
  final String wire;

  static VerificationType parse(String? raw) =>
      _parse(_byWire, raw, 'verification_type');
  static final _byWire = {for (final v in VerificationType.values) v.wire: v};

  /// Whether the worker submits paperwork, or the platform performs the check.
  /// Drives whether the UI offers an upload or an explanation.
  bool get isWorkerSubmitted => this != VerificationType.backgroundCheck;
}

/// public.verification_status
enum VerificationStatus {
  notSubmitted('NOT_SUBMITTED'),
  pending('PENDING'),
  underReview('UNDER_REVIEW'),
  moreInfoRequired('MORE_INFO_REQUIRED'),
  approved('APPROVED'),
  rejected('REJECTED'),
  expired('EXPIRED'),
  notApplicable('NOT_APPLICABLE');

  const VerificationStatus(this.wire);
  final String wire;

  static VerificationStatus parse(String? raw) =>
      _parse(_byWire, raw, 'verification_status');
  static final _byWire = {for (final v in VerificationStatus.values) v.wire: v};

  /// The worker must do something. Everything else is either done or waiting
  /// on the platform.
  bool get needsWorkerAction => const {
        VerificationStatus.notSubmitted,
        VerificationStatus.moreInfoRequired,
        VerificationStatus.rejected,
        VerificationStatus.expired,
      }.contains(this);

  bool get isWithPlatform => const {
        VerificationStatus.pending,
        VerificationStatus.underReview,
      }.contains(this);

  bool get isApproved => this == VerificationStatus.approved;
}

/// public.gig_status — migration 0013
enum GigStatus {
  draft('DRAFT'),
  pendingReview('PENDING_REVIEW'),
  active('ACTIVE'),
  paused('PAUSED'),
  rejected('REJECTED'),
  archived('ARCHIVED');

  const GigStatus(this.wire);
  final String wire;

  static GigStatus parse(String? raw) => _parse(_byWire, raw, 'gig_status');
  static final _byWire = {for (final v in GigStatus.values) v.wire: v};

  /// Live and matchable. Independent of whether the worker is available.
  bool get isLive => this == GigStatus.active;

  bool get isEditable => this != GigStatus.archived;

  /// Only a paused gig can be resumed by the worker; a draft or rejected gig
  /// has to be resubmitted. Mirrors `worker_set_gig_status`.
  bool get canResume => this == GigStatus.paused;

  bool get canPause => this == GigStatus.active;
}

/// public.material_status
enum MaterialStatus {
  requested('REQUESTED'),
  customerReview('CUSTOMER_REVIEW'),
  approved('APPROVED'),
  rejected('REJECTED'),
  purchased('PURCHASED'),
  costRecorded('COST_RECORDED'),
  billed('BILLED'),
  cancelled('CANCELLED');

  const MaterialStatus(this.wire);
  final String wire;

  static MaterialStatus parse(String? raw) => _parse(_byWire, raw, 'material_status');
  static final _byWire = {for (final v in MaterialStatus.values) v.wire: v};

  bool get isAwaitingCustomer => const {
        MaterialStatus.requested,
        MaterialStatus.customerReview,
      }.contains(this);

  /// The worker may now buy it and record what it cost.
  bool get canRecordCost => const {
        MaterialStatus.approved,
        MaterialStatus.purchased,
      }.contains(this);
}

/// public.wallet_transaction_type
enum WalletTransactionType {
  creditJobEarning('CREDIT_JOB_EARNING'),
  creditMaterialReimbursement('CREDIT_MATERIAL_REIMBURSEMENT'),
  creditAdjustment('CREDIT_ADJUSTMENT'),
  creditPayoutReversal('CREDIT_PAYOUT_REVERSAL'),
  debitPlatformFee('DEBIT_PLATFORM_FEE'),
  debitPayout('DEBIT_PAYOUT'),
  debitAdjustment('DEBIT_ADJUSTMENT'),
  debitClaimRecovery('DEBIT_CLAIM_RECOVERY');

  const WalletTransactionType(this.wire);
  final String wire;

  static WalletTransactionType parse(String? raw) =>
      _parse(_byWire, raw, 'wallet_transaction_type');
  static final _byWire = {for (final v in WalletTransactionType.values) v.wire: v};

  bool get isCredit => wire.startsWith('CREDIT');
}

/// public.payout_status
enum PayoutStatus {
  requested('REQUESTED'),
  processing('PROCESSING'),
  completed('COMPLETED'),
  failed('FAILED'),
  rejected('REJECTED');

  const PayoutStatus(this.wire);
  final String wire;

  static PayoutStatus parse(String? raw) => _parse(_byWire, raw, 'payout_status');
  static final _byWire = {for (final v in PayoutStatus.values) v.wire: v};

  /// Money has actually left the platform. Nothing else may claim it has.
  bool get isSettled => this == PayoutStatus.completed;

  bool get isInFlight => const {
        PayoutStatus.requested,
        PayoutStatus.processing,
      }.contains(this);
}

/// public.support_status
enum SupportStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  waitingForUser('WAITING_FOR_USER'),
  resolved('RESOLVED'),
  closed('CLOSED');

  const SupportStatus(this.wire);
  final String wire;

  static SupportStatus parse(String? raw) => _parse(_byWire, raw, 'support_status');
  static final _byWire = {for (final v in SupportStatus.values) v.wire: v};

  bool get isOpen => this != SupportStatus.closed && this != SupportStatus.resolved;
  bool get needsWorkerReply => this == SupportStatus.waitingForUser;
}

/// public.support_category
enum SupportCategory {
  booking('BOOKING'),
  payment('PAYMENT'),
  payout('PAYOUT'),
  verification('VERIFICATION'),
  account('ACCOUNT'),
  safety('SAFETY'),
  claim('CLAIM'),
  appIssue('APP_ISSUE'),
  other('OTHER');

  const SupportCategory(this.wire);
  final String wire;

  static SupportCategory parse(String? raw) =>
      _parse(_byWire, raw, 'support_category');
  static final _byWire = {for (final v in SupportCategory.values) v.wire: v};
}

/// public.claim_status
enum ClaimStatus {
  submitted('SUBMITTED'),
  underReview('UNDER_REVIEW'),
  moreInformationRequired('MORE_INFORMATION_REQUIRED'),
  approved('APPROVED'),
  partiallyApproved('PARTIALLY_APPROVED'),
  rejected('REJECTED'),
  closed('CLOSED');

  const ClaimStatus(this.wire);
  final String wire;

  static ClaimStatus parse(String? raw) => _parse(_byWire, raw, 'claim_status');
  static final _byWire = {for (final v in ClaimStatus.values) v.wire: v};

  bool get needsWorkerResponse => this == ClaimStatus.moreInformationRequired;
}

/// public.insurance_status
enum InsuranceStatus {
  pending('PENDING'),
  active('ACTIVE'),
  expiringSoon('EXPIRING_SOON'),
  expired('EXPIRED'),
  lapsed('LAPSED'),
  cancelled('CANCELLED');

  const InsuranceStatus(this.wire);
  final String wire;

  static InsuranceStatus parse(String? raw) =>
      _parse(_byWire, raw, 'insurance_status');
  static final _byWire = {for (final v in InsuranceStatus.values) v.wire: v};

  /// Whether coverage is genuinely in force. The app never implies cover from
  /// the mere existence of a policy row.
  bool get isCovering => const {
        InsuranceStatus.active,
        InsuranceStatus.expiringSoon,
      }.contains(this);
}

/// public.media_purpose.
///
/// Every value, not just the ones a worker can create. `getAssets` filters by
/// booking or worker and only optionally by purpose, so it returns whatever is
/// attached — and [parse] throws on anything it does not know. A worker cannot
/// upload a background-check file, but one attached to them by operations comes
/// back in their own document list, and that was enough to throw
/// "Unknown media_purpose" on a screen the worker did nothing wrong to reach.
enum MediaPurpose {
  workerProfilePhoto('WORKER_PROFILE_PHOTO'),
  workerKycDocument('WORKER_KYC_DOCUMENT'),
  workerQualification('WORKER_QUALIFICATION'),
  workerRplCredential('WORKER_RPL_CREDENTIAL'),
  workerBackgroundCheck('WORKER_BACKGROUND_CHECK'),
  workerInsuranceDocument('WORKER_INSURANCE_DOCUMENT'),
  customerProfilePhoto('CUSTOMER_PROFILE_PHOTO'),
  bookingBeforeWork('BOOKING_BEFORE_WORK'),
  bookingDuringWork('BOOKING_DURING_WORK'),
  bookingAfterWork('BOOKING_AFTER_WORK'),
  bookingArrivalProof('BOOKING_ARRIVAL_PROOF'),
  bookingMaterialPhoto('BOOKING_MATERIAL_PHOTO'),
  bookingReceipt('BOOKING_RECEIPT'),
  claimEvidence('CLAIM_EVIDENCE'),
  supportAttachment('SUPPORT_ATTACHMENT'),
  serviceCatalogueImage('SERVICE_CATALOGUE_IMAGE'),
  serviceRequestPhoto('SERVICE_REQUEST_PHOTO');

  const MediaPurpose(this.wire);
  final String wire;

  static MediaPurpose parse(String? raw) => _parse(_byWire, raw, 'media_purpose');
  static final _byWire = {for (final v in MediaPurpose.values) v.wire: v};
}

/// public.media_upload_status
enum MediaUploadStatus {
  pending('PENDING'),
  uploading('UPLOADING'),
  completed('COMPLETED'),
  failed('FAILED'),
  quarantined('QUARANTINED'),
  deleted('DELETED');

  const MediaUploadStatus(this.wire);
  final String wire;

  static MediaUploadStatus parse(String? raw) =>
      _parse(_byWire, raw, 'media_upload_status');
  static final _byWire = {for (final v in MediaUploadStatus.values) v.wire: v};

  /// Only a completed upload counts as evidence. A pending row is not proof of
  /// anything, and the server agrees.
  bool get isUsable => this == MediaUploadStatus.completed;
}

/// worker_gigs.pricing_unit
enum PricingUnit {
  perJob('PER_JOB'),
  perHour('PER_HOUR'),
  perDay('PER_DAY'),
  perUnit('PER_UNIT'),
  perSqft('PER_SQFT');

  const PricingUnit(this.wire);
  final String wire;

  static PricingUnit parse(String? raw) => _parse(_byWire, raw, 'pricing_unit');
  static final _byWire = {for (final v in PricingUnit.values) v.wire: v};
}

// ---------------------------------------------------------------------------
// Model B: Customer Service Requests
// ---------------------------------------------------------------------------

/// public.service_request_status
enum ServiceRequestStatus {
  draft('DRAFT'),
  open('OPEN'),
  receivingOffers('RECEIVING_OFFERS'),
  workerSelected('WORKER_SELECTED'),
  booked('BOOKED'),
  cancelled('CANCELLED'),
  expired('EXPIRED'),
  closed('CLOSED');

  const ServiceRequestStatus(this.wire);
  final String wire;

  static ServiceRequestStatus parse(String? raw) =>
      _parse(_byWire, raw, 'service_request_status');
  static final _byWire = {for (final v in ServiceRequestStatus.values) v.wire: v};

  bool get isOpen => this == open || this == receivingOffers;
}

/// public.budget_type
enum BudgetType {
  none('NONE'),
  fixed('FIXED'),
  range('RANGE');

  const BudgetType(this.wire);
  final String wire;

  static BudgetType parse(String? raw) => _parse(_byWire, raw, 'budget_type');
  static final _byWire = {for (final v in BudgetType.values) v.wire: v};

  String get label {
    final l10n = AppStrings.current;
    return switch (this) {
      BudgetType.none => l10n.budgetTypeFlexible,
      BudgetType.fixed => l10n.budgetTypeFixed,
      BudgetType.range => l10n.budgetTypeRange,
    };
  }
}

/// public.schedule_type
enum ScheduleType {
  asap('ASAP'),
  today('TODAY'),
  tomorrow('TOMORROW'),
  specificDate('SPECIFIC_DATE');

  const ScheduleType(this.wire);
  final String wire;

  static ScheduleType parse(String? raw) =>
      _parse(_byWire, raw, 'schedule_type');
  static final _byWire = {for (final v in ScheduleType.values) v.wire: v};

  String get label {
    final l10n = AppStrings.current;
    return switch (this) {
      ScheduleType.asap => l10n.scheduleAsap,
      ScheduleType.today => l10n.scheduleToday,
      ScheduleType.tomorrow => l10n.scheduleTomorrow,
      ScheduleType.specificDate => l10n.scheduleSpecificDate,
    };
  }
}

/// public.offer_status
enum OfferStatus {
  submitted('SUBMITTED'),
  viewed('VIEWED'),
  shortlisted('SHORTLISTED'),
  accepted('ACCEPTED'),
  rejected('REJECTED'),
  withdrawn('WITHDRAWN'),
  expired('EXPIRED'),
  closed('CLOSED');

  const OfferStatus(this.wire);
  final String wire;

  static OfferStatus parse(String? raw) =>
      _parse(_byWire, raw, 'offer_status');
  static final _byWire = {for (final v in OfferStatus.values) v.wire: v};

  bool get isPending => const {
        OfferStatus.submitted,
        OfferStatus.viewed,
        OfferStatus.shortlisted,
      }.contains(this);

  bool get isTerminal => const {
        OfferStatus.accepted,
        OfferStatus.rejected,
        OfferStatus.withdrawn,
        OfferStatus.expired,
        OfferStatus.closed,
      }.contains(this);

  String get workerLabel {
    final l10n = AppStrings.current;
    return switch (this) {
      OfferStatus.submitted => l10n.offerStatusSubmitted,
      OfferStatus.viewed => l10n.offerStatusViewed,
      OfferStatus.shortlisted => l10n.offerStatusShortlisted,
      OfferStatus.accepted => l10n.offerStatusAccepted,
      OfferStatus.rejected => l10n.offerStatusRejected,
      OfferStatus.withdrawn => l10n.offerStatusWithdrawn,
      OfferStatus.expired => l10n.offerStatusExpired,
      OfferStatus.closed => l10n.offerStatusClosed,
    };
  }
}

/// public.booking_source
enum BookingSource {
  directGig('DIRECT_GIG'),
  customerRequest('CUSTOMER_REQUEST');

  const BookingSource(this.wire);
  final String wire;

  static BookingSource parse(String? raw) =>
      _parse(_byWire, raw, 'booking_source');
  static final _byWire = {for (final v in BookingSource.values) v.wire: v};
}

