import 'enums.dart';
import '../../core/utils/money_format.dart';

/// Customer-side view of a booking row.
class Booking {
  const Booking({
    required this.id,
    required this.bookingCode,
    required this.customerId,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.problemDescription,
    required this.addressLine,
    required this.city,
    required this.quotedAmountMinor,
    required this.currency,
    required this.createdAt,
    this.workerId,
    this.workerName,
    this.workerPhone,
    this.workerPhotoUrl,
    this.workerRating,
    this.scheduledAt,
    this.latitude,
    this.longitude,
    this.state,
    this.pincode,
    this.customerNotes,
    this.finalAmountMinor,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.gigTitle,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        bookingCode: json['booking_code'] as String,
        customerId: json['customer_id'] as String,
        serviceId: json['service_id'] as String,
        serviceName: json['service_name'] as String? ?? '',
        status: BookingStatus.parse(json['status'] as String?),
        problemDescription: json['problem_description'] as String? ?? '',
        addressLine: json['address_line'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String?,
        pincode: json['pincode'] as String?,
        quotedAmountMinor: json['quoted_amount_minor'] as int? ?? 0,
        finalAmountMinor: json['final_amount_minor'] as int?,
        currency: json['currency'] as String? ?? 'INR',
        workerId: json['worker_id'] as String?,
        workerName: json['worker_name'] as String?,
        workerPhone: json['worker_phone'] as String?,
        workerPhotoUrl: json['worker_photo_url'] as String?,
        workerRating: (json['worker_rating'] as num?)?.toDouble(),
        // Postgres hands back UTC; every screen formats these for a person
        // standing in their own timezone.
        scheduledAt: json['scheduled_at'] != null
            ? DateTime.parse(json['scheduled_at'] as String).toLocal()
            : null,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        customerNotes: json['customer_notes'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String).toLocal()
            : null,
        cancelledAt: json['cancelled_at'] != null
            ? DateTime.parse(json['cancelled_at'] as String).toLocal()
            : null,
        cancellationReason: json['cancellation_reason'] as String?,
        gigTitle: json['gig_title'] as String?,
      );

  final String id;
  final String bookingCode;
  final String customerId;
  final String serviceId;
  final String serviceName;
  final BookingStatus status;
  final String problemDescription;
  final String addressLine;
  final String city;
  final String? state;
  final String? pincode;
  final int quotedAmountMinor;
  final int? finalAmountMinor;
  final String currency;
  final String? workerId;
  final String? workerName;
  final String? workerPhone;
  final String? workerPhotoUrl;
  final double? workerRating;
  final DateTime? scheduledAt;
  final double? latitude;
  final double? longitude;
  final String? customerNotes;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? gigTitle;

  bool get hasWorker => workerId != null;
  bool get hasLocation => latitude != null && longitude != null;

  String get description => problemDescription;

  /// The price to show: the settled amount once there is one, otherwise the
  /// quote. Paise are only rendered when the amount actually has any.
  String get amountLabel => formatRupees(finalAmountMinor ?? quotedAmountMinor);

  /// Whether to ask this customer for money, given the set of bookings known
  /// to be paid.
  ///
  /// [paidBookingIds] is null when that set could not be loaded. The answer is
  /// then false — not "unpaid". Bookings are paid upfront, so a REQUESTED
  /// booking is either awaiting checkout or already paid and waiting for a
  /// professional, and the only thing telling those apart is this set. Treating
  /// a failed lookup as "nothing is paid" put a Pay button on bookings that had
  /// already been paid for.
  bool awaitingPayment(Set<String>? paidBookingIds) =>
      status == BookingStatus.requested &&
      paidBookingIds != null &&
      !paidBookingIds.contains(id);
}

/// An event on a booking's timeline.
class BookingEvent {
  const BookingEvent({
    required this.id,
    required this.bookingId,
    required this.eventType,
    required this.actorType,
    required this.createdAt,
    this.fromStatus,
    this.toStatus,
    this.note,
  });

  factory BookingEvent.fromJson(Map<String, dynamic> json) => BookingEvent(
        // booking_events.id is `bigint generated always as identity`, so it
        // arrives as a number. Casting it to String threw
        // "type 'int' is not a subtype of type 'String'" on every row.
        id: json['id'] is int
            ? json['id'] as int
            : int.tryParse('${json['id']}') ?? 0,
        bookingId: json['booking_id'] as String,
        eventType: json['event_type'] as String,
        actorType: json['actor_type'] as String,
        createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
        fromStatus: json['from_status'] != null
            ? BookingStatus.parse(json['from_status'] as String?)
            : null,
        toStatus: json['to_status'] != null
            ? BookingStatus.parse(json['to_status'] as String?)
            : null,
        note: json['note'] as String?,
      );

  final int id;
  final String bookingId;
  final String eventType;
  final String actorType;
  final BookingStatus? fromStatus;
  final BookingStatus? toStatus;
  final String? note;
  final DateTime createdAt;
}
