import 'enums.dart';
import '../../core/utils/money_format.dart';

/// A material request submitted by the worker during a booking.
class MaterialRequest {
  const MaterialRequest({
    required this.id,
    required this.bookingId,
    required this.name,
    required this.description,
    required this.status,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    this.estimatedCostMinor,
    this.actualCostMinor,
    this.approvedAt,
  });

  factory MaterialRequest.fromJson(Map<String, dynamic> json) =>
      MaterialRequest(
        id: json['id'] as String,
        bookingId: json['booking_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        status: MaterialStatus.parse(json['status'] as String?),
        // The worker says how much of what: "5 metre", "2 unit". Both columns
        // exist on the row and neither was being read, so every material was
        // shown to the customer as a quantity of exactly one.
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        unit: json['unit'] as String? ?? 'unit',
        estimatedCostMinor: json['estimated_cost_minor'] as int?,
        actualCostMinor: json['actual_cost_minor'] as int?,
        createdAt: DateTime.parse(json['created_at'] as String),
        approvedAt: json['approved_at'] != null
            ? DateTime.parse(json['approved_at'] as String)
            : null,
      );

  final String id;
  final String bookingId;
  final String name;
  final String description;
  final MaterialStatus status;
  final double quantity;
  final String unit;
  final int? estimatedCostMinor;
  final int? actualCostMinor;
  final DateTime createdAt;
  final DateTime? approvedAt;

  /// What this line costs in total.
  ///
  /// `estimated_cost_minor` is the cost of the whole line, not a unit price:
  /// the worker types one amount and states the quantity separately, and the
  /// worker app renders it the same way. This app multiplied it by a quantity
  /// of its own, which only ever gave the right answer because that quantity
  /// was hardcoded to 1.
  int get costMinor => actualCostMinor ?? estimatedCostMinor ?? 0;

  /// The settled cost once the worker has filed a receipt, otherwise the
  /// estimate — matching what the customer is actually asked to approve.
  String get costLabel => formatRupees(costMinor);

  /// "5 metre", "2 unit" — trailing zeroes dropped for whole amounts.
  String get quantityLabel {
    final amount = quantity % 1 == 0
        ? quantity.toStringAsFixed(0)
        : quantity.toStringAsFixed(2);
    return '$amount $unit';
  }

  bool get isEstimate => actualCostMinor == null;

  String? get estimatedCostLabel => formatRupeesOr(estimatedCostMinor, '');

  String? get actualCostLabel =>
      actualCostMinor == null ? null : formatRupees(actualCostMinor!);
}
