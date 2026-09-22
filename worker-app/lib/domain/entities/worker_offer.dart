import 'enums.dart';

/// An offer the worker has submitted to a customer service request.
class WorkerOffer {
  const WorkerOffer({
    required this.id,
    required this.serviceRequestId,
    required this.status,
    required this.quotedAmountMinor,
    required this.createdAt,
    this.estimatedDuration,
    this.message,
    this.gigId,
    this.gigTitle,
    this.updatedAt,
    this.requestTitle,
    this.requestCode,
  });

  final String id;
  final String serviceRequestId;
  final OfferStatus status;
  final int quotedAmountMinor;
  final String? estimatedDuration;
  final String? message;
  final String? gigId;
  final String? gigTitle;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Optional denormalized fields from the parent request.
  final String? requestTitle;
  final String? requestCode;

  // ── Display helpers ──

  String get priceLabel => '₹${(quotedAmountMinor / 100).toStringAsFixed(0)}';

  String get durationLabel {
    if (estimatedDuration == null || estimatedDuration!.isEmpty) return '';
    return '~$estimatedDuration';
  }

  String get statusLabel => status.workerLabel;

  bool get isPending => status.isPending;
  bool get isTerminal => status.isTerminal;

  /// Whether the worker can still withdraw this offer.
  bool get canWithdraw => const {
        OfferStatus.submitted,
        OfferStatus.viewed,
        OfferStatus.shortlisted,
      }.contains(status);

  // ── JSON factory ──

  factory WorkerOffer.fromJson(Map<String, dynamic> json) {
    return WorkerOffer(
      id: json['id'] as String,
      serviceRequestId: json['service_request_id'] as String,
      status: OfferStatus.parse(json['status'] as String?),
      quotedAmountMinor: json['quoted_amount_minor'] as int,
      estimatedDuration: json['estimated_duration'] as String?,
      message: json['message'] as String?,
      gigId: json['gig_id'] as String?,
      gigTitle: json['gig_title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      requestTitle: json['request_title'] as String?,
      requestCode: json['request_code'] as String?,
    );
  }
}
