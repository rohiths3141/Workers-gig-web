import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/errors/result.dart';
import '../../../core/money/money.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/repositories/repositories.dart';
import '../../home/presentation/home_controller.dart';

/// Open offers, refreshed by Realtime.
final offersProvider = StreamProvider.autoDispose<List<JobOffer>>((ref) {
  return ref.watch(jobRepositoryProvider).watchOffers();
});

/// One page of jobs for a tab.
final jobListProvider = FutureProvider.autoDispose
    .family<PagedResult<Job>, JobListFilter>((ref, filter) async {
  final result =
      await ref.watch(jobRepositoryProvider).getJobs(filter: filter);
  // Throwing surfaces the failure through AsyncValue, where AsyncValueView
  // renders it with a retry. There is no empty-list fallback.
  return result.fold((page) => page, (failure) => throw failure);
});

/// One job, kept live so a customer cancelling is seen immediately.
final jobProvider =
    StreamProvider.autoDispose.family<Job, String>((ref, bookingId) {
  return ref.watch(jobRepositoryProvider).watchJob(bookingId);
});

final jobTimelineProvider = FutureProvider.autoDispose
    .family<List<JobEvent>, String>((ref, bookingId) async {
  final result =
      await ref.watch(jobRepositoryProvider).getJobTimeline(bookingId);
  return result.fold((events) => events, (failure) => throw failure);
});

final activeJobProvider = FutureProvider.autoDispose<Job?>((ref) async {
  final result = await ref.watch(jobRepositoryProvider).getActiveJob();
  return result.fold((job) => job, (failure) => throw failure);
});

final completionReadinessProvider = FutureProvider.autoDispose
    .family<CompletionReadiness, String>((ref, bookingId) async {
  final result = await ref
      .watch(jobRepositoryProvider)
      .getCompletionReadiness(bookingId);
  return result.fold((readiness) => readiness, (failure) => throw failure);
});

final materialsProvider = StreamProvider.autoDispose
    .family<List<MaterialRequest>, String>((ref, bookingId) {
  return ref.watch(materialRepositoryProvider).watchMaterials(bookingId);
});

/// Broadcasts this worker's live GPS position against [bookingId] while the
/// job is in a state the customer can watch (TRAVELING, ARRIVED, IN_PROGRESS —
/// matching worker_locations' RLS read policy for customers). Watching this
/// provider from the active-job screen is what starts and stops tracking; it
/// carries no state of its own.
const _trackableStatuses = {
  BookingStatus.traveling,
  BookingStatus.arrived,
  BookingStatus.inProgress,
};

final locationBroadcastProvider =
    Provider.autoDispose.family<void, String>((ref, bookingId) {
  final trackable = ref.watch(jobProvider(bookingId).select(
    (async) => _trackableStatuses.contains(async.valueOrNull?.status),
  ));

  if (!trackable) return;

  final repository = ref.watch(jobRepositoryProvider);

  StreamSubscription<Position>? subscription;

  // Whether the provider was torn down before start() got as far as opening
  // the stream. Checking a flag rather than relying on `subscription` alone is
  // the whole point: start() awaits a permission prompt the worker may take
  // seconds to answer, and onDispose ran against a null subscription if they
  // left the screen first. The stream then opened with nothing left to cancel
  // it, so the phone went on reporting the worker's position — and writing it
  // to worker_locations — long after the job screen was gone.
  var disposed = false;

  Future<void> start() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    if (disposed) return;

    final opened = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        // Roughly once every 15m of movement — enough for a customer's map to
        // feel live without flooding worker_locations on a stationary phone.
        distanceFilter: 15,
      ),
    ).listen((position) {
      unawaited(repository.updateLocation(
        bookingId: bookingId,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        heading: position.heading,
        speed: position.speed,
      ));
    });

    // Disposal can also land between the check above and here.
    if (disposed) {
      unawaited(opened.cancel());
      return;
    }
    subscription = opened;
  }

  unawaited(start());
  ref.onDispose(() {
    disposed = true;
    unawaited(subscription?.cancel());
  });
});

/// Actions on a job.
///
/// Every method here is a request to the server. None of them updates local
/// state optimistically, because each one is a transition the server may refuse
/// — a stale offer, a lost race, an unverified arrival — and showing the worker
/// a state the database does not hold is the specific failure mode this rebuild
/// exists to remove.
class JobActionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<Job>> accept(String bookingId) async {
    state = const AsyncLoading();
    final result = await ref.read(jobRepositoryProvider).acceptOffer(bookingId);
    state = const AsyncData(null);
    _invalidate();
    return result;
  }

  Future<Result<void>> decline(String bookingId, {String? reason}) async {
    state = const AsyncLoading();
    final result =
        await ref.read(jobRepositoryProvider).declineOffer(bookingId, reason: reason);
    state = const AsyncData(null);
    _invalidate();
    return result;
  }

  Future<Result<Job>> advance(
    String bookingId,
    BookingStatus toStatus, {
    String? reason,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(jobRepositoryProvider)
        .advance(bookingId, toStatus, reason: reason);
    state = const AsyncData(null);
    _invalidate();
    return result;
  }

  Future<Result<ArrivalVerification>> verifyArrival(
    String bookingId,
    String code,
  ) async {
    state = const AsyncLoading();
    final result =
        await ref.read(jobRepositoryProvider).verifyArrival(bookingId, code);
    state = const AsyncData(null);

    // Only refresh when the code was actually accepted. A wrong code changes
    // nothing on the server, so there is nothing to re-read.
    if (result.valueOrNull?.isVerified ?? false) _invalidate();

    return result;
  }

  Future<Result<void>> rateCustomer({
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    final result = await ref.read(jobRepositoryProvider).rateCustomer(
          bookingId: bookingId,
          rating: rating,
          comment: comment,
        );
    _invalidate();
    return result;
  }

  void _invalidate() {
    ref.invalidate(activeJobProvider);
    ref.invalidate(homeControllerProvider);
    ref.invalidate(sessionProvider);
  }
}

final jobActionsProvider =
    AutoDisposeAsyncNotifierProvider<JobActionsController, void>(
        JobActionsController.new);

/// Requesting materials and recording what they cost.
class MaterialActionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<MaterialRequest>> request({
    required String bookingId,
    required String name,
    required double quantity,
    required String unit,
    required int estimatedCostMinor,
    String? description,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(materialRepositoryProvider).requestMaterial(
          bookingId: bookingId,
          name: name,
          quantity: quantity,
          unit: unit,
          estimatedCost: Money(estimatedCostMinor),
          description: description,
        );
    state = const AsyncData(null);
    ref.invalidate(completionReadinessProvider(bookingId));
    return result;
  }

  Future<Result<MaterialRequest>> recordCost({
    required String materialId,
    required int actualCostMinor,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(materialRepositoryProvider).recordActualCost(
          materialId: materialId,
          actualCost: Money(actualCostMinor),
        );
    state = const AsyncData(null);
    return result;
  }
}

final materialActionsProvider =
    AutoDisposeAsyncNotifierProvider<MaterialActionsController, void>(
        MaterialActionsController.new);
