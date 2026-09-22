import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../domain/entities/job.dart';
import '../../../../shared/widgets/common_widgets.dart';

/// An open offer, with a live countdown.
///
/// Shows only what a worker needs to decide, and nothing that identifies the
/// customer: before the job is assigned they get an area and a distance, not a
/// name and an address. That split is enforced by RLS, and the card is built
/// around it rather than working against it.
class JobOfferCard extends StatefulWidget {
  const JobOfferCard({
    required this.offer,
    required this.onAccept,
    required this.onDecline,
    required this.onOpen,
    this.isBusy = false,
    super.key,
  });

  final JobOffer offer;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onOpen;
  final bool isBusy;

  @override
  State<JobOfferCard> createState() => _JobOfferCardState();
}

class _JobOfferCardState extends State<JobOfferCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // One second is the right granularity for a ten-minute window: the worker
    // can see it moving, and it costs one setState per second on one card.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final remaining = offer.timeRemaining;
    final isExpiring = remaining.inSeconds < 120;

    if (offer.isExpired) {
      return AppCard(
        child: Row(
          children: [
            Icon(Icons.timer_off_outlined, color: context.inkTertiary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'This job is no longer available.',
                style: AppTypography.bodyMedium
                    .copyWith(color: context.inkSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      onTap: widget.onOpen,
      borderColor: AppColors.primary.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const StatusBadge(label: 'NEW JOB', color: AppColors.primary),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (isExpiring ? AppColors.danger : AppColors.inkTertiary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 14,
                        color:
                            isExpiring ? AppColors.danger : AppColors.inkTertiary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _formatRemaining(remaining),
                      style: AppTypography.badge.copyWith(
                        color: isExpiring
                            ? AppColors.danger
                            : AppColors.inkTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          Text(offer.job.serviceName,
              style: AppTypography.titleLarge.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            offer.job.problemDescription,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _Fact(
                icon: Icons.near_me_outlined,
                label: '${offer.distanceKm.toStringAsFixed(1)} km away',
              ),
              _Fact(
                icon: Icons.place_outlined,
                label: offer.job.approximateArea,
              ),
              if (offer.job.scheduledAt != null)
                _Fact(
                  icon: Icons.schedule_rounded,
                  label: DateFormat('d MMM, h:mm a')
                      .format(offer.job.scheduledAt!),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.earningsSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Text('You earn',
                    style: AppTypography.label
                        .copyWith(color: AppColors.earnings)),
                const Spacer(),
                // No amount means the price is settled after the visit. Saying
                // so is better than printing a number that might be wrong.
                Text(
                  offer.estimatedEarning?.format() ?? 'Confirmed after the visit',
                  style: AppTypography.amountLarge
                      .copyWith(color: AppColors.earnings),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: AppSpacing.primaryActionHeight,
                  child: OutlinedButton(
                    onPressed: widget.isBusy ? null : widget.onDecline,
                    // The narrower half of the row: without this the label
                    // broke across two lines as "Decli / ne".
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Decline'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: AppSpacing.primaryActionHeight,
                  child: FilledButton(
                    onPressed: widget.isBusy ? null : widget.onAccept,
                    child: widget.isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Accept job'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatRemaining(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// A job in a list.
///
/// Gives every card the same visual anchor a service card has elsewhere in
/// the product — a coloured icon tile at the leading edge — instead of a flat
/// block of text, so a worker scanning the list orients on shape and colour
/// first the same way they would on a photo.
class JobListTile extends StatelessWidget {
  const JobListTile({required this.job, required this.onOpen, super.key});

  final Job job;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.home_repair_service_rounded,
                color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The badge and the title fought over one line, and the
                // badge won: "Ceiling fan installation" became "Ceili…".
                // The job's name is what the worker is looking for, so it
                // gets the line.
                Text(
                  job.gigTitle ?? job.serviceName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium.copyWith(color: context.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge.forBooking(job.status),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  job.customerName ?? job.approximateArea,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTypography.bodySmall.copyWith(color: context.inkSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 14, color: context.inkTertiary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      job.scheduledAt == null
                          ? DateFormat('d MMM').format(job.createdAt)
                          : DateFormat('d MMM, h:mm a').format(job.scheduledAt!),
                      style: AppTypography.bodySmall
                          .copyWith(color: context.inkSecondary),
                    ),
                    const Spacer(),
                    if (job.earnings != null)
                      Text(
                        job.earnings!.format(),
                        style: AppTypography.amount.copyWith(
                          color: job.status.isFinished
                              ? AppColors.earnings
                              : context.ink,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.inkTertiary),
        const SizedBox(width: AppSpacing.xs),
        Text(label,
            style: AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
      ],
    );
  }
}
