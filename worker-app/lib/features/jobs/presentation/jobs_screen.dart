import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'jobs_controller.dart';
import 'widgets/job_cards.dart';
import '../../../core/localization/l10n.dart';

/// The jobs list, by stage.
class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 5, vsync: this);

  static const _filters = [
    JobListFilter.offers,
    JobListFilter.upcoming,
    JobListFilter.active,
    JobListFilter.completed,
    JobListFilter.cancelled,
  ];

  static String _filterLabel(AppLocalizations l10n, JobListFilter filter) =>
      switch (filter) {
        JobListFilter.offers => l10n.badgeNew,
        JobListFilter.upcoming => l10n.jobsTabUpcoming,
        JobListFilter.active => l10n.jobsTabActive,
        JobListFilter.completed => l10n.badgeDone,
        JobListFilter.cancelled => l10n.badgeCancelled,
      };

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navJobs),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            for (final filter in _filters) Tab(text: _filterLabel(l10n, filter)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          const _OffersTab(),
          for (final filter in _filters.skip(1)) _JobListTab(filter: filter),
        ],
      ),
    );
  }
}

/// Open offers. Live, because an offer the worker can no longer accept should
/// disappear rather than fail when they tap it.
class _OffersTab extends ConsumerWidget {
  const _OffersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);
    final isBusy = ref.watch(jobActionsProvider).isLoading;

    return AsyncValueView<List<JobOffer>>(
      value: offers,
      onRetry: () => ref.invalidate(offersProvider),
      onData: (items) {
        if (items.isEmpty) {
          return EmptyStateView(
            icon: Icons.work_outline_rounded,
            title: context.l10n.jobsNoOffers,
            message: context.l10n.jobsNoOffersBody,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, index) {
            final offer = items[index];
            return JobOfferCard(
              offer: offer,
              isBusy: isBusy,
              onOpen: () => context.push(Routes.job(offer.job.id)),
              onAccept: () => _accept(context, ref, offer),
              onDecline: () => _decline(context, ref, offer),
            );
          },
        );
      },
    );
  }

  Future<void> _accept(
    BuildContext context,
    WidgetRef ref,
    JobOffer offer,
  ) async {
    final result =
        await ref.read(jobActionsProvider.notifier).accept(offer.job.id);

    if (!context.mounted) return;

    result.fold(
      (job) {
        showSuccess(context, context.l10n.jobsAccepted);
        context.push(Routes.job(job.id));
      },
      // A ConflictFailure here means another worker won the race. The message
      // says exactly that, because "something went wrong" would leave the
      // worker wondering whether to try again.
      (failure) => showFailure(context, failure.message),
    );
  }

  Future<void> _decline(
    BuildContext context,
    WidgetRef ref,
    JobOffer offer,
  ) async {
    final confirmed = await confirmAction(
      context,
      title: context.l10n.jobsDeclineTitle,
      message: context.l10n.jobsDeclineBody,
      confirmLabel: context.l10n.jobsDecline,
    );

    if (!confirmed || !context.mounted) return;

    final result =
        await ref.read(jobActionsProvider.notifier).decline(offer.job.id);

    if (!context.mounted) return;
    result.fold(
      (_) => showSuccess(context, context.l10n.jobsDeclined),
      (failure) => showFailure(context, failure.message),
    );
  }
}

class _JobListTab extends ConsumerWidget {
  const _JobListTab({required this.filter});

  final JobListFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(jobListProvider(filter));

    return AsyncValueView<PagedResult<Job>>(
      value: jobs,
      onRetry: () => ref.invalidate(jobListProvider(filter)),
      loading: const ListSkeleton(),
      onData: (page) {
        if (page.items.isEmpty) {
          final l10n = context.l10n;
          final (title, message) = switch (filter) {
            JobListFilter.upcoming => (
                l10n.jobsEmptyUpcoming,
                l10n.jobsEmptyUpcomingBody,
              ),
            JobListFilter.active => (
                l10n.jobsEmptyActive,
                l10n.jobsEmptyActiveBody,
              ),
            JobListFilter.completed => (
                l10n.jobsEmptyCompleted,
                l10n.jobsEmptyCompletedBody,
              ),
            JobListFilter.cancelled => (
                l10n.jobsEmptyCancelled,
                l10n.jobsEmptyCancelledBody,
              ),
            JobListFilter.offers => (l10n.jobsEmptyOffers, l10n.jobsEmptyOffersBody),
          };

          return EmptyStateView(
            icon: Icons.inbox_outlined,
            title: title,
            message: message,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(jobListProvider(filter)),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: page.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, index) {
              final job = page.items[index];
              return JobListTile(
                job: job,
                onOpen: () => context.push(Routes.job(job.id)),
              );
            },
          ),
        );
      },
    );
  }
}
