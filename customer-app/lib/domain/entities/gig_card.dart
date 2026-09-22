import 'enums.dart';
import '../../core/utils/money_format.dart';

/// A discovered gig returned by customer_find_gigs().
///
/// This is a denormalised card: it carries just enough worker info to render
/// the discovery list and map markers without a separate worker fetch.
/// Coordinates are approximate (±500 m noise applied server-side).
class GigCard {
  const GigCard({
    required this.gigId,
    required this.title,
    required this.description,
    required this.priceMinor,
    required this.pricingUnit,
    required this.currency,
    required this.workerId,
    required this.workerCode,
    required this.workerName,
    required this.workerRating,
    required this.workerRatingCount,
    required this.workerJobsCompleted,
    required this.isKycVerified,
    required this.isBackgroundVerified,
    required this.isInsured,
    required this.approxLatitude,
    required this.approxLongitude,
    required this.distanceKm,
    this.estimatedDurationMinutes,
    this.experienceYears,
    this.bio,
    this.city,
    this.workerPhotoUrl,
  });

  factory GigCard.fromJson(Map<String, dynamic> json) => GigCard(
        gigId: json['gig_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        priceMinor: json['price_minor'] as int,
        pricingUnit: PricingUnit.parse(json['pricing_unit'] as String?),
        currency: json['currency'] as String? ?? 'INR',
        workerId: json['worker_id'] as String,
        workerCode: json['worker_code'] as String? ?? '',
        workerName: json['worker_name'] as String,
        workerRating: (json['worker_rating'] as num?)?.toDouble() ?? 0.0,
        workerRatingCount: json['worker_rating_count'] as int? ?? 0,
        workerJobsCompleted: json['worker_jobs_completed'] as int? ?? 0,
        isKycVerified: json['is_kyc_verified'] as bool? ?? false,
        isBackgroundVerified:
            json['is_background_verified'] as bool? ?? false,
        isInsured: json['is_insured'] as bool? ?? false,
        estimatedDurationMinutes:
            json['estimated_duration_minutes'] as int?,
        experienceYears: json['experience_years'] as int?,
        bio: json['bio'] as String?,
        city: json['city'] as String?,
        workerPhotoUrl: json['worker_photo_url'] as String?,
        approxLatitude:
            (json['approx_latitude'] as num?)?.toDouble() ?? 0.0,
        approxLongitude:
            (json['approx_longitude'] as num?)?.toDouble() ?? 0.0,
        distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      );

  final String gigId;
  final String title;
  final String description;
  final int priceMinor;
  final PricingUnit pricingUnit;
  final String currency;

  final String workerId;
  final String workerCode;
  final String workerName;
  final double workerRating;
  final int workerRatingCount;
  final int workerJobsCompleted;
  final bool isKycVerified;
  final bool isBackgroundVerified;
  final bool isInsured;
  final int? estimatedDurationMinutes;
  final int? experienceYears;
  final String? bio;
  final String? city;
  final String? workerPhotoUrl;

  /// Noisy coordinates (±500 m) — do not use for navigation.
  final double approxLatitude;
  final double approxLongitude;

  final double distanceKm;

  /// Human-readable price string, e.g. "₹350 per job"
  String get priceLabel => '${formatRupees(priceMinor)} ${pricingUnit.label}';

  String get ratingLabel =>
      workerRatingCount == 0 ? 'New' : workerRating.toStringAsFixed(1);

  String get distanceLabel => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m'
      : '${distanceKm.toStringAsFixed(1)} km';
}
