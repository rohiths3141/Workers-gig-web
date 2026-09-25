import '../../core/money/money.dart';
import 'enums.dart';
import '../../core/localization/app_locale.dart';

/// A booking, from the worker's side.
///
/// Mirrors `public.bookings`, with customer contact details present only when
/// the platform has released them. Before assignment a worker sees an area and
/// a distance; after assignment they see the address and a phone number. That
/// split is enforced by RLS, so this class simply carries whatever arrived.
class Job {
  const Job({
    required this.id,
    required this.bookingCode,
    required this.status,
    required this.serviceId,
    required this.serviceName,
    required this.problemDescription,
    required this.addressLine,
    required this.materialAmount,
    required this.createdAt,
    this.gigId,
    this.gigTitle,
    this.scheduledAt,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.quotedAmount,
    this.workerAmount,
    this.finalAmount,
    this.platformFee,
    this.customerName,
    this.customerPhone,
    this.arrivalVerifiedAt,
    this.acceptedAt,
    this.travelStartedAt,
    this.arrivedAt,
    this.workStartedAt,
    this.completedAt,
    this.paidAt,
    this.cancellationReason,
    this.offerExpiresAt,
  });

  final String id;
  final String bookingCode;
  final BookingStatus status;

  final String serviceId;
  final String serviceName;

  /// Which of the worker's gigs this was sold from, when the booking carries
  /// one. Attribution only — the agreed amount is [quotedAmount] on the
  /// booking, never re-read from the gig.
  final String? gigId;
  final String? gigTitle;

  final String problemDescription;
  final DateTime? scheduledAt;

  final String addressLine;
  final String? city;
  final String? pincode;
  final double? latitude;
  final double? longitude;

  /// Straight-line distance from the worker, when the server computed one.
  final double? distanceKm;

  final Money? quotedAmount;

  /// What the worker will actually be credited, net of the platform fee.
  final Money? workerAmount;

  /// What to show the worker as their earning on this job.
  ///
  /// The split is written when the customer's payment is captured, so before
  /// that [workerAmount] is absent or zero and the card used to read "₹0" on a
  /// perfectly good job. Falling back to the agreed amount is honest: with no
  /// platform commission, the worker's share is the whole of it.
  Money? get earnings {
    final net = workerAmount;
    if (net != null && net.minor > 0) return net;
    return finalAmount ?? quotedAmount;
  }

  final Money? finalAmount;
  final Money? platformFee;
  final Money materialAmount;

  /// Released only once the booking is assigned to this worker.
  final String? customerName;
  final String? customerPhone;

  final DateTime? arrivalVerifiedAt;
  final DateTime? acceptedAt;
  final DateTime? travelStartedAt;
  final DateTime? arrivedAt;
  final DateTime? workStartedAt;
  final DateTime? completedAt;
  final DateTime? paidAt;
  final DateTime createdAt;
  final String? cancellationReason;

  /// When this is an open offer, the moment it stops being acceptable.
  final DateTime? offerExpiresAt;

  bool get isArrivalVerified => arrivalVerifiedAt != null;

  bool get hasCustomerContact => customerPhone != null && customerPhone!.isNotEmpty;

  /// Whether the address is precise enough to navigate to.
  bool get isNavigable => latitude != null && longitude != null;

  /// Time left on an offer. Null when this is not a time-limited offer.
  Duration? get timeToRespond {
    if (offerExpiresAt == null) return null;
    final remaining = offerExpiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get isOfferExpired {
    final remaining = timeToRespond;
    return remaining != null && remaining == Duration.zero;
  }

  /// The area shown before the job is assigned. Never the full address.
  String get approximateArea {
    final parts = [city, pincode].where((p) => p != null && p.isNotEmpty);
    return parts.isEmpty ? AppStrings.current.jobAreaNearby : parts.join(' · ');
  }
}

/// A job offered to this worker and not yet responded to.
///
/// Separate from [Job] because an offer carries matching metadata and a
/// deadline, and because accepting one is a race the worker can lose.
class JobOffer {
  const JobOffer({
    required this.job,
    required this.rank,
    required this.distanceKm,
    required this.offeredAt,
    this.expiresAt,
    this.estimatedEarning,
  });

  final Job job;

  /// Where this worker placed in the match. Not shown to the worker — surfacing
  /// a rank would invite gaming the score — but useful in diagnostics.
  final int rank;

  final double distanceKm;
  final DateTime offeredAt;
  final DateTime? expiresAt;

  /// What the worker would be credited. Null when the amount is not yet fixed,
  /// in which case the UI says so rather than showing a guess.
  final Money? estimatedEarning;

  Duration get timeRemaining {
    if (expiresAt == null) return Duration.zero;
    final left = expiresAt!.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  bool get isExpired => expiresAt != null && timeRemaining == Duration.zero;
}

/// One entry in the booking timeline, from `public.booking_events`.
class JobEvent {
  const JobEvent({
    required this.id,
    required this.eventType,
    required this.createdAt,
    this.fromStatus,
    this.toStatus,
    this.note,
  });

  final int id;
  final String eventType;
  final BookingStatus? fromStatus;
  final BookingStatus? toStatus;
  final String? note;
  final DateTime createdAt;
}

/// A material the worker asked the customer to approve.
class MaterialRequest {
  const MaterialRequest({
    required this.id,
    required this.bookingId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.estimatedCost,
    required this.status,
    required this.createdAt,
    this.description,
    this.actualCost,
    this.customerRejectionReason,
    this.receiptMediaId,
  });

  final String id;
  final String bookingId;
  final String name;
  final String? description;
  final double quantity;
  final String unit;
  final Money estimatedCost;
  final Money? actualCost;
  final MaterialStatus status;
  final String? customerRejectionReason;
  final String? receiptMediaId;
  final DateTime createdAt;

  bool get hasReceipt => receiptMediaId != null;
}

/// What still stands between the worker and finishing this job.
///
/// Computed on the client so the worker sees a checklist rather than being
/// stopped by a server error at the last step. The server checks all of it
/// again in `worker_advance_booking`; this is courtesy, not enforcement.
class CompletionReadiness {
  const CompletionReadiness({
    required this.isArrivalVerified,
    required this.hasBeforeWorkEvidence,
    required this.hasAfterWorkEvidence,
    required this.pendingMaterialCount,
  });

  final bool isArrivalVerified;
  final bool hasBeforeWorkEvidence;
  final bool hasAfterWorkEvidence;
  final int pendingMaterialCount;

  /// Exactly the three gates `worker_advance_booking` applies before it will
  /// move a job to AWAITING_APPROVAL: a verified arrival, at least one
  /// completed after-work photo, and no material request still with the
  /// customer.
  ///
  /// This list has to match the server's, in both directions. Too strict and
  /// the app refuses a job the server would have accepted; too lax — which is
  /// what this was — and the worker taps Finish, the server answers "upload at
  /// least one photo of the finished work before completing the job", and the
  /// checklist above the button never mentioned a photo at all.
  ///
  /// Before-work evidence is deliberately absent: the server does not ask for
  /// it, so neither does this.
  bool get canComplete =>
      isArrivalVerified && hasAfterWorkEvidence && pendingMaterialCount == 0;

  /// Ordered so the worker fixes the earliest blocker first.
  List<String> get blockers {
    final l10n = AppStrings.current;
    return [
      if (!isArrivalVerified) l10n.jobBlockerVerifyArrival,
      if (!hasAfterWorkEvidence) l10n.jobBlockerAfterPhoto,
      if (pendingMaterialCount > 0)
        l10n.jobBlockerMaterialsPending(pendingMaterialCount),
    ];
  }
}
