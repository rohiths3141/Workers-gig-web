import '../../core/utils/money_format.dart';

/// A payment row for a booking (public.payments), read directly — the
/// customer app has SELECT-only access; every write happens on the trusted
/// web tier after gateway signature verification.
class Payment {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.amountMinor,
    required this.currency,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] as String,
        bookingId: json['booking_id'] as String,
        amountMinor: json['amount_minor'] as int,
        currency: json['currency'] as String? ?? 'INR',
        status: json['status'] as String,
      );

  final String id;
  final String bookingId;
  final int amountMinor;
  final String currency;
  final String status;

  /// What was paid, formatted for a receipt line.
  ///
  /// Held as paise and divided once, in [formatRupees]. A `double get amount`
  /// used to live here and was rendered with `toStringAsFixed(0)`, which
  /// rounded the very number the customer was being told they had paid.
  String get amountLabel => formatRupees(amountMinor);
  bool get isSuccess => status == 'SUCCESS';
}

/// The order details returned by the trusted backend after it creates a
/// real Razorpay order — never fabricated client-side.
class PaymentOrder {
  const PaymentOrder({
    required this.paymentId,
    required this.razorpayOrderId,
    required this.amountMinor,
    required this.currency,
    required this.keyId,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> json) => PaymentOrder(
        paymentId: json['paymentId'] as String,
        razorpayOrderId: json['razorpayOrderId'] as String,
        amountMinor: json['amountMinor'] as int,
        currency: json['currency'] as String,
        keyId: json['keyId'] as String,
      );

  final String paymentId;
  final String razorpayOrderId;
  final int amountMinor;
  final String currency;
  final String keyId;
}
