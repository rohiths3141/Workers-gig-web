import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/repositories.dart';

/// Talks to the trusted web tier for everything a Razorpay payment needs
/// server-side authority for (creating an order with a real amount,
/// verifying the gateway signature). The customer app never creates or
/// mutates a payments row directly — see the `payments` RLS grants
/// (SELECT only) in migration 0009.
final class HttpPaymentRepository implements PaymentRepository {
  HttpPaymentRepository(
    this._db,
    this._authRepository, {
    required String apiBaseUrl,
    http.Client? client,
  })  : _apiBaseUrl = apiBaseUrl,
        _client = client ?? http.Client();

  final SupabaseClient _db;
  final AuthRepository _authRepository;
  final String _apiBaseUrl;
  final http.Client _client;

  Future<Result<T>> _post<T>(
    String path,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) parse,
  ) async {
    if (_apiBaseUrl.isEmpty) {
      return const Err(ServerFailure(
        message: 'Payments are not configured for this build yet.',
      ));
    }

    final tokenRes = await _authRepository.idToken();
    final token = tokenRes.valueOrNull;
    if (token == null) {
      return const Err(AuthFailure(message: 'Please sign in again to continue.'));
    }

    try {
      final response = await _client
          .post(
            Uri.parse('$_apiBaseUrl$path'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['ok'] == true) {
        return Ok(parse(json['data'] as Map<String, dynamic>));
      }

      final error = json['error'] as Map<String, dynamic>?;
      final message = error?['message'] as String? ?? 'Something went wrong. Please try again.';
      final code = error?['code'] as String?;

      return Err(switch (code) {
        'UNAUTHENTICATED' => AuthFailure(message: message, requiresReauthentication: true),
        'FORBIDDEN' => PermissionFailure(message: message),
        'NOT_FOUND' => NotFoundFailure(message: message),
        'VALIDATION_FAILED' => ValidationFailure(message: message),
        'CONFLICT' => ConflictFailure(message: message),
        _ => ServerFailure(message: message),
      });
    } on FormatException catch (e) {
      return Err(ServerFailure(debugDetail: e.toString()));
    } catch (e) {
      return Err(NetworkFailure(debugDetail: e.toString()));
    }
  }

  @override
  Future<Result<PaymentOrder>> createOrder(String bookingId) => _post(
        '/customer/payments/create-order',
        {'bookingId': bookingId},
        PaymentOrder.fromJson,
      );

  @override
  Future<Result<void>> verifyPayment({
    required String paymentId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) =>
      _post(
        '/customer/payments/verify',
        {
          'paymentId': paymentId,
          'razorpayOrderId': razorpayOrderId,
          'razorpayPaymentId': razorpayPaymentId,
          'razorpaySignature': razorpaySignature,
        },
        (_) {},
      );

  @override
  Future<Result<Payment?>> getPaymentForBooking(String bookingId) async {
    try {
      final rows = await _db
          .from('payments')
          .select()
          .eq('booking_id', bookingId)
          .order('created_at', ascending: false);

      final payments = (rows as List)
          .map((r) => Payment.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
      if (payments.isEmpty) return const Ok(null);
      return Ok(payments.firstWhere((p) => p.isSuccess, orElse: () => payments.first));
    } catch (e) {
      return Err(ServerFailure(debugDetail: e.toString()));
    }
  }

  @override
  Future<Result<Set<String>>> getPaidBookingIds() async {
    try {
      // RLS scopes payments to the signed-in customer's own rows.
      final rows = await _db.from('payments').select('booking_id').eq('status', 'SUCCESS');
      return Ok({for (final r in rows as List) (r as Map)['booking_id'] as String});
    } catch (e) {
      return Err(ServerFailure(debugDetail: e.toString()));
    }
  }
}
