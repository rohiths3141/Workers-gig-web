import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/money/money.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/worker.dart';
import '../../../../shared/widgets/common_widgets.dart';

/// Account status and work availability, side by side.
///
/// Two separate facts, shown separately. Conflating "am I verified" with "am I
/// available" is what made the previous app confusing: a worker could be
/// verified and off duty, or pending verification and keen to work, and the
/// product has to be able to say both.
class StatusSummaryCard extends StatelessWidget {
  const StatusSummaryCard({required this.worker, super.key});

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor, statusIcon) = switch (worker.status) {
      WorkerStatus.active => ('Verified', AppColors.success, Icons.verified_rounded),
      WorkerStatus.registered =>
        ('Setup incomplete', AppColors.inkTertiary, Icons.edit_outlined),
      WorkerStatus.verificationPending =>
        ('Under review', AppColors.info, Icons.schedule_rounded),
      WorkerStatus.inactive =>
        ('Inactive', AppColors.inkTertiary, Icons.pause_circle_outline),
      WorkerStatus.restricted =>
        ('Restricted', AppColors.warning, Icons.warning_amber_rounded),
      WorkerStatus.suspended => ('Suspended', AppColors.danger, Icons.block_rounded),
      WorkerStatus.rejected =>
        ('Not approved', AppColors.danger, Icons.cancel_outlined),
      WorkerStatus.deactivated =>
        ('Closed', AppColors.inkTertiary, Icons.remove_circle_outline),
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Fact(
                  label: 'Account',
                  value: statusLabel,
                  color: statusColor,
                  icon: statusIcon,
                ),
              ),
              Container(width: 1, height: 40, color: context.border),
              Expanded(
                child: _Fact(
                  label: 'Work status',
                  value: switch (worker.availability) {
                    WorkerAvailability.available => 'Available',
                    WorkerAvailability.busy => 'On a job',
                    WorkerAvailability.offline => 'Off duty',
                  },
                  color: switch (worker.availability) {
                    WorkerAvailability.available => AppColors.available,
                    WorkerAvailability.busy => AppColors.busy,
                    WorkerAvailability.offline => AppColors.offline,
                  },
                  icon: Icons.circle,
                  iconSize: 10,
                ),
              ),
            ],
          ),

          // A restriction is explained, not hidden. A worker who suddenly finds
          // features missing and no reason given will assume the app is broken.
          if (worker.restrictionReason != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                worker.restrictionReason!,
                style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.iconSize = 16,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(icon, size: iconSize, color: color),
            const SizedBox(width: AppSpacing.xs + 2),
            Flexible(
              child: Text(
                value,
                style: AppTypography.titleMedium.copyWith(color: context.ink),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Today's and this week's earnings.
class EarningsCard extends StatelessWidget {
  const EarningsCard({
    required this.earnings,
    required this.onOpenWallet,
    super.key,
  });

  final EarningsSummary earnings;
  final VoidCallback onOpenWallet;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onOpenWallet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Today',
                  style: AppTypography.label.copyWith(color: context.inkSecondary)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: context.inkTertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            earnings.today.format(),
            style: AppTypography.numericHero.copyWith(color: AppColors.earnings),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: 'This week', value: earnings.thisWeek),
              ),
              Expanded(
                child: _MiniStat(label: 'This month', value: earnings.thisMonth),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final Money value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
        const SizedBox(height: AppSpacing.xxs),
        Text(value.format(),
            style: AppTypography.amount.copyWith(color: context.ink)),
      ],
    );
  }
}

/// The job the worker is on right now.
///
/// When there is one, it is the most important thing after availability: it is
/// what the worker has come into the app to act on.
class ActiveJobCard extends StatelessWidget {
  const ActiveJobCard({required this.job, required this.onOpen, super.key});

  final Job job;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final nextAction = switch (job.status) {
      BookingStatus.accepted => 'Waiting for the customer to confirm',
      BookingStatus.confirmed => 'Start travelling',
      BookingStatus.traveling => 'Mark yourself as arrived',
      BookingStatus.arrived => job.isArrivalVerified
          ? 'Start the work'
          : 'Ask the customer for the arrival code',
      BookingStatus.inProgress => 'Finish and add photos',
      BookingStatus.awaitingApproval => 'Waiting for the customer to approve',
      _ => 'Open job',
    };

    return AppCard(
      onTap: onOpen,
      borderColor: AppColors.primary.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge.forBooking(job.status),
              const Spacer(),
              Text(job.bookingCode,
                  style:
                      AppTypography.bodySmall.copyWith(color: context.inkTertiary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(job.gigTitle ?? job.serviceName,
              style: AppTypography.titleLarge.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            job.customerName ?? job.approximateArea,
            style: AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_forward_rounded,
                    size: 18, color: AppColors.primaryDark),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    nextAction,
                    style: AppTypography.label
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A scheduled job in the day ahead.
class UpcomingJobTile extends StatelessWidget {
  const UpcomingJobTile({required this.job, required this.onOpen, super.key});

  final Job job;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final time = job.scheduledAt == null
        ? 'Time to be confirmed'
        : DateFormat('h:mm a').format(job.scheduledAt!);

    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.gigTitle ?? job.serviceName,
                    style:
                        AppTypography.titleMedium.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.xxs),
                Text('$time · ${job.approximateArea}',
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary)),
              ],
            ),
          ),
          if (job.earnings != null)
            Text(job.earnings!.format(),
                style: AppTypography.amount.copyWith(color: AppColors.earnings)),
        ],
      ),
    );
  }
}

/// A shortcut row on the home screen.
class QuickAction extends StatelessWidget {
  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            // Comfortably above the 48dp floor: this is tapped in a hurry.
            constraints: const BoxConstraints(minHeight: 84),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  isLabelVisible: badgeCount > 0,
                  label: Text('$badgeCount'),
                  child: Icon(icon, size: 26, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(label,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
