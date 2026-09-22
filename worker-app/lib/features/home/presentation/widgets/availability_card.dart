import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../domain/entities/enums.dart';
import '../../../../domain/entities/worker.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../home_controller.dart';

/// The availability control.
///
/// The single most important thing on the screen. A worker must be able to
/// answer "am I available for work right now?" within a second of opening the
/// app, and change it in one tap, so this sits at the top and is the largest
/// interactive element in the product. It is never buried in settings.
///
/// It is also never a silent no-op. When the server refuses, the reasons come
/// back with the refusal and are rendered as a list of things the worker can
/// actually go and do.
class AvailabilityCard extends ConsumerWidget {
  const AvailabilityCard({
    required this.availability,
    required this.eligibility,
    required this.onBlocked,
    super.key,
  });

  final WorkerAvailability availability;
  final WorkerEligibility eligibility;
  final void Function(PermissionFailure failure) onBlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(availabilityControllerProvider).isLoading;
    final isAvailable = availability.isAvailable;
    final isOnJob = availability == WorkerAvailability.busy;

    final (accent, surface, label, explanation) = switch (availability) {
      WorkerAvailability.available => (
          AppColors.available,
          AppColors.available.withValues(alpha: 0.10),
          'AVAILABLE',
          'You can receive new jobs.',
        ),
      WorkerAvailability.busy => (
          AppColors.busy,
          AppColors.busy.withValues(alpha: 0.10),
          'ON A JOB',
          'You will not be offered new work until this job is done.',
        ),
      WorkerAvailability.offline => (
          AppColors.offline,
          AppColors.offline.withValues(alpha: 0.08),
          'OFF',
          'You will not receive new jobs.',
        ),
    };

    return AppCard(
      backgroundColor: surface,
      borderColor: accent.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppTypography.badge.copyWith(color: accent)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            explanation,
            style: AppTypography.bodyLarge.copyWith(color: context.ink),
          ),
          const SizedBox(height: AppSpacing.lg),

          // BUSY is set by the platform while a job is in flight, so there is
          // nothing to toggle — showing a disabled switch would suggest the
          // worker had done something wrong.
          if (isOnJob)
            Text(
              'Finish your current job to become available again.',
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary),
            )
          else
            SizedBox(
              width: double.infinity,
              height: AppSpacing.primaryActionHeight,
              child: FilledButton(
                onPressed: isBusy ? null : () => _toggle(context, ref, isAvailable),
                style: FilledButton.styleFrom(
                  backgroundColor: isAvailable ? AppColors.offline : accent,
                ),
                child: isBusy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(isAvailable ? 'Go off duty' : 'Go available'),
              ),
            ),

          // A worker who cannot go available sees why, before they tap.
          if (!isAvailable && !isOnJob && !eligibility.isEligible) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Before you can receive jobs',
              style: AppTypography.label.copyWith(color: context.inkSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Each reason with a destination is tappable, the same as in the
            // "Not quite ready" sheet; before, this list looked actionable but
            // did nothing.
            for (final reason in eligibility.reasons)
              InkWell(
                onTap: reason.action == null
                    ? null
                    : () => context.push('/${reason.action}'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.radio_button_unchecked,
                          size: 18, color: context.inkTertiary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(reason.message,
                            style: AppTypography.bodyMedium
                                .copyWith(color: context.ink)),
                      ),
                      if (reason.action != null)
                        Icon(Icons.chevron_right_rounded,
                            size: 20, color: context.inkTertiary),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    bool isCurrentlyAvailable,
  ) async {
    final target = isCurrentlyAvailable
        ? WorkerAvailability.offline
        : WorkerAvailability.available;

    final result =
        await ref.read(availabilityControllerProvider.notifier).toggle(target);

    if (!context.mounted) return;

    result.fold(
      (updated) => showSuccess(
        context,
        updated.availability.isAvailable
            ? 'You are available for work.'
            : 'You are off duty.',
      ),
      (failure) {
        if (failure is PermissionFailure) {
          onBlocked(failure);
        } else {
          showFailure(context, failure.message);
        }
      },
    );
  }
}
