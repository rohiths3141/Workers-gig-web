import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/utils/money_format.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(bookingId));

    // Payment sends the customer straight here, so there is often nothing to
    // pop back to: pressing back used to close the app. Back always means
    // "my bookings" when this screen is the root of the stack.
    void goBack() => context.canPop() ? context.pop() : context.go('/bookings');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goBack,
          ),
        ),
        body: bookingAsync.when(
          data: (booking) => _buildBody(context, ref, booking),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorState(
            message: 'Failed to load booking details.',
            onRetry: () => ref.invalidate(bookingStreamProvider(bookingId)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, Booking booking) {
    // Bookings are paid upfront. Until the payment is captured the booking
    // has not been sent to the professional.
    final payment = ref.watch(paymentForBookingProvider(booking.id)).valueOrNull;
    final isPaid = payment?.isSuccess ?? false;
    final awaitingUpfrontPayment = booking.status == BookingStatus.requested && !isPaid;
    final statusText = awaitingUpfrontPayment
        ? 'Payment pending'
        : booking.status == BookingStatus.requested
            ? 'Waiting for the professional to accept'
            : booking.status.displayName;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking #${booking.bookingCode}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          'Status: $statusText',
                          style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (booking.status.isActive)
                    ElevatedButton(
                      onPressed: () {
                        context.push('/bookings/${booking.id}/active');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        // The theme asks every button for infinite minimum
                        // width, which is full-width in a Column but an
                        // invalid constraint inside a Row — it blanked this
                        // whole screen. Size to the label instead.
                        minimumSize: const Size(0, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Live Map'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Real, server-issued arrival code — only fetched once ARRIVED.
            if (booking.status == BookingStatus.arrived) ...[
              _ArrivalCodeSection(bookingId: booking.id),
              const SizedBox(height: 24),
            ],

            // Service Info Card
            const Text('Service Request Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(booking.description, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: AppColors.inkSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(booking.addressLine, style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Material Requests Quick Button
            OutlinedButton.icon(
              onPressed: () {
                context.push('/bookings/${booking.id}/materials');
              },
              icon: const Icon(Icons.build_circle_outlined),
              label: const Text('View Material / Parts Requests'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fare breakdown
            const Text('Fare Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Fare'),
                      Text(formatRupees(booking.quotedAmountMinor)),
                    ],
                  ),
                  if (booking.finalAmountMinor != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Final Confirmed Fare', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          formatRupees(booking.finalAmountMinor!),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Cancel or Review Buttons
            if (const {BookingStatus.completed, BookingStatus.paid, BookingStatus.closed}
                .contains(booking.status))
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/bookings/${booking.id}/review');
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Rate & Review Service Worker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            if (booking.status == BookingStatus.awaitingApproval) ...[
              const Text('Approve Completion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                isPaid
                    ? 'Your professional has marked this job as done. Approving releases your payment to them.'
                    : 'Your professional has marked this job as done. Approve to confirm and proceed to payment.',
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/profile/support'),
                      child: const Text('Report Problem'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await ref.read(bookingRepositoryProvider).approveCompletion(booking.id);
                        if (!context.mounted) return;
                        res.fold(
                          (_) {
                            ref.invalidate(paymentForBookingProvider(booking.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Completion approved')),
                            );
                          },
                          (failure) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(failure.message)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusSuccess,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Approve Completion'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            if (awaitingUpfrontPayment) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/bookings/${booking.id}/payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Pay ${booking.amountLabel} to confirm', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your booking is sent to the professional once payment is complete.',
                style: TextStyle(fontSize: 12, color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 16),
            ],

            if (!isPaid &&
                const {BookingStatus.completed, BookingStatus.paymentPending}
                    .contains(booking.status)) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/bookings/${booking.id}/payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Pay ${booking.amountLabel}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (const {BookingStatus.requested, BookingStatus.accepted, BookingStatus.confirmed}
                .contains(booking.status))
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _confirmCancel(context, ref, booking.id, isPaid: isPaid),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.statusError),
                  child: const Text('Cancel Booking'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static const _cancelReasons = [
    'Booked by mistake',
    'I no longer need this service',
    'I want to choose a different time',
    'I found someone else',
  ];

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String bookingId, {
    required bool isPaid,
  }) async {
    // The database requires a reason for every customer cancellation; sending
    // none made every cancel fail.
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Why are you cancelling?'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              isPaid
                  ? 'This cannot be undone. Your payment will be refunded to the original payment method.'
                  : 'This cannot be undone.',
              style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary),
            ),
          ),
          for (final option in _cancelReasons)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, option),
              child: Text(option),
            ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep booking', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (reason == null || !context.mounted) return;

    final res = await ref.read(bookingRepositoryProvider).cancelBooking(bookingId, reason: reason);
    if (!context.mounted) return;
    switch (res) {
      case Ok():
        ref.invalidate(paymentForBookingProvider(bookingId));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isPaid ? 'Booking cancelled. Your refund has been requested.' : 'Booking cancelled'),
        ));
      case Err(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }
}

class _ArrivalCodeSection extends ConsumerWidget {
  const _ArrivalCodeSection({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(arrivalCodeProvider(bookingId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_clock, color: Colors.brown),
              SizedBox(width: 8),
              Text(
                'Arrival Code',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Share this code with your professional to confirm they have arrived:',
            style: TextStyle(fontSize: 12, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          Center(
            child: codeAsync.when(
              data: (code) => Text(
                code ?? 'Unavailable',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: AppColors.primary,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Could not load code'),
            ),
          ),
        ],
      ),
    );
  }
}
