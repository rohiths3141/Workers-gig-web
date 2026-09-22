import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/gig.dart';
import '../../../domain/entities/support.dart';
import '../../../domain/entities/worker.dart';
import '../../home/presentation/home_controller.dart';

final skillsProvider = FutureProvider.autoDispose<List<WorkerSkill>>((ref) async {
  final result = await ref.watch(workerRepositoryProvider).getSkills();
  return result.fold((skills) => skills, (failure) => throw failure);
});

final ratingSummaryProvider =
    FutureProvider.autoDispose<RatingSummary>((ref) async {
  final result = await ref.watch(workerRepositoryProvider).getRatingSummary();
  return result.fold((summary) => summary, (failure) => throw failure);
});

final ratingsProvider = FutureProvider.autoDispose<List<Rating>>((ref) async {
  final result = await ref.watch(workerRepositoryProvider).getRatings();
  return result.fold((ratings) => ratings, (failure) => throw failure);
});

final allServicesProvider =
    FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final result = await ref.watch(catalogueRepositoryProvider).getServices();
  return result.fold((services) => services, (failure) => throw failure);
});

/// Editing the profile.
///
/// Only fields the worker is permitted to change are here. Status, the
/// verification flags, rating and wallet have no method, because the database
/// grants the client no way to write them and a UI affordance for something
/// impossible is worse than none.
class ProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<Worker>> updateDetails({
    String? bio,
    int? experienceYears,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
    String? gender,
  }) =>
      _run(() => ref.read(workerRepositoryProvider).updateProfile(
            bio: bio,
            experienceYears: experienceYears,
            addressLine: addressLine,
            city: city,
            state: state,
            pincode: pincode,
            gender: gender,
          ));

  Future<Result<Worker>> updateServiceArea({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? city,
    String? pincode,
  }) =>
      _run(() => ref.read(workerRepositoryProvider).updateServiceArea(
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            city: city,
            pincode: pincode,
          ));

  Future<Result<Worker>> setPrimaryTrade(String serviceId) =>
      _run(() => ref.read(workerRepositoryProvider).setPrimaryService(serviceId));

  Future<Result<Worker>> updatePhoto(File image) =>
      _run(() => ref.read(workerRepositoryProvider).updateProfilePhoto(image));

  Future<Result<WorkerSkill>> addSkill(String serviceId) async {
    state = const AsyncLoading();
    final result =
        await ref.read(workerRepositoryProvider).requestSkill(serviceId);
    state = const AsyncData(null);
    ref.invalidate(skillsProvider);
    return result;
  }

  Future<Result<Worker>> _run(Future<Result<Worker>> Function() action) async {
    state = const AsyncLoading();
    final result = await action();
    state = const AsyncData(null);

    // Re-read rather than patch in place: the server may have normalised or
    // rejected part of what was sent, and the worker should see what it holds.
    await ref.read(sessionProvider.notifier).refresh();
    ref.invalidate(homeControllerProvider);

    return result;
  }
}

final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>(
        ProfileController.new);
