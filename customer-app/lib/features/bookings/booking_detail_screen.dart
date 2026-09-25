import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/utils/money_format.dart';
import '../../core/localization/l10n.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingStreamProvider(bookingId));
    final l10n = context.l10n;

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
          title: Text(l10n.bookingDetailTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goBack,
          ),
        ),
        body: bookingAsync.when(
          data: (booking) => _buildBody(context, ref, booking),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorState(
            message: l10n.bookingDetailLoadFailed,
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
    final l10n = context.l10n;
    final statusText = awaitingUpfrontPayment
        ? l10n.bookingStatusPaymentPending
        : booking.status == BookingStatus.requested
            ? l10n.bookingDetailWaitingAccept
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
                          l10n.bookingDetailNumber(booking.bookingCode),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          l10n.bookingDetailStatus(statusText),
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
                      child: Text(l10n.bookingDetailLiveMap),
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
            Text(l10n.bookingDetailServiceInfo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    Text(localizedServiceName(l10n, booking.serviceName), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              label: Text(l10n.bookingDetailViewMaterials),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fare breakdown
            Text(l10n.bookingDetailFareDetails, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      Text(l10n.bookingDetailEstimatedFare),
                      Text(formatRupees(booking.quotedAmountMinor)),
                    ],
                  ),
                  if (booking.finalAmountMinor != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.bookingDetailFinalFare, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  label: Text(l10n.bookingDetailRateReview),
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
              Text(l10n.bookingDetailApproveCompletion, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                isPaid
                    ? l10n.bookingDetailApprovePaidHint
                    : l10n.bookingDetailApproveUnpaidHint,
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/profile/support'),
                      child: Text(l10n.bookingDetailReportProblem),
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
                              SnackBar(content: Text(l10n.bookingDetailCompletionApproved)),
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
                      child: Text(l10n.bookingDetailApproveCompletion),
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
                  child: Text(l10n.bookingDetailPayToConfirm(booking.amountLabel), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.bookingDetailSentAfterPayment,
                style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
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
                  child: Text(l10n.bookingDetailPayAmount(booking.amountLabel), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  child: Text(l10n.bookingDetailCancelBooking),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Sent to the database in English whatever language is on screen: the
  /// reason is read by operations and the professional, not only the customer.
  static const _cancelReasons = [
    'Booked by mistake',
    'I no longer need this service',
    'I want to choose a different time',
    'I found someone else',
  ];

  static List<String> _cancelReasonLabels(AppLocalizations l10n) => [
        l10n.cancelReasonMistake,
        l10n.cancelReasonNoLongerNeeded,
        l10n.cancelReasonDifferentTime,
        l10n.cancelReasonFoundSomeoneElse,
      ];

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String bookingId, {
    required bool isPaid,
  }) async {
    // The database requires a reason for every customer cancellation; sending
    // none made every cancel fail.
    final l10n = context.l10n;
    final reasonLabels = _cancelReasonLabels(l10n);
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.cancelDialogTitle),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(
              isPaid
                  ? l10n.cancelDialogRefundNotice
                  : l10n.cancelDialogCannotUndo,
              style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary),
            ),
          ),
          for (var i = 0; i < _cancelReasons.length; i++)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, _cancelReasons[i]),
              child: Text(reasonLabels[i]),
            ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelDialogKeepBooking, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
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
          content: Text(isPaid ? l10n.bookingCancelledRefund : l10n.bookingCancelled),
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
    final l10n = context.l10n;

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
          Row(
            children: [
              const Icon(Icons.lock_clock, color: Colors.brown),
              const SizedBox(width: 8),
              Text(
                l10n.arrivalCodeTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.arrivalCodeShare,
            style: const TextStyle(fontSize: 12, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          Center(
            child: codeAsync.when(
              data: (code) => Text(
                code ?? l10n.arrivalCodeUnavailable,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: AppColors.primary,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(l10n.arrivalCodeLoadFailed),
            ),
          ),
        ],
      ),
    );
  }
}
