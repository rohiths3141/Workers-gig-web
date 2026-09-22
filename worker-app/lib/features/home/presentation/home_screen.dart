import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/errors/app_failure.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'home_controller.dart';
import 'widgets/availability_card.dart';
import 'widgets/home_cards.dart';

/// The worker's command centre.
///
/// Ordered by what a worker actually needs when they open the app mid-shift:
///
///   1. Am I available?          — the biggest control on the screen
///   2. What am I doing now?     — the active job
///   3. Is there new work?       — offers, with a countdown
///   4. What is coming up?       — today's schedule
///   5. What have I earned?      — today, week, month
///   6. Everything else
///
/// Nothing here renders unless the server supplied it. A failure shows an error
/// and a retry; it does not fall back to a plausible-looking home screen.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AsyncValueView<HomeData>(
          value: home,
          onRetry: () => ref.invalidate(homeControllerProvider),
          loading: const ListSkeleton(itemCount: 4, itemHeight: 120),
          onData: (data) => RefreshIndicator(
            onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.xxxl,
              ),
              children: [
                _Greeting(data: data),
                const SizedBox(height: AppSpacing.lg),

                AvailabilityCard(
                  availability: data.worker.availability,
                  eligibility: data.eligibility,
                  onBlocked: (failure) => _showEligibilitySheet(context, failure),
                ),
                const SizedBox(height: AppSpacing.lg),

                StatusSummaryCard(worker: data.worker),
                const SizedBox(height: AppSpacing.xl),

                if (data.activeJob != null) ...[
                  const SectionHeader(title: 'Right now'),
                  ActiveJobCard(
                    job: data.activeJob!,
                    onOpen: () => context.push(Routes.activeJob),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                if (data.offers.isNotEmpty) ...[
                  SectionHeader(
                    title: 'New work',
                    subtitle:
                        '${data.offers.length} job${data.offers.length == 1 ? '' : 's'} waiting for your answer',
                    actionLabel: 'See all',
                    action: () => context.go(Routes.jobs),
                  ),
                  for (final offer in data.offers.take(2))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppCard(
                        onTap: () => context.push(Routes.job(offer.job.id)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(offer.job.serviceName,
                                      style: AppTypography.titleMedium
                                          .copyWith(color: context.ink)),
                                  const SizedBox(height: AppSpacing.xxs),
                                  Text(
                                    '${offer.distanceKm.toStringAsFixed(1)} km · ${offer.job.approximateArea}',
                                    style: AppTypography.bodySmall
                                        .copyWith(color: context.inkSecondary),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.md),
                ],

                if (data.upcomingJobs.isNotEmpty) ...[
                  const SectionHeader(title: 'Coming up'),
                  for (final job in data.upcomingJobs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: UpcomingJobTile(
                        job: job,
                        onOpen: () => context.push(Routes.job(job.id)),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                const SectionHeader(title: 'Earnings'),
                EarningsCard(
                  earnings: data.earnings,
                  onOpenWallet: () => context.go(Routes.wallet),
                ),
                const SizedBox(height: AppSpacing.xl),

                AppCard(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      QuickAction(
                        icon: Icons.storefront_outlined,
                        label: 'My services',
                        onTap: () => context.push(Routes.gigs),
                        badgeCount: 0,
                      ),
                      QuickAction(
                        icon: Icons.verified_outlined,
                        label: 'Verification',
                        onTap: () => context.push(Routes.verification),
                      ),
                      QuickAction(
                        icon: Icons.support_agent_rounded,
                        label: 'Support',
                        onTap: () => context.push(Routes.support),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Model B: Customer-posted requests & My Offers
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      QuickAction(
                        icon: Icons.assignment_outlined,
                        label: 'Requests',
                        onTap: () => context.push(Routes.customerRequests),
                      ),
                      QuickAction(
                        icon: Icons.local_offer_outlined,
                        label: 'My offers',
                        onTap: () => context.push(Routes.myOffers),
                      ),
                    ],
                  ),
                ),

                // Shown only when the worker has published nothing. Without a
                // live service they cannot be matched at all, and that is worth
                // saying once, in place, rather than leaving them to wonder why
                // no work arrives.
                if (data.activeGigCount == 0) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    onTap: () => context.push(Routes.gigs),
                    child: Row(
                      children: [
                        const Icon(Icons.add_business_outlined, size: 24),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add a service',
                                  style: AppTypography.titleMedium
                                      .copyWith(color: context.ink)),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                'Customers can only book you for services you have published.',
                                style: AppTypography.bodySmall
                                    .copyWith(color: context.inkSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A refusal to go available, rendered as a to-do list with destinations.
  void _showEligibilitySheet(BuildContext context, PermissionFailure failure) {
    final reasons = failure.reasons;

    // Scroll-controlled on the root navigator: the list of reasons can be
    // taller than the default half-height sheet, which overflowed, and the
    // sheet belongs above the bottom navigation bar rather than behind it.
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Not quite ready',
                  style: AppTypography.headlineMedium
                      .copyWith(color: sheetContext.ink)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Finish these steps and you can start receiving jobs.',
                style: AppTypography.bodyLarge
                    .copyWith(color: sheetContext.inkSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final reason in reasons)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.radio_button_unchecked),
                  title: Text(reason.message),
                  trailing: reason.action == null
                      ? null
                      : const Icon(Icons.chevron_right_rounded),
                  onTap: reason.action == null
                      ? null
                      : () {
                          Navigator.of(sheetContext).pop();
                          context.push('/${reason.action}');
                        },
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      children: [
        WorkerAvatar(
          name: data.worker.fullName,
          photoUrl: data.worker.profilePhotoUrl,
          size: 48,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting,
                  style: AppTypography.bodyMedium
                      .copyWith(color: context.inkSecondary)),
              Text(data.worker.shortName,
                  style:
                      AppTypography.headlineMedium.copyWith(color: context.ink)),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.push(Routes.notifications),
          icon: Badge(
            isLabelVisible: data.unreadNotifications > 0,
            label: Text('${data.unreadNotifications}'),
            child: const Icon(Icons.notifications_none_rounded, size: 28),
          ),
          tooltip: 'Notifications',
        ),
      ],
    );
  }
}
