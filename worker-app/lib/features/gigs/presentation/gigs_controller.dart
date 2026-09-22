import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/gig.dart';
import '../../home/presentation/home_controller.dart';

/// Every gig this worker has, in every state.
///
/// There is no cap and no "already has one" branch anywhere in this file. A
/// worker holds as many gigs as their approved trades allow; where the business
/// wants a ceiling it is a platform setting the server enforces, never a
/// hardcoded client rule.
final myGigsProvider = StreamProvider.autoDispose<List<Gig>>((ref) {
  return ref.watch(gigRepositoryProvider).watchMyGigs();
});

/// The trades this worker may publish under. Derived from approved skills, so
/// the picker cannot offer something the server will refuse.
final gigCategoriesProvider =
    FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final result =
      await ref.watch(gigRepositoryProvider).getAvailableCategories();
  return result.fold((categories) => categories, (failure) => throw failure);
});

final gigProvider =
    FutureProvider.autoDispose.family<Gig, String>((ref, gigId) async {
  final result = await ref.watch(gigRepositoryProvider).getGig(gigId);
  return result.fold((gig) => gig, (failure) => throw failure);
});

/// Creating, editing and pausing gigs.
class GigActionsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<Gig>> saveDraft(GigDraft draft) => _run(
        () => ref.read(gigRepositoryProvider).saveDraft(draft),
      );

  Future<Result<Gig>> publish(GigDraft draft) => _run(
        () => ref.read(gigRepositoryProvider).publish(draft),
      );

  Future<Result<Gig>> pause(String gigId) => _run(
        () => ref.read(gigRepositoryProvider).pause(gigId),
      );

  Future<Result<Gig>> resume(String gigId) => _run(
        () => ref.read(gigRepositoryProvider).resume(gigId),
      );

  Future<Result<Gig>> archive(String gigId) => _run(
        () => ref.read(gigRepositoryProvider).archive(gigId),
      );

  Future<Result<Gig>> _run(Future<Result<Gig>> Function() action) async {
    state = const AsyncLoading();
    final result = await action();
    state = const AsyncData(null);

    // Gig changes move the eligibility needle: a worker with no live gig cannot
    // be matched, so the home screen's availability card has to re-read.
    ref.invalidate(myGigsProvider);
    ref.invalidate(homeControllerProvider);

    return result;
  }
}

final gigActionsProvider =
    AutoDisposeAsyncNotifierProvider<GigActionsController, void>(
        GigActionsController.new);
