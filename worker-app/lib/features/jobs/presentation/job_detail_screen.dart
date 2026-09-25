import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'active_job_screen.dart';
import 'jobs_controller.dart';
import 'widgets/rate_customer_sheet.dart';
import '../../../core/localization/l10n.dart';
import '../../../shared/widgets/service_names.dart';

/// One job.
///
/// A job the worker is currently doing gets the execution view; a finished or
/// cancelled one gets a record of what happened. Which of the two is decided by
/// the booking status the server reports, not by how the screen was reached.
class JobDetailScreen extends ConsumerWidget {
  const JobDetailScreen({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: Text(job.valueOrNull?.bookingCode ?? context.l10n.jobTitleFallback),
      ),
      body: AsyncValueView<Job>(
        value: job,
        onRetry: () => ref.invalidate(jobProvider(bookingId)),
        onData: (data) => data.status.isActive
            ? JobExecutionView(bookingId: bookingId)
            : _JobRecord(job: data),
      ),
    );
  }
}

class _JobRecord extends ConsumerWidget {
  const _JobRecord({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(jobTimelineProvider(job.id));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadge.forBooking(job.status),
              const SizedBox(height: AppSpacing.md),
              Text(job.gigTitle ?? localizedServiceName(context.l10n, job.serviceName),
                  style: AppTypography.headlineMedium
                      .copyWith(color: context.ink)),
              const SizedBox(height: AppSpacing.sm),
              Text(job.problemDescription,
                  style: AppTypography.bodyMedium
                      .copyWith(color: context.inkSecondary)),
              if (job.cancellationReason != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.dangerSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    context.l10n.jobCancelledReason(job.cancellationReason ?? ''),
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.danger),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // The money, laid out so gross, fee and net are all visible. Each line
        // is only shown when the server actually supplied it.
        if (job.status.isFinished) ...[
          AppCard(
            child: Column(
              children: [
                if (job.quotedAmount != null)
                  DetailRow(
                    label: context.l10n.jobAmount,
                    value: job.quotedAmount!.format(),
                  ),
                if (job.materialAmount.isPositive)
                  DetailRow(
                    label: context.l10n.jobMaterials,
                    value: job.materialAmount.format(),
                  ),
                if (job.platformFee != null && job.platformFee!.isPositive)
                  DetailRow(
                    label: context.l10n.walletTxPlatformFee,
                    value: '-${job.platformFee!.format()}',
                  ),
                if (job.earnings != null) ...[
                  const Divider(height: AppSpacing.xl),
                  DetailRow(
                    label: context.l10n.jobYouEarned,
                    value: job.earnings!.format(),
                    valueStyle: AppTypography.amountLarge
                        .copyWith(color: AppColors.earnings),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        if (job.status.isFinished && job.customerName != null) ...[
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.jobRateCustomer,
                          style: AppTypography.titleMedium
                              .copyWith(color: context.ink)),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        context.l10n.jobRateQuestion,
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkSecondary),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => RateCustomerSheet.show(context, job.id),
                  child: Text(context.l10n.jobRate),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        SectionHeader(title: context.l10n.jobHistory, subtitle: job.bookingCode),
        timeline.when(
          loading: () => const ListSkeleton(itemCount: 3, itemHeight: 48),
          error: (error, _) => Text(
            context.l10n.jobHistoryLoadFailed,
            style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
          ),
          data: (events) => AppCard(
            child: Column(
              children: [
                for (final event in events)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle,
                            size: 8, color: context.inkTertiary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_humanise(context.l10n, event.eventType),
                                  style: AppTypography.bodyMedium
                                      .copyWith(color: context.ink)),
                              if (event.note != null)
                                Text(event.note!,
                                    style: AppTypography.bodySmall
                                        .copyWith(color: context.inkSecondary)),
                            ],
                          ),
                        ),
                        Text(
                          DateFormat('d MMM, h:mm a', context.dateLocale)
                              .format(event.createdAt),
                          style: AppTypography.bodySmall
                              .copyWith(color: context.inkTertiary),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// WORKER_ACCEPTED -> "Worker accepted".
  /// Booking-status events read like the status badges. Any other event
  /// type is shown as its code, made readable.
  static String _humanise(AppLocalizations l10n, String eventType) {
    for (final status in BookingStatus.values) {
      if (status.wire == eventType) return bookingStatusLabel(l10n, status);
    }
    final words = eventType.toLowerCase().replaceAll('_', ' ');
    return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
  }
}
