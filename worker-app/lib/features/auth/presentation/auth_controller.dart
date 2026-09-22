import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/providers.dart';
import '../../../app/providers/session_controller.dart';
import '../../../core/errors/result.dart';
import '../../../domain/repositories/repositories.dart';

/// Drives phone sign-in.
///
/// Holds no credential of its own. The only thing it carries between screens is
/// the Firebase verification id, which is useless without the code the worker
/// receives on their own device.
class AuthController extends AutoDisposeAsyncNotifier<AuthAwaitingOtp?> {
  @override
  Future<AuthAwaitingOtp?> build() async => null;

  Future<Result<AuthAwaitingOtp>> requestOtp(String phoneNumber) async {
    state = const AsyncLoading();
    final result =
        await ref.read(authRepositoryProvider).requestOtp(phoneNumber);

    state = result.fold(
      AsyncData.new,
      (failure) => AsyncError(failure, StackTrace.current),
    );
    return result;
  }

  Future<Result<void>> verifyOtp({
    required String verificationId,
    required String smsCode,
    required String phoneNumber,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(authRepositoryProvider).verifyOtp(
          verificationId: verificationId,
          smsCode: smsCode,
        );

    return result.fold(
      (_) async {
        // The session re-resolves from Firebase and the server; nothing local
        // decides where the worker lands next.
        await ref.read(sessionProvider.notifier).refresh();
        state = const AsyncData(null);
        return const Ok(null);
      },
      (failure) {
        // Keep the pending verification so the worker can retype the code
        // rather than being sent back to request a new one.
        state = AsyncData(AuthAwaitingOtp(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        ));
        return Err(failure);
      },
    );
  }

  Future<Result<AuthAwaitingOtp>> resend(String phoneNumber) async {
    return requestOtp(phoneNumber);
  }
}

final authControllerProvider =
    AutoDisposeAsyncNotifierProvider<AuthController, AuthAwaitingOtp?>(
        AuthController.new);

/// Registration, for an authenticated worker with no profile yet.
class RegistrationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<Result<void>> register({
    required String fullName,
    required String phone,
    String? email,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(workerRepositoryProvider).createProfile(
          fullName: fullName,
          phone: phone,
          email: email,
        );

    return result.fold(
      (_) async {
        await ref.read(sessionProvider.notifier).refresh();
        state = const AsyncData(null);
        return const Ok(null);
      },
      (failure) {
        state = AsyncError(failure, StackTrace.current);
        return Err(failure);
      },
    );
  }
}

final registrationControllerProvider =
    AutoDisposeAsyncNotifierProvider<RegistrationController, void>(
        RegistrationController.new);
