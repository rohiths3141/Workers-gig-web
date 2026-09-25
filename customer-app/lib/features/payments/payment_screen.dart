import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:intl/intl.dart';

import '../../app/providers/providers.dart';
import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/payment.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/localization/l10n.dart';

/// Real Razorpay checkout. There is no path here that marks a payment
/// successful without the gateway's own signed response being verified by
/// the trusted backend (see web/src/app/api/customer/payments/verify) —
/// closing this screen or a client-side error never counts as success.
class PaymentScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const PaymentScreen({super.key, required this.bookingId});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late final Razorpay _razorpay;
  bool _isStarting = false;
  bool _isVerifying = false;
  String? _error;
  String? _pendingPaymentId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _startCheckout(Booking booking) async {
    setState(() {
      _isStarting = true;
      _error = null;
    });

    final res = await ref.read(paymentRepositoryProvider).createOrder(widget.bookingId);

    if (!mounted) return;
    setState(() => _isStarting = false);

    switch (res) {
      case Ok(:final value):
        _pendingPaymentId = value.paymentId;
        _openCheckout(value, booking);
      case Err(:final failure):
        setState(() => _error = failure.message);
    }
  }

  void _openCheckout(PaymentOrder order, Booking booking) {
    final customer = ref.read(currentCustomerProvider);

    final options = {
      'key': order.keyId,
      'amount': order.amountMinor,
      'currency': order.currency,
      'order_id': order.razorpayOrderId,
      'name': 'Wervexa',
      'description': booking.serviceName,
      'prefill': {
        if (customer?.phone.isNotEmpty ?? false) 'contact': customer!.phone,
        if (customer?.email != null) 'email': customer!.email,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      setState(() => _error = context.l10n.paymentCouldNotOpen);
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    final paymentId = _pendingPaymentId;
    if (paymentId == null) return;

    setState(() => _isVerifying = true);

    final res = await ref.read(paymentRepositoryProvider).verifyPayment(
          paymentId: paymentId,
          razorpayOrderId: response.orderId ?? '',
          razorpayPaymentId: response.paymentId ?? '',
          razorpaySignature: response.signature ?? '',
        );

    if (!mounted) return;
    setState(() => _isVerifying = false);

    switch (res) {
      case Ok():
        ref.invalidate(paymentForBookingProvider(widget.bookingId));
        ref.invalidate(bookingStreamProvider(widget.bookingId));
        ref.invalidate(paidBookingIdsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.paymentReceived),
              backgroundColor: AppColors.statusSuccess,
            ),
          );
          // The booking flow reaches this screen with go(), so there is
          // nothing to pop back to; land on the booking itself.
          context.go('/bookings/${widget.bookingId}');
        }
      case Err(:final failure):
        // The gateway said success, but our server could not verify it —
        // never show a success state here. Surface it plainly and let the
        // customer retry or contact support with the payment reference.
        setState(() => _error = context.l10n.paymentNotConfirmed(
              failure.message,
              response.paymentId ?? '',
            ));
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    setState(() {
      _error = response.message?.isNotEmpty == true
          ? response.message
          : context.l10n.paymentNotCompleted;
    });
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    setState(() => _error =
        context.l10n.paymentExternalWalletUnsupported(response.walletName ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingStreamProvider(widget.bookingId));
    final paymentAsync = ref.watch(paymentForBookingProvider(widget.bookingId));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paymentTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.commonBack,
          onPressed: () => context.canPop() ? context.pop() : context.go('/bookings'),
        ),
      ),
      body: bookingAsync.when(
        data: (booking) => paymentAsync.when(
          data: (payment) => _buildBody(booking, payment),
          loading: () => const Center(child: CircularProgressIndicator()),
          // Never fall through to the Pay button here. Not knowing whether
          // this booking has already been paid for is not the same as knowing
          // it has not, and treating the two alike is how someone pays twice.
          error: (_, __) => ErrorState(
            message: l10n.paymentStatusUnknown,
            onRetry: () =>
                ref.invalidate(paymentForBookingProvider(widget.bookingId)),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorState(
          message: l10n.paymentBookingLoadFailed,
          onRetry: () => ref.invalidate(bookingStreamProvider(widget.bookingId)),
        ),
      ),
    );
  }

  Widget _buildBody(Booking booking, Payment? payment) {
    final l10n = context.l10n;
    final serviceName = localizedServiceName(l10n, booking.serviceName);
    if (payment != null && payment.isSuccess) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: l10n.paymentComplete,
        message: l10n.paymentPaidFor(payment.amountLabel, serviceName),
        actionLabel: l10n.paymentViewBooking,
        onAction: () => context.go('/bookings/${booking.id}'),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.paymentBookingSummary,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (booking.workerName != null)
                    _summaryRow(l10n.paymentProvider, booking.workerName!),
                  _summaryRow(l10n.paymentService, serviceName),
                  if (booking.scheduledAt != null) ...[
                    _summaryRow(l10n.paymentDate, DateFormat('EEE, d MMM', context.dateLocale).format(booking.scheduledAt!)),
                    _summaryRow(l10n.paymentTime, DateFormat('h:mm a', context.dateLocale).format(booking.scheduledAt!)),
                  ],
                  _summaryRow(l10n.paymentAddress, booking.addressLine),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.paymentTotal, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                      Text(
                        booking.amountLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lock_outline, size: 16, color: AppColors.inkSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.paymentHeldSecurely,
                    style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.statusError, fontSize: 13)),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isStarting || _isVerifying) ? null : () => _startCheckout(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: (_isStarting || _isVerifying)
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        l10n.bookingDetailPayAmount(booking.amountLabel),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: AppColors.ink, fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
