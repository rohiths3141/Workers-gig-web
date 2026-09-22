import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/errors/result.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/verification.dart';
import '../../home/presentation/home_controller.dart';

final verificationsProvider =
    StreamProvider.autoDispose<List<VerificationCase>>((ref) {
  return ref.watch(verificationRepositoryProvider).watchVerifications();
});

final insurancePoliciesProvider =
    FutureProvider.autoDispose<List<InsurancePolicy>>((ref) async {
  final result =
      await ref.watch(verificationRepositoryProvider).getInsurancePolicies();
  // An empty list is a real answer: no policy on file. It renders as "no
  // cover", never as assumed protection.
  return result.fold((items) => items, (failure) => throw failure);
});

final claimsProvider = FutureProvider.autoDispose<List<Claim>>((ref) async {
  final result = await ref.watch(verificationRepositoryProvider).getClaims();
  return result.fold((items) => items, (failure) => throw failure);
});

/// Submitting documents for review.
///
/// Every path here ends at PENDING. There is no method that approves anything,
/// because approval belongs to an administrator and the server refuses a
/// self-review outright.
class VerificationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<VerificationCase>> submit({
    required VerificationType type,
    Map<String, dynamic> details = const {},
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(verificationRepositoryProvider)
        .submit(type: type, details: details);
    state = const AsyncData(null);
    _refresh();
    return result;
  }

  Future<Result<VerificationCase>> submitQualification(
    Qualification qualification,
  ) async {
    state = const AsyncLoading();
    final result = await ref
        .read(verificationRepositoryProvider)
        .submitQualification(qualification);
    state = const AsyncData(null);
    _refresh();
    return result;
  }

  Future<Result<VerificationCase>> submitBankAccount({
    required String accountHolderName,
    required String accountNumber,
    required String ifsc,
    String? bankName,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(verificationRepositoryProvider).submitBankAccount(
          accountHolderName: accountHolderName,
          accountNumber: accountNumber,
          ifsc: ifsc,
          bankName: bankName,
        );
    state = const AsyncData(null);
    _refresh();
    return result;
  }

  /// Starts real DigiLocker identity verification. Returns the consent URL to
  /// open, or `null` if the worker is already verified.
  Future<Result<String?>> startDigilockerKyc() async {
    state = const AsyncLoading();
    final result =
        await ref.read(verificationRepositoryProvider).startDigilockerKyc();
    state = const AsyncData(null);
    _refresh();
    return result;
  }

  /// Polls the outcome of a DigiLocker consent the worker just completed.
  /// The decision itself was made server-side, from what MessageCentral's
  /// DigiLocker journey actually returned.
  Future<Result<DigilockerStatus>> checkDigilockerStatus() async {
    final result =
        await ref.read(verificationRepositoryProvider).checkDigilockerStatus();
    if (result case Ok(value: final status)
        when status.outcome != DigilockerOutcome.pending) {
      _refresh();
    }
    return result;
  }

  void _refresh() {
    // Submitting moves a new worker into the review queue, which changes both
    // their account status and their eligibility.
    ref.invalidate(verificationsProvider);
    ref.invalidate(homeControllerProvider);
    ref.read(sessionProvider.notifier).refresh();
  }
}

final verificationControllerProvider =
    AutoDisposeAsyncNotifierProvider<VerificationController, void>(
        VerificationController.new);
