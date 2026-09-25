import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/gig.dart';
import '../../../domain/entities/worker.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../core/localization/app_locale.dart';

/// Everything the home screen shows, loaded together.
class HomeData {
  const HomeData({
    required this.worker,
    required this.eligibility,
    required this.earnings,
    required this.offers,
    required this.activeJob,
    required this.upcomingJobs,
    required this.activeGigCount,
    required this.unreadNotifications,
  });

  final Worker worker;
  final WorkerEligibility eligibility;
  final EarningsSummary earnings;
  final List<JobOffer> offers;
  final Job? activeJob;
  final List<Job> upcomingJobs;
  final int activeGigCount;
  final int unreadNotifications;
}

/// Loads the home screen.
///
/// The pieces are fetched concurrently, and a failure in any one of them fails
/// the screen. That is deliberate: a home screen showing a wallet total while
/// silently omitting a failed job list is worse than one that says it could not
/// load and offers a retry.
class HomeController extends AutoDisposeAsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() async {
    final worker = ref.watch(currentWorkerProvider);
    if (worker == null) {
      throw AuthFailure(message: AppStrings.current.authSignInToContinue);
    }

    final results = await Future.wait([
      ref.read(availabilityRepositoryProvider).getEligibility(),
      ref.read(workerRepositoryProvider).getEarningsSummary(),
      ref.read(jobRepositoryProvider).getOffers(),
      ref.read(jobRepositoryProvider).getActiveJob(),
      ref.read(jobRepositoryProvider)
          .getJobs(filter: JobListFilter.upcoming, limit: 5),
      ref.read(gigRepositoryProvider).getMyGigs(),
      ref.read(notificationRepositoryProvider).getUnreadCount(),
    ]);

    // Surface the first failure rather than partially rendering.
    for (final result in results) {
      final failure = result.failureOrNull;
      if (failure != null) throw failure;
    }

    final eligibility = results[0].valueOrNull! as WorkerEligibility;
    final earnings = results[1].valueOrNull! as EarningsSummary;
    final offers = results[2].valueOrNull! as List<JobOffer>;
    final activeJob = results[3].valueOrNull as Job?;
    final upcoming = results[4].valueOrNull! as PagedResult<Job>;
    final gigs = results[5].valueOrNull! as List<Gig>;
    final unread = results[6].valueOrNull! as int;

    return HomeData(
      worker: worker,
      eligibility: eligibility,
      earnings: earnings,
      offers: offers,
      activeJob: activeJob,
      upcomingJobs: upcoming.items,
      activeGigCount: gigs.where((g) => g.status.isLive).length,
      unreadNotifications: unread,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(build);
  }
}

final homeControllerProvider =
    AutoDisposeAsyncNotifierProvider<HomeController, HomeData>(
        HomeController.new);

/// Turning availability on and off.
///
/// Kept out of [HomeController] so toggling does not rebuild the whole screen,
/// and so a refusal can be handled without discarding the loaded home data.
class AvailabilityController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the failure when the server refuses, so the caller can show the
  /// eligibility reasons. Going offline is never refused.
  Future<Result<WorkerEligibility>> toggle(WorkerAvailability target) async {
    state = const AsyncLoading();

    final result =
        await ref.read(availabilityRepositoryProvider).setAvailability(target);

    state = const AsyncData(null);

    // Re-read from the server either way: the worker's row is the truth, and an
    // optimistic local flip would be exactly the lie this app exists to avoid.
    await ref.read(sessionProvider.notifier).refresh();
    ref.invalidate(homeControllerProvider);

    return result;
  }
}

final availabilityControllerProvider =
    AutoDisposeAsyncNotifierProvider<AvailabilityController, void>(
        AvailabilityController.new);
