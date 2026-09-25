import 'package:flutter/material.dart' show TimeOfDay;
import 'package:intl/intl.dart';

import '../../core/localization/app_locale.dart';
import '../../core/localization/l10n.dart' show dateLocaleFor;
import 'enums.dart';

/// Customer-side view of a service request they posted.
class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.requestCode,
    required this.customerId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.description,
    required this.budgetType,
    required this.scheduleType,
    required this.addressLine,
    required this.status,
    required this.offerCount,
    required this.currency,
    required this.createdAt,
    this.budgetMinMinor,
    this.budgetMaxMinor,
    this.scheduledDate,
    this.timeWindowStart,
    this.timeWindowEnd,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.maxOffers,
    this.selectedOfferId,
    this.selectedWorkerId,
    this.expiresAt,
    this.additionalNotes,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      requestCode: json['request_code'] as String,
      customerId: json['customer_id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      budgetType: BudgetType.parse(json['budget_type'] as String?),
      budgetMinMinor: json['budget_min_minor'] as int?,
      budgetMaxMinor: json['budget_max_minor'] as int?,
      currency: json['currency'] as String? ?? 'INR',
      scheduleType: ScheduleType.parse(json['schedule_type'] as String?),
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'] as String)
          : null,
      timeWindowStart: _parseTime(json['time_window_start'] as String?),
      timeWindowEnd: _parseTime(json['time_window_end'] as String?),
      addressLine: json['address_line'] as String? ?? '',
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: ServiceRequestStatus.parse(json['status'] as String?),
      offerCount: json['offer_count'] as int? ?? 0,
      maxOffers: json['max_offers'] as int?,
      selectedOfferId: json['selected_offer_id'] as String?,
      selectedWorkerId: json['selected_worker_id'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      additionalNotes: json['additional_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String id;
  final String requestCode;
  final String customerId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String description;

  // Budget
  final BudgetType budgetType;
  final int? budgetMinMinor;
  final int? budgetMaxMinor;
  final String currency;

  // Schedule
  final ScheduleType scheduleType;
  final DateTime? scheduledDate;
  final TimeOfDay? timeWindowStart;
  final TimeOfDay? timeWindowEnd;

  // Location
  final String addressLine;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;

  // Lifecycle
  final ServiceRequestStatus status;
  final int offerCount;
  final int? maxOffers;
  final String? selectedOfferId;
  final String? selectedWorkerId;
  final DateTime? expiresAt;
  final String? additionalNotes;
  final DateTime createdAt;

  // ---------------------------------------------------------------------------
  // Display helpers
  // ---------------------------------------------------------------------------

  bool get isOpen =>
      status == ServiceRequestStatus.open ||
      status == ServiceRequestStatus.receivingOffers;

  bool get hasOffers => offerCount > 0;

  bool get isExpired {
    if (status == ServiceRequestStatus.expired) return true;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) return true;
    return false;
  }

  bool get canCancel => const {
        ServiceRequestStatus.open,
        ServiceRequestStatus.receivingOffers,
        ServiceRequestStatus.workerSelected,
      }.contains(status);

  String get budgetLabel {
    switch (budgetType) {
      case BudgetType.none:
        return AppStrings.current.budgetFlexible;
      case BudgetType.fixed:
        if (budgetMinMinor != null) {
          return '₹${(budgetMinMinor! / 100).toStringAsFixed(0)}';
        }
        return AppStrings.current.budgetFixed;
      case BudgetType.range:
        final min = budgetMinMinor != null
            ? '₹${(budgetMinMinor! / 100).toStringAsFixed(0)}'
            : '₹0';
        final max = budgetMaxMinor != null
            ? '₹${(budgetMaxMinor! / 100).toStringAsFixed(0)}'
            : '';
        return '$min – $max';
    }
  }

  String get scheduleLabel {
    final l10n = AppStrings.current;
    switch (scheduleType) {
      case ScheduleType.asap:
        return l10n.scheduleAsap;
      case ScheduleType.today:
        return l10n.scheduleToday;
      case ScheduleType.tomorrow:
        return l10n.scheduleTomorrow;
      case ScheduleType.specificDate:
        if (scheduledDate != null) {
          return '${scheduledDate!.day}/${scheduledDate!.month}/${scheduledDate!.year}';
        }
        return l10n.scheduleScheduled;
    }
  }

  String get timeWindowLabel {
    if (timeWindowStart == null) return '';
    final start = _formatTime(timeWindowStart!);
    final end = timeWindowEnd != null ? ' – ${_formatTime(timeWindowEnd!)}' : '';
    return '$start$end';
  }

  String get offerCountLabel => AppStrings.current.offerCount(offerCount);

  static TimeOfDay? _parseTime(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  static String _formatTime(TimeOfDay t) {
    final locale = dateLocaleFor(AppStrings.current.localeName);
    return DateFormat('h:mm a', locale).format(DateTime(2000, 1, 1, t.hour, t.minute));
  }
}
