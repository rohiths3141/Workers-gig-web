import '../../core/money/money.dart';
import 'enums.dart';
import '../../core/localization/app_locale.dart';

/// One service a worker offers.
///
/// A worker holds many of these, across many trades. Note what is *not* on this
/// class: no KYC flag, no rating, no verification state. Those belong to the
/// worker and are read from there, so a worker with five gigs has one identity
/// rather than five copies of it that can disagree.
class Gig {
  const Gig({
    required this.id,
    required this.workerId,
    required this.serviceId,
    required this.serviceName,
    required this.title,
    required this.status,
    required this.price,
    required this.pricingUnit,
    required this.estimatedDurationMinutes,
    required this.jobsCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.serviceRadiusKm,
    this.rejectionReason,
    this.submittedAt,
    this.reviewedAt,
    this.photoMediaIds = const [],
  });

  final String id;
  final String workerId;

  /// The trade this gig sits under. A gig can only exist for a trade the worker
  /// is approved for; the server enforces it in `worker_upsert_gig`.
  final String serviceId;
  final String serviceName;

  final String title;
  final String? description;
  final GigStatus status;

  final Money price;
  final PricingUnit pricingUnit;
  final int estimatedDurationMinutes;

  /// Overrides the worker's own radius for this gig. A painter may travel
  /// further for a two-day job than for a switchboard repair.
  final double? serviceRadiusKm;

  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final int jobsCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<String> photoMediaIds;

  /// "45 min", "2 hr 30 min", "3 days" — written the way a worker would say it.
  String get durationLabel {
    final l10n = AppStrings.current;
    final minutes = estimatedDurationMinutes;
    if (minutes < 60) return l10n.durationMinutes('$minutes');
    if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final rest = minutes % 60;
      return rest == 0
          ? l10n.durationHours('$hours')
          : l10n.durationHoursMinutes('$hours', '$rest');
    }
    return l10n.durationDays((minutes / 1440).round());
  }

  String get priceLabel {
    final l10n = AppStrings.current;
    final amount = price.format();
    return switch (pricingUnit) {
      PricingUnit.perJob => amount,
      PricingUnit.perHour => l10n.pricePerHour(amount),
      PricingUnit.perDay => l10n.pricePerDay(amount),
      PricingUnit.perUnit => l10n.pricePerUnit(amount),
      PricingUnit.perSqft => l10n.pricePerSqft(amount),
    };
  }

  /// Whether this gig can currently win work. Both halves matter: a live gig
  /// belonging to an offline worker wins nothing, and that combination is shown
  /// explicitly in the UI rather than left to be inferred.
  bool get isMatchable => status.isLive;

  Gig copyWith({
    String? serviceId,
    String? serviceName,
    String? title,
    String? description,
    GigStatus? status,
    Money? price,
    PricingUnit? pricingUnit,
    int? estimatedDurationMinutes,
    double? serviceRadiusKm,
    List<String>? photoMediaIds,
  }) =>
      Gig(
        id: id,
        workerId: workerId,
        serviceId: serviceId ?? this.serviceId,
        serviceName: serviceName ?? this.serviceName,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        price: price ?? this.price,
        pricingUnit: pricingUnit ?? this.pricingUnit,
        estimatedDurationMinutes:
            estimatedDurationMinutes ?? this.estimatedDurationMinutes,
        serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
        rejectionReason: rejectionReason,
        submittedAt: submittedAt,
        reviewedAt: reviewedAt,
        jobsCompleted: jobsCompleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
        photoMediaIds: photoMediaIds ?? this.photoMediaIds,
      );
}

/// A draft being edited, before it is a [Gig].
///
/// Kept separate so a half-finished form is never mistaken for a published
/// offering, and so validation lives in one place rather than in the widget.
class GigDraft {
  const GigDraft({
    this.id,
    this.serviceId,
    this.title = '',
    this.description = '',
    this.priceMinor,
    this.pricingUnit = PricingUnit.perJob,
    this.estimatedDurationMinutes,
    this.serviceRadiusKm,
  });

  final String? id;
  final String? serviceId;
  final String title;
  final String description;
  final int? priceMinor;
  final PricingUnit pricingUnit;
  final int? estimatedDurationMinutes;
  final double? serviceRadiusKm;

  bool get isNew => id == null;

  /// Field-level problems, keyed by field name. Empty means ready to submit.
  ///
  /// These mirror the check constraints on `worker_gigs` exactly, so the client
  /// and the database agree on what is valid and the worker is not told
  /// something is fine only for the server to reject it.
  Map<String, String> validate() {
    final errors = <String, String>{};
    final l10n = AppStrings.current;

    if (serviceId == null) {
      errors['serviceId'] = l10n.gigErrorTrade;
    }

    final trimmed = title.trim();
    if (trimmed.length < 6) {
      errors['title'] = l10n.gigErrorTitleShort;
    } else if (trimmed.length > 120) {
      errors['title'] = l10n.gigErrorTitleLong;
    }

    if (priceMinor == null || priceMinor! <= 0) {
      errors['price'] = l10n.gigErrorPrice;
    }

    final minutes = estimatedDurationMinutes;
    if (minutes == null) {
      errors['duration'] = l10n.gigErrorDurationMissing;
    } else if (minutes < 15) {
      errors['duration'] = l10n.gigErrorDurationShort;
    } else if (minutes > 20160) {
      errors['duration'] = l10n.gigErrorDurationLong;
    }

    final radius = serviceRadiusKm;
    if (radius != null && (radius <= 0 || radius > 100)) {
      errors['radius'] = l10n.gigErrorRadius;
    }

    return errors;
  }

  bool get isValid => validate().isEmpty;

  GigDraft copyWith({
    String? id,
    String? serviceId,
    String? title,
    String? description,
    int? priceMinor,
    PricingUnit? pricingUnit,
    int? estimatedDurationMinutes,
    double? serviceRadiusKm,
    bool clearRadius = false,
  }) =>
      GigDraft(
        id: id ?? this.id,
        serviceId: serviceId ?? this.serviceId,
        title: title ?? this.title,
        description: description ?? this.description,
        priceMinor: priceMinor ?? this.priceMinor,
        pricingUnit: pricingUnit ?? this.pricingUnit,
        estimatedDurationMinutes:
            estimatedDurationMinutes ?? this.estimatedDurationMinutes,
        serviceRadiusKm: clearRadius ? null : (serviceRadiusKm ?? this.serviceRadiusKm),
      );

  static GigDraft fromGig(Gig gig) => GigDraft(
        id: gig.id,
        serviceId: gig.serviceId,
        title: gig.title,
        description: gig.description ?? '',
        priceMinor: gig.price.minor,
        pricingUnit: gig.pricingUnit,
        estimatedDurationMinutes: gig.estimatedDurationMinutes,
        serviceRadiusKm: gig.serviceRadiusKm,
      );
}

/// A trade from the platform catalogue, from `public.services`.
class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.shortDescription,
    required this.iconKey,
    required this.requiredVerifications,
    this.baseVisitFee,
  });

  final String id;
  final String name;
  final String slug;
  final String shortDescription;
  final String iconKey;

  /// What a worker must have approved before they can work this trade. Shown
  /// during skill selection so the requirement is known up front.
  final List<VerificationType> requiredVerifications;

  final Money? baseVisitFee;
}
