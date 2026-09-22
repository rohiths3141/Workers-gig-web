library;

/// Enumerations mirroring the Postgres types.
///
/// Customer-app enums that are shared with the worker side (BookingStatus,
/// MaterialStatus, SupportStatus, etc.) are included here, adapted to the
/// customer's perspective (e.g. no WorkerStatus enum needed here).

T _parse<T>(Map<String, T> values, String? raw, String typeName) {
  if (raw == null) throw ArgumentError('Missing $typeName in server response');
  final value = values[raw];
  if (value == null) throw ArgumentError('Unknown $typeName "$raw" from server');
  return value;
}

/// public.customer_status
enum CustomerStatus {
  active('ACTIVE'),
  restricted('RESTRICTED'),
  suspended('SUSPENDED'),
  deactivated('DEACTIVATED');

  const CustomerStatus(this.wire);
  final String wire;

  static CustomerStatus parse(String? raw) =>
      _parse(_byWire, raw, 'customer_status');
  static final _byWire = {for (final v in CustomerStatus.values) v.wire: v};

  bool get canUseApp => this != CustomerStatus.deactivated;
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

  static BookingStatus parse(String? raw) =>
      _parse(_byWire, raw, 'booking_status');
  static final _byWire = {for (final v in BookingStatus.values) v.wire: v};

  /// A booking that is still running, from the customer's point of view.
  ///
  /// Includes REQUESTED. The worker app excludes it on purpose — an unassigned
  /// booking is not that worker's job yet, it is an offer — but for the person
  /// who placed it, REQUESTED is the most active a booking ever gets: they have
  /// paid and are waiting to be matched. Leaving it out meant a customer booked,
  /// paid, returned to Home and found nothing there at all, because
  /// `activeBookingsProvider` filters on this.
  ///
  /// Includes awaiting approval: the job is finished but the money has not
  /// moved and the customer has something to do, so it must keep its place on
  /// Home and in the Active tab.
  ///
  /// DISPUTED is deliberately absent — the bookings list gives it its own tab.
  bool get isActive => const {
        BookingStatus.requested,
        BookingStatus.accepted,
        BookingStatus.confirmed,
        BookingStatus.traveling,
        BookingStatus.arrived,
        BookingStatus.inProgress,
        BookingStatus.awaitingApproval,
      }.contains(this);

  bool get isTerminal => const {
        BookingStatus.closed,
        BookingStatus.cancelled,
        BookingStatus.expired,
      }.contains(this);

  bool get isFinished => const {
        BookingStatus.completed,
        BookingStatus.paymentPending,
        BookingStatus.paid,
        BookingStatus.closed,
      }.contains(this);

  /// The customer needs to do something right now.
  bool get needsCustomerAction => const {
        BookingStatus.awaitingApproval,
      }.contains(this);

  /// Live tracking is meaningful for the customer.
  bool get showLiveTracking => const {
        BookingStatus.traveling,
        BookingStatus.arrived,
        BookingStatus.inProgress,
      }.contains(this);

  String get displayName => customerLabel;

  /// Friendly one-line label for the customer.
  String get customerLabel => switch (this) {
        BookingStatus.requested => 'Finding a professional…',
        BookingStatus.accepted => 'Professional found',
        BookingStatus.confirmed => 'Confirmed',
        BookingStatus.traveling => 'On the way',
        BookingStatus.arrived => 'Arrived — enter your code',
        BookingStatus.inProgress => 'Work in progress',
        BookingStatus.awaitingApproval => 'Work done — approve to proceed',
        BookingStatus.completed => 'Completed',
        BookingStatus.paymentPending => 'Payment pending',
        BookingStatus.paid => 'Paid',
        BookingStatus.closed => 'Closed',
        BookingStatus.cancelled => 'Cancelled',
        BookingStatus.disputed => 'Disputed',
        BookingStatus.expired => 'Expired — no one was available',
      };
}

