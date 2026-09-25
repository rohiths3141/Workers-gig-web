import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/service_names.dart';
import '../../evidence/presentation/evidence_controller.dart';
import '../../evidence/presentation/evidence_section.dart';
import 'jobs_controller.dart';
import 'widgets/arrival_sheet.dart';
import 'widgets/materials_section.dart';
import 'widgets/service_timer_card.dart';

/// The job the worker is on.
///
/// One screen for the whole visit, ordered so the next thing to do is always
/// the thing at the bottom, under the thumb. The primary action changes with
/// the booking state and is never enabled for a transition the server would
/// refuse — and when it is refused anyway, the reason is shown rather than
/// swallowed.
class ActiveJobScreen extends ConsumerWidget {
  const ActiveJobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeJobProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.activeJobTitle)),
      body: AsyncValueView<Job?>(
        value: active,
        onRetry: () => ref.invalidate(activeJobProvider),
        onData: (job) {
          if (job == null) {
            return EmptyStateView(
              icon: Icons.work_outline_rounded,
              title: context.l10n.jobsEmptyActive,
              message: context.l10n.activeJobEmptyBody,
            );
          }
          return JobExecutionView(bookingId: job.id);
        },
      ),
    );
  }
}

/// The execution view, also used from the job detail screen.
class JobExecutionView extends ConsumerWidget {
  const JobExecutionView({required this.bookingId, super.key});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = ref.watch(jobProvider(bookingId));
    final readiness = ref.watch(completionReadinessProvider(bookingId));

    return AsyncValueView<Job>(
      value: job,
      onRetry: () => ref.invalidate(jobProvider(bookingId)),
      onData: (data) => Column(
        children: [
          // Live location is broadcast by a leaf widget rather than watched
          // here: a GPS fix arrives every few seconds, and rebuilding the whole
          // view on each one threw the list back to the top, so the worker
          // could never stay at the bottom of the page.
          _LocationBroadcaster(bookingId: bookingId),
          Expanded(
            child: ListView(
              // Keeps the scroll offset across rebuilds (evidence uploads,
              // material updates, status changes).
              key: PageStorageKey<String>('job-body-$bookingId'),
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                _JobHeader(job: data),
                const SizedBox(height: AppSpacing.lg),

                if (data.status == BookingStatus.inProgress &&
                    data.workStartedAt != null) ...[
                  ServiceTimerCard(startedAt: data.workStartedAt!),
                  const SizedBox(height: AppSpacing.lg),
                ],

                _CustomerCard(job: data),
                const SizedBox(height: AppSpacing.lg),

                _ProgressTrail(job: data),
                const SizedBox(height: AppSpacing.lg),

                // Evidence only once the worker is actually on site. Offering
                // "before work" photos while they are still driving invites
                // photographs of nothing.
                if (data.status == BookingStatus.inProgress ||
                    data.status == BookingStatus.arrived) ...[
                  EvidenceSection(
                    target: EvidenceTarget(
                      purpose: MediaPurpose.bookingBeforeWork,
                      bookingId: bookingId,
                    ),
                    title: context.l10n.evidenceBeforeTitle,
                    explanation: context.l10n.evidenceBeforeBody,
                    isRequired: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                if (data.status == BookingStatus.inProgress) ...[
                  MaterialsSection(bookingId: bookingId),
                  const SizedBox(height: AppSpacing.md),
                  EvidenceSection(
                    target: EvidenceTarget(
                      purpose: MediaPurpose.bookingAfterWork,
                      bookingId: bookingId,
                    ),
                    title: context.l10n.evidenceAfterTitle,
                    explanation: context.l10n.evidenceAfterBody,
                    allowVideo: true,
                    isRequired: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // The checklist is shown when something is genuinely blocking,
                // so the worker learns what is missing before they tap and are
                // refused.
                readiness.maybeWhen(
                  data: (r) => r.canComplete || !_isNearCompletion(data.status)
                      ? const SizedBox.shrink()
                      : _BlockerList(readiness: r),
                  orElse: () => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppSpacing.huge),
              ],
            ),
          ),
          _PrimaryAction(job: data, bookingId: bookingId),
        ],
      ),
    );
  }

  static bool _isNearCompletion(BookingStatus status) =>
      status == BookingStatus.inProgress || status == BookingStatus.arrived;
}

/// Reports this worker's position for as long as it is on screen and the job is
/// in a trackable state. It draws nothing; watching the provider from a leaf
/// keeps each GPS fix from rebuilding the page around it.
class _LocationBroadcaster extends ConsumerWidget {
  const _LocationBroadcaster({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(locationBroadcastProvider(bookingId));
    return const SizedBox.shrink();
  }
}

class _JobHeader extends StatelessWidget {
  const _JobHeader({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
          Text(job.gigTitle ?? localizedServiceName(context.l10n, job.serviceName),
              style: AppTypography.headlineMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.sm),
          Text(job.problemDescription,
              style:
                  AppTypography.bodyMedium.copyWith(color: context.inkSecondary)),
          if (job.earnings != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text(context.l10n.jobOfferYouEarn,
                    style: AppTypography.label
                        .copyWith(color: context.inkSecondary)),
                const Spacer(),
                Text(job.earnings!.format(),
                    style: AppTypography.amountLarge
                        .copyWith(color: AppColors.earnings)),
              ],
            ),
            if (job.materialAmount.isPositive)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Text(context.l10n.jobMaterials,
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkTertiary)),
                    const Spacer(),
                    Text(job.materialAmount.format(),
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkSecondary)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Customer details and the two ways to reach them.
///
/// Contact details appear only when the server released them — before the job
/// is assigned the embed comes back empty and this shows the area instead.
class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, color: context.inkSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  job.customerName ?? context.l10n.jobCustomerHidden,
                  style: AppTypography.titleMedium.copyWith(color: context.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place_outlined, color: context.inkSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  job.hasCustomerContact ? job.addressLine : job.approximateArea,
                  style: AppTypography.bodyMedium
                      .copyWith(color: context.inkSecondary),
                ),
              ),
            ],
          ),
          if (job.hasCustomerContact) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _call(job.customerPhone!),
                    icon: const Icon(Icons.call_outlined),
                    label: FittedBox(
                        fit: BoxFit.scaleDown, child: Text(context.l10n.jobCall)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    // Hands off to whichever maps app the worker already has.
                    // There is no embedded map and no invented coordinate: if
                    // the booking has no location, this is not offered.
                    onPressed: job.isNavigable
                        ? () => _navigate(job.latitude!, job.longitude!)
                        : null,
                    icon: const Icon(Icons.directions_outlined),
                    // Icon plus label does not fit half a phone width, so the
                    // label used to wrap to "Direction / s".
                    label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(context.l10n.jobDirections)),
                  ),
                ),
              ],
            ),
            if (job.isNavigable &&
                (job.status == BookingStatus.traveling ||
                    job.status == BookingStatus.arrived)) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push(Routes.travelMap(job.id)),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(context.l10n.jobTrackOnMap),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _navigate(double lat, double lng) async {
    final uri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    final fallback =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(fallback)) {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }
}

