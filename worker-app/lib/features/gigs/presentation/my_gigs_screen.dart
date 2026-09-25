import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/gig.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
import 'gigs_controller.dart';

/// My services.
///
/// One worker, many services, across as many trades as they are approved for.
/// An AC technician who also paints has four gigs here, not four accounts, and
/// the "Add a service" button is never disabled because they already have one.
class MyGigsScreen extends ConsumerWidget {
  const MyGigsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final gigs = ref.watch(myGigsProvider);
    final worker = ref.watch(currentWorkerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gigsTitle),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.gigEditor),
            icon: const Icon(Icons.add_rounded),
            tooltip: l10n.gigsAddTooltip,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.gigEditor),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.gigsAdd),
      ),
      body: AsyncValueView<List<Gig>>(
        value: gigs,
        onRetry: () => ref.invalidate(myGigsProvider),
        loading: const ListSkeleton(itemHeight: 140),
        onData: (items) {
          if (items.isEmpty) {
            return EmptyStateView(
              icon: Icons.storefront_outlined,
              title: l10n.gigsEmpty,
              message: l10n.gigsEmptyBody,
            );
          }

          final live = items.where((g) => g.status.isLive).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
              AppSpacing.huge * 2,
            ),
            children: [
              // Both halves of matching stated together: a live service on an
              // off-duty worker wins nothing, and that is worth saying rather
              // than leaving the worker to wonder.
              AppCard(
                backgroundColor: context.surfaceMuted,
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 20, color: context.inkSecondary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        live == 0
                            ? l10n.gigsNoneLive
                            : '${l10n.gigsLiveCount(live)} '
                                '${worker?.availability.isAvailable ?? false ? l10n.gigsAvailable : l10n.gigsOffDuty}',
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              for (final gig in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _GigCard(gig: gig),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GigCard extends ConsumerWidget {
  const _GigCard({required this.gig});

  final Gig gig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isBusy = ref.watch(gigActionsProvider).isLoading;

    return AppCard(
      onTap: () => context.push(Routes.gig(gig.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge.forGig(gig.status),
              const Spacer(),
              if (gig.jobsCompleted > 0)
                Text(l10n.gigJobsDone(gig.jobsCompleted),
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkTertiary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(gig.title,
              style: AppTypography.titleLarge.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.xxs),
          Text(localizedServiceName(l10n, gig.serviceName),
              style:
                  AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(gig.priceLabel,
                  style:
                      AppTypography.amountLarge.copyWith(color: context.ink)),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.schedule_rounded, size: 16, color: context.inkTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text(gig.durationLabel,
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkSecondary)),
            ],
          ),

          if (gig.rejectionReason != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.dangerSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(gig.rejectionReason!,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.danger)),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      gig.status.isEditable ? () => context.push(Routes.gig(gig.id)) : null,
                  child: Text(l10n.gigEdit),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Only a real action gets a button. A gig in review or rejected
              // used to show one reading "Not live" — a status word on a
              // control that did nothing when tapped.
              Expanded(
                child: gig.status.canPause || gig.status.canResume
                    ? OutlinedButton(
                        onPressed: isBusy ? null : () => _toggle(context, ref),
                        child: Text(
                            gig.status.canPause ? l10n.gigPause : l10n.gigResume),
                      )
                    : Text(
                        _inactiveReason(l10n, gig.status),
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkTertiary),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Why this gig has no pause/resume action, in the worker's words.
  static String _inactiveReason(AppLocalizations l10n, GigStatus status) =>
      switch (status) {
        GigStatus.pendingReview => l10n.gigInReview,
        GigStatus.draft => l10n.gigDraftHint,
        GigStatus.rejected => l10n.gigRejectedHint,
        GigStatus.archived => l10n.gigArchived,
        _ => l10n.gigNotLive,
      };

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(gigActionsProvider.notifier);

    // Only pause and resume are the worker's to do. Making a draft or a
    // rejected gig live goes back through review, which is why neither is
    // offered here.
    if (gig.status.canPause) {
      final result = await controller.pause(gig.id);
      if (!context.mounted) return;
      result.fold(
        (_) => showSuccess(context, context.l10n.gigPaused),
        (failure) => showFailure(context, failure.message),
      );
      return;
    }

    if (gig.status.canResume) {
      final result = await controller.resume(gig.id);
      if (!context.mounted) return;
      result.fold(
        (_) => showSuccess(context, context.l10n.gigLiveAgain),
        (failure) => showFailure(context, failure.message),
      );
    }
  }
}
