import 'enums.dart';

/// A customer-posted service request visible to workers who match its
/// service category and location radius.
///
/// Workers see a privacy-safe version: the location is jittered ±500 m
/// by the `worker_find_eligible_requests` RPC and no exact address appears
/// until after the booking is created and accepted.
class CustomerServiceRequest {
  const CustomerServiceRequest({
    required this.id,
    required this.requestCode,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.description,
    required this.status,
    required this.budgetType,
    required this.scheduleType,
    required this.offerCount,
    required this.createdAt,
    this.budgetMinMinor,
    this.budgetMaxMinor,
    this.scheduledDate,
    this.timeWindowStart,
    this.timeWindowEnd,
    this.city,
    this.pincode,
    this.distanceKm,
    this.approximateLatitude,
    this.approximateLongitude,
    this.additionalNotes,
    this.expiresAt,
    this.customerName,
  });

  final String id;
  final String requestCode;
  final String categoryId;
  final String categoryName;
  final String title;
  final String description;
  final ServiceRequestStatus status;
  final BudgetType budgetType;
  final int? budgetMinMinor;
  final int? budgetMaxMinor;
  final ScheduleType scheduleType;
  final DateTime? scheduledDate;
  final String? timeWindowStart;
  final String? timeWindowEnd;
  final String? city;
  final String? pincode;
  final double? distanceKm;
  final double? approximateLatitude;
  final double? approximateLongitude;
  final String? additionalNotes;
  final int offerCount;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final String? customerName;

  // ── Display helpers ──

  String get budgetLabel {
    switch (budgetType) {
      case BudgetType.none:
        return 'Flexible';
      case BudgetType.fixed:
        return '₹${((budgetMinMinor ?? 0) / 100).toStringAsFixed(0)}';
      case BudgetType.range:
        final min = ((budgetMinMinor ?? 0) / 100).toStringAsFixed(0);
        final max = ((budgetMaxMinor ?? 0) / 100).toStringAsFixed(0);
        return '₹$min – ₹$max';
    }
  }

  String get scheduleLabel => scheduleType.label;

  String get distanceLabel {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()} m away';
    return '${distanceKm!.toStringAsFixed(1)} km away';
  }

  String get offerCountLabel =>
      offerCount == 0 ? 'No offers yet' : '$offerCount offer${offerCount > 1 ? 's' : ''}';

  // ── JSON factory ──

  factory CustomerServiceRequest.fromJson(Map<String, dynamic> json) {
    return CustomerServiceRequest(
      id: json['id'] as String,
      requestCode: json['request_code'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? json['service_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ??
          json['service_name'] as String? ??
          '',
      title: json['title'] as String,
      description: json['description'] as String,
      status: ServiceRequestStatus.parse(json['status'] as String?),
      budgetType: BudgetType.parse(json['budget_type'] as String? ?? 'NONE'),
      budgetMinMinor: json['budget_min_minor'] as int?,
      budgetMaxMinor: json['budget_max_minor'] as int?,
      scheduleType:
          ScheduleType.parse(json['schedule_type'] as String? ?? 'ASAP'),
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.tryParse(json['scheduled_date'] as String)
          : null,
      timeWindowStart: json['time_window_start'] as String?,
      timeWindowEnd: json['time_window_end'] as String?,
      city: json['city'] as String?,
      pincode: json['pincode'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      approximateLatitude: (json['approx_latitude'] as num?)?.toDouble() ??
          (json['latitude'] as num?)?.toDouble(),
      approximateLongitude: (json['approx_longitude'] as num?)?.toDouble() ??
          (json['longitude'] as num?)?.toDouble(),
      additionalNotes: json['additional_notes'] as String?,
      offerCount: json['offer_count'] as int? ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      customerName: json['customer_name'] as String?,
    );
  }
}
