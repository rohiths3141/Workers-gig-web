import 'enums.dart';
import '../../core/localization/app_locale.dart';

/// A worker's offer on a customer service request, viewed from the customer
/// side. Includes public-safe worker profile fields for comparison.
class ServiceRequestOffer {
  const ServiceRequestOffer({
    required this.id,
    required this.serviceRequestId,
    required this.workerId,
    required this.proposedPriceMinor,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.gigId,
    this.workerName,
    this.workerPhotoUrl,
    this.workerRating,
    this.workerRatingCount,
    this.workerJobsCompleted,
    this.workerExperienceYears,
    this.workerCity,
    this.isKycVerified = false,
    this.isBackgroundVerified = false,
    this.isInsured = false,
    this.gigTitle,
    this.message,
    this.estimatedDurationMinutes,
    this.availabilityDate,
    this.availabilityStart,
    this.availabilityEnd,
    this.distanceKm,
  });

  factory ServiceRequestOffer.fromJson(Map<String, dynamic> json) {
    return ServiceRequestOffer(
      id: json['id'] as String,
      serviceRequestId: json['service_request_id'] as String,
      workerId: json['worker_id'] as String,
      gigId: json['gig_id'] as String?,
      workerName: json['worker_name'] as String?,
      workerPhotoUrl: json['worker_photo_url'] as String?,
      workerRating: (json['worker_rating'] as num?)?.toDouble(),
      workerRatingCount: json['worker_rating_count'] as int?,
      workerJobsCompleted: json['worker_jobs_completed'] as int?,
      workerExperienceYears: json['worker_experience_years'] as int?,
      workerCity: json['worker_city'] as String?,
      isKycVerified: json['is_kyc_verified'] as bool? ?? false,
      isBackgroundVerified: json['is_background_verified'] as bool? ?? false,
      isInsured: json['is_insured'] as bool? ?? false,
      gigTitle: json['gig_title'] as String?,
      message: json['message'] as String?,
      proposedPriceMinor: json['proposed_price_minor'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'INR',
      estimatedDurationMinutes: json['estimated_duration_minutes'] as int?,
      availabilityDate: json['availability_date'] != null
          ? DateTime.parse(json['availability_date'] as String)
          : null,
      availabilityStart: json['availability_start'] as String?,
      availabilityEnd: json['availability_end'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      status: OfferStatus.parse(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String id;
  final String serviceRequestId;
  final String workerId;
  final String? gigId;

  // Worker profile (public-safe fields)
  final String? workerName;
  final String? workerPhotoUrl;
  final double? workerRating;
  final int? workerRatingCount;
  final int? workerJobsCompleted;
  final int? workerExperienceYears;
  final String? workerCity;
  final bool isKycVerified;
  final bool isBackgroundVerified;
  final bool isInsured;

  // Gig details
  final String? gigTitle;

  // Offer details
  final String? message;
  final int proposedPriceMinor;
  final String currency;
  final int? estimatedDurationMinutes;
  final DateTime? availabilityDate;
  final String? availabilityStart;
  final String? availabilityEnd;
  final double? distanceKm;

  final OfferStatus status;
  final DateTime createdAt;

  // ---------------------------------------------------------------------------
  // Display helpers
  // ---------------------------------------------------------------------------

  String get priceLabel => '₹${(proposedPriceMinor / 100).toStringAsFixed(0)}';

  String get durationLabel {
    if (estimatedDurationMinutes == null) return '';
    final l10n = AppStrings.current;
    final hours = estimatedDurationMinutes! ~/ 60;
    final mins = estimatedDurationMinutes! % 60;
    if (hours == 0) return l10n.durationMinutes(mins);
    if (mins == 0) return l10n.durationHours(hours);
    return l10n.durationHoursMinutes(hours, mins);
  }

  String get distanceLabel {
    if (distanceKm == null) return '';
    return AppStrings.current.distanceKm(distanceKm!.toStringAsFixed(1));
  }

  String get workerDisplayName =>
      workerName ?? AppStrings.current.offerWorkerFallbackName;

  String get workerInitial {
    final name = workerDisplayName;
    if (name.isEmpty) return '';
    return String.fromCharCode(name.runes.first).toUpperCase();
  }

  bool get canBeAccepted => const {
        OfferStatus.submitted,
        OfferStatus.viewed,
        OfferStatus.shortlisted,
      }.contains(status);

  /// Number of trust badges this worker has.
  int get verificationBadgeCount =>
      (isKycVerified ? 1 : 0) +
      (isBackgroundVerified ? 1 : 0) +
      (isInsured ? 1 : 0);
}
