import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../core/localization/l10n.dart';

/// The reference-style vertical timeline: "Booking Confirmed" → "Provider
/// on the way" → "Service in Progress" → "Completed", each dot filled once
/// the booking has reached or passed that stage, outlined otherwise.
///
/// Purely a projection of the real [BookingStatus] — no invented steps or
/// timestamps; a step's timestamp is only ever shown if a caller supplies
/// one derived from real booking events.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.status});

  final BookingStatus status;

  static const _stages = [
    _Stage(_StageName.confirmed, {
      BookingStatus.confirmed,
      BookingStatus.traveling,
      BookingStatus.arrived,
      BookingStatus.inProgress,
      BookingStatus.awaitingApproval,
      BookingStatus.completed,
      BookingStatus.paymentPending,
      BookingStatus.paid,
      BookingStatus.closed,
    }),
    _Stage(_StageName.onTheWay, {
      BookingStatus.traveling,
      BookingStatus.arrived,
      BookingStatus.inProgress,
      BookingStatus.awaitingApproval,
      BookingStatus.completed,
      BookingStatus.paymentPending,
      BookingStatus.paid,
      BookingStatus.closed,
    }),
    _Stage(_StageName.inProgress, {
      BookingStatus.inProgress,
      BookingStatus.awaitingApproval,
      BookingStatus.completed,
      BookingStatus.paymentPending,
      BookingStatus.paid,
      BookingStatus.closed,
    }),
    _Stage(_StageName.completed, {
      BookingStatus.completed,
      BookingStatus.paymentPending,
      BookingStatus.paid,
      BookingStatus.closed,
    }),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_stages.length, (i) {
        final stage = _stages[i];
        final reached = stage.reachedAt.contains(status);
        final isLast = i == _stages.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: reached ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: reached ? AppColors.primary : AppColors.border,
                        width: 2,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: reached ? AppColors.primary : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Text(
                    stage.name.label(l10n),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: reached ? FontWeight.w600 : FontWeight.w400,
                      color: reached ? AppColors.ink : AppColors.inkTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Stage {
  const _Stage(this.name, this.reachedAt);
  final _StageName name;
  final Set<BookingStatus> reachedAt;
}

enum _StageName {
  confirmed,
  onTheWay,
  inProgress,
  completed;

  String label(AppLocalizations l10n) => switch (this) {
        _StageName.confirmed => l10n.timelineBookingConfirmed,
        _StageName.onTheWay => l10n.timelineProviderOnTheWay,
        _StageName.inProgress => l10n.timelineServiceInProgress,
        _StageName.completed => l10n.timelineCompleted,
      };
}