/// public.gig_status — customer only reads ACTIVE gigs
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

  bool get isLive => this == GigStatus.active;
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

  static MaterialStatus parse(String? raw) =>
      _parse(_byWire, raw, 'material_status');
  static final _byWire = {for (final v in MaterialStatus.values) v.wire: v};

  bool get awaitingCustomerDecision => const {
        MaterialStatus.requested,
        MaterialStatus.customerReview,
      }.contains(this);
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

  static PricingUnit parse(String? raw) =>
      _parse(_byWire, raw, 'pricing_unit');
  static final _byWire = {for (final v in PricingUnit.values) v.wire: v};

  String get label => switch (this) {
        PricingUnit.perJob => 'per job',
        PricingUnit.perHour => 'per hour',
        PricingUnit.perDay => 'per day',
        PricingUnit.perUnit => 'per unit',
        PricingUnit.perSqft => 'per sq ft',
      };
}

/// public.support_category
///
/// All nine values, because support staff recategorise tickets and the customer
/// then has to be able to open their own ticket — parsing throws on anything
/// missing here. What a customer may *choose* is the narrower
/// [customerSelectable]; PAYOUT and VERIFICATION are worker concerns and CLAIM
/// is opened for them, not by them.
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

  /// The categories offered when a customer opens a ticket.
  static const customerSelectable = [
    SupportCategory.booking,
    SupportCategory.payment,
    SupportCategory.account,
    SupportCategory.safety,
    SupportCategory.appIssue,
    SupportCategory.other,
  ];

  String get label => switch (this) {
        SupportCategory.booking => 'Booking issue',
        SupportCategory.payment => 'Payment',
        SupportCategory.payout => 'Payout',
        SupportCategory.verification => 'Verification',
        SupportCategory.account => 'My account',
        SupportCategory.safety => 'Safety concern',
        SupportCategory.claim => 'Insurance claim',
        SupportCategory.appIssue => 'App problem',
        SupportCategory.other => 'Other',
      };
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

  static SupportStatus parse(String? raw) =>
      _parse(_byWire, raw, 'support_status');
  static final _byWire = {for (final v in SupportStatus.values) v.wire: v};

  bool get isOpen => this != SupportStatus.closed && this != SupportStatus.resolved;
  bool get needsCustomerReply => this == SupportStatus.waitingForUser;
}

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

  bool get isTerminal => const {
        ServiceRequestStatus.cancelled,
        ServiceRequestStatus.expired,
        ServiceRequestStatus.closed,
      }.contains(this);

  bool get isActive => const {
        ServiceRequestStatus.open,
        ServiceRequestStatus.receivingOffers,
        ServiceRequestStatus.workerSelected,
      }.contains(this);

  String get customerLabel => switch (this) {
        ServiceRequestStatus.draft => 'Draft',
        ServiceRequestStatus.open => 'Open — waiting for offers',
        ServiceRequestStatus.receivingOffers => 'Receiving offers',
        ServiceRequestStatus.workerSelected => 'Professional selected',
        ServiceRequestStatus.booked => 'Booked',
        ServiceRequestStatus.cancelled => 'Cancelled',
        ServiceRequestStatus.expired => 'Expired',
        ServiceRequestStatus.closed => 'Closed',
      };
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

  String get label => switch (this) {
        BudgetType.none => 'Flexible',
        BudgetType.fixed => 'Fixed price',
        BudgetType.range => 'Price range',
      };
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

  String get label => switch (this) {
        ScheduleType.asap => 'As soon as possible',
        ScheduleType.today => 'Today',
        ScheduleType.tomorrow => 'Tomorrow',
        ScheduleType.specificDate => 'On a specific date',
      };
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

  String get customerLabel => switch (this) {
        OfferStatus.submitted => 'New offer',
        OfferStatus.viewed => 'Viewed',
        OfferStatus.shortlisted => 'Shortlisted',
        OfferStatus.accepted => 'Accepted',
        OfferStatus.rejected => 'Rejected',
        OfferStatus.withdrawn => 'Withdrawn by worker',
        OfferStatus.expired => 'Expired',
        OfferStatus.closed => 'Closed',
      };
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