/// Where the job has got to, as a vertical trail of real timestamps.
class _ProgressTrail extends StatelessWidget {
  const _ProgressTrail({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = <(String, DateTime?)>[
      (l10n.trailAccepted, job.acceptedAt),
      (l10n.trailOnTheWay, job.travelStartedAt),
      (l10n.trailArrived, job.arrivedAt),
      (l10n.trailArrivalConfirmed, job.arrivalVerifiedAt),
      (l10n.trailWorkStarted, job.workStartedAt),
      (l10n.trailFinished, job.completedAt),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.jobProgress,
              style: AppTypography.titleMedium.copyWith(color: context.ink)),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < steps.length; i++)
            _TrailStep(
              label: steps[i].$1,
              at: steps[i].$2,
              isLast: i == steps.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TrailStep extends StatelessWidget {
  const _TrailStep({required this.label, required this.at, required this.isLast});

  final String label;
  final DateTime? at;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = at != null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                done ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 20,
                color: done ? AppColors.success : context.inkTertiary,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? AppColors.success : context.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: done ? context.ink : context.inkTertiary,
                      ),
                    ),
                  ),
                  if (done)
                    Text(
                      TimeOfDay.fromDateTime(at!).format(context),
                      style: AppTypography.bodySmall
                          .copyWith(color: context.inkTertiary),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockerList extends StatelessWidget {
  const _BlockerList({required this.readiness});

  final CompletionReadiness readiness;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.warningSurface,
      borderColor: AppColors.warning.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.jobBeforeFinish,
              style: AppTypography.titleMedium.copyWith(color: AppColors.warning)),
          const SizedBox(height: AppSpacing.sm),
          for (final blocker in readiness.blockers)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.radio_button_unchecked,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(blocker,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.warning)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The single most important control on the screen: the next step.
class _PrimaryAction extends ConsumerWidget {
  const _PrimaryAction({required this.job, required this.bookingId});

  final Job job;
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(jobActionsProvider).isLoading;
    final readiness =
        ref.watch(completionReadinessProvider(bookingId)).valueOrNull;

    final next = job.status.workerNextStatus;

    // Nothing for the worker to do: the ball is with the customer, the payment
    // system, or operations. Saying so is better than a disabled button.
    if (next == null) {
      return _WaitingFooter(job: job);
    }

    // Arrival is a code entry, not a status tap.
    final needsArrivalCode =
        job.status == BookingStatus.arrived && !job.isArrivalVerified;

    final l10n = context.l10n;
    final label = switch (job.status) {
      BookingStatus.confirmed => l10n.jobActionStartTravel,
      BookingStatus.traveling => l10n.jobActionArrived,
      BookingStatus.arrived =>
        needsArrivalCode ? l10n.jobActionEnterCode : l10n.jobActionStartWork,
      BookingStatus.inProgress => l10n.jobActionFinish,
      _ => l10n.commonContinue,
    };

    // Unknown readiness means the check has not answered yet, not that the
    // worker is blocked: the server validates the move anyway, and a disabled
    // button with nothing to explain it is worse than a refused tap.
    final canComplete = job.status != BookingStatus.inProgress ||
        (readiness?.canComplete ?? true);

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: context.surface,
        border: Border(top: BorderSide(color: context.border)),
      ),
      child: SizedBox(
        height: AppSpacing.primaryActionHeight,
        child: FilledButton(
          onPressed: isBusy || !canComplete
              ? null
              : () => _act(context, ref, next, needsArrivalCode),
          child: isBusy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }

  Future<void> _act(
    BuildContext context,
    WidgetRef ref,
    BookingStatus next,
    bool needsArrivalCode,
  ) async {
    // Arrival verification first. Only a server-confirmed code lets the job
    // move to IN_PROGRESS, and the server refuses the transition regardless.
    if (needsArrivalCode) {
      final verified = await ArrivalSheet.show(context, bookingId);
      if (!context.mounted) return;
      if (verified) {
        ref.invalidate(jobProvider(bookingId));
        showSuccess(context, context.l10n.jobArrivalConfirmed);
      }
      return;
    }

    if (next == BookingStatus.awaitingApproval) {
      final confirmed = await confirmAction(
        context,
        title: context.l10n.jobFinishTitle,
        message: context.l10n.jobFinishBody,
        confirmLabel: context.l10n.jobActionFinish,
      );
      if (!confirmed || !context.mounted) return;
    }

    final result =
        await ref.read(jobActionsProvider.notifier).advance(bookingId, next);

    if (!context.mounted) return;

    result.fold(
      (updated) {
        ref.invalidate(jobProvider(bookingId));
        ref.invalidate(completionReadinessProvider(bookingId));
        showSuccess(
          context,
          switch (updated.status) {
            BookingStatus.traveling => context.l10n.jobOnYourWay,
            BookingStatus.arrived => context.l10n.jobMarkedArrived,
            BookingStatus.inProgress => context.l10n.jobWorkStarted,
            BookingStatus.awaitingApproval => context.l10n.jobSentForApproval,
            _ => context.l10n.jobUpdated,
          },
        );
      },
      (failure) => showFailure(context, failure.message),
    );
  }
}

class _WaitingFooter extends StatelessWidget {
  const _WaitingFooter({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final message = switch (job.status) {
      BookingStatus.accepted => l10n.jobWaitConfirm,
      BookingStatus.awaitingApproval => l10n.jobWaitApprove,
      BookingStatus.completed => l10n.jobWaitPaymentProcessing,
      BookingStatus.paymentPending => l10n.jobWaitPayment,
      BookingStatus.paid => l10n.jobWaitPaid,
      BookingStatus.disputed => l10n.jobWaitDisputed,
      _ => l10n.jobWaitNothing,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: context.surfaceMuted,
        border: Border(top: BorderSide(color: context.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.hourglass_empty_rounded, size: 20, color: context.inkSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(message,
                style: AppTypography.bodyMedium
                    .copyWith(color: context.inkSecondary)),
          ),
          if (job.status == BookingStatus.disputed)
            TextButton(
              onPressed: () => context.push(Routes.support),
              child: Text(l10n.homeSupport),
            ),
        ],
      ),
    );
  }
}
