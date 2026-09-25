import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/enums.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/service_icon.dart';
import '../../core/localization/l10n.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider).value;
    if (sessionState is! SessionReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final customerId = sessionState.customer.id;

    final bookingsAsync = ref.watch(customerBookingsProvider(customerId));
    // Bookings are paid upfront; an unpaid REQUESTED booking still needs
    // checkout and has not been sent to the professional.
    // Null, not an empty set, when the lookup has not answered yet or
    // failed: an empty set means "none of these are paid", which would put a
    // Pay now button on bookings the customer has already paid for.
    final paidIds = ref.watch(paidBookingIdsProvider).valueOrNull;
    final l10n = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.bookingsTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.bookingsTabActive),
              Tab(text: l10n.bookingsTabCompleted),
              Tab(text: l10n.bookingsTabCancelled),
            ],
          ),
        ),
        body: bookingsAsync.when(
          data: (bookings) {
            const endedStatuses = {
              BookingStatus.cancelled,
              BookingStatus.expired,
              BookingStatus.disputed,
            };
            final active = bookings
                .where((b) => !b.status.isFinished && !endedStatuses.contains(b.status))
                .toList();

            final completed = bookings
                .where((b) => b.status.isFinished)
                .toList();

            final cancelled = bookings
                .where((b) =>
                    endedStatuses.contains(b.status))
                .toList();

            return TabBarView(
              children: [
                _buildBookingList(context, active, paidIds, isLive: true),
                _buildBookingList(context, completed, paidIds),
                _buildBookingList(context, cancelled, paidIds),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorState(
            message: l10n.bookingsLoadFailed,
            onRetry: () {
              ref.invalidate(customerBookingsProvider(customerId));
              ref.invalidate(paidBookingIdsProvider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    List<Booking> list,
    Set<String>? paidIds, {
    bool isLive = false,
  }) {
    final l10n = context.l10n;
    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_outlined,
        title: l10n.bookingsEmpty,
        actionLabel: isLive ? l10n.bookingsFindService : null,
        onAction: isLive ? () => context.go('/explore') : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        final awaitingPayment = booking.awaitingPayment(paidIds);
        final statusLabel = awaitingPayment
            ? l10n.bookingStatusPaymentPending
            : booking.status == BookingStatus.requested
                ? l10n.bookingsWaitingForProfessional
                : booking.status.displayName;
        final statusColor =
            awaitingPayment ? AppColors.statusError : _getStatusColor(booking.status);
        // The one state where the booking is waiting on the customer, not on
        // anyone else: say so, and offer the way to act on it.
        final needsApproval = booking.status == BookingStatus.awaitingApproval;
        const trackable = {
          BookingStatus.traveling,
          BookingStatus.arrived,
          BookingStatus.inProgress,
        };
        // A plain Card with its own padding, not a ListTile: a ListTile lays
        // its title and subtitle out with unbounded width, and the buttons
        // below threw "BoxConstraints forces an infinite width" during layout,
        // which took the whole bookings list down to a blank screen.
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/bookings/${booking.id}'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          localizedServiceName(l10n, booking.serviceName),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.bookingsCode(booking.bookingCode),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.inkSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.addressLine,
                    style: const TextStyle(fontSize: 12, color: AppColors.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.amountLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                      if (awaitingPayment)
                        ElevatedButton(
                          onPressed: () =>
                              context.push('/bookings/${booking.id}/payment'),
                          style: _compactButton,
                          child: Text(l10n.bookingsPayNow),
                        )
                      else if (needsApproval)
                        ElevatedButton(
                          onPressed: () =>
                              context.push('/bookings/${booking.id}'),
                          style: _compactButton.copyWith(
                            backgroundColor: const WidgetStatePropertyAll(
                                AppColors.statusSuccess),
                          ),
                          child: Text(l10n.bookingsApproveWork),
                        )
                      else if (isLive && trackable.contains(booking.status))
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.push('/bookings/${booking.id}/active'),
                          icon: const Icon(Icons.navigation_outlined, size: 16),
                          label: Text(l10n.bookingsTrackLive),
                          style: _compactButton,
                        )
                      else
                        OutlinedButton(
                          onPressed: () =>
                              context.push('/bookings/${booking.id}'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(l10n.bookingsDetails),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Small enough to sit on a card row next to the price.
  static final ButtonStyle _compactButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
      case BookingStatus.accepted:
      case BookingStatus.confirmed:
        return AppColors.statusPending;
      case BookingStatus.traveling:
      case BookingStatus.arrived:
      case BookingStatus.inProgress:
      case BookingStatus.awaitingApproval:
        return AppColors.statusInProgress;
      case BookingStatus.completed:
      case BookingStatus.paid:
      case BookingStatus.closed:
        return AppColors.statusSuccess;
      case BookingStatus.cancelled:
      case BookingStatus.disputed:
      case BookingStatus.expired:
        return AppColors.statusError;
      default:
        return AppColors.statusPending;
    }
  }
}
