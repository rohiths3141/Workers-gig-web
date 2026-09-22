import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/providers.dart';
import '../../core/errors/result.dart';

class AuthControllerState {
  final bool isLoading;
  final String? error;
  final String? verificationId;
  final int? resendToken;

  const AuthControllerState({
    this.isLoading = false,
    this.error,
    this.verificationId,
    this.resendToken,
  });

  AuthControllerState copyWith({
    bool? isLoading,
    String? error,
    String? verificationId,
    int? resendToken,
  }) {
    return AuthControllerState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
    );
  }
}

class AuthController extends StateNotifier<AuthControllerState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthControllerState());

  Future<bool> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);
    final repo = _ref.read(authRepositoryProvider);

    final res = await repo.requestOtp(phoneNumber);
    return switch (res) {
      Ok(:final value) => () {
          state = state.copyWith(
            isLoading: false,
            verificationId: value.verificationId,
            resendToken: value.resendToken,
          );
          return true;
        }(),
      Err(:final failure) => () {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        }(),
    };
  }

  Future<bool> verifyOtp(String verificationId, String smsCode) async {
    state = state.copyWith(isLoading: true, error: null);
    final repo = _ref.read(authRepositoryProvider);

    final res = await repo.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return switch (res) {
      Ok() => () {
          state = state.copyWith(isLoading: false);
          return true;
        }(),
      Err(:final failure) => () {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        }(),
    };
  }

  Future<bool> registerCustomer({
    required String fullName,
    required String email,
    required String firebaseUid,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final customerRepo = _ref.read(customerRepositoryProvider);

    final res = await customerRepo.createProfile(
      fullName: fullName,
      phone: phone,
      email: email.isEmpty ? null : email,
    );

    return switch (res) {
      Ok() => () {
          state = state.copyWith(isLoading: false);
          return true;
        }(),
      Err(:final failure) => () {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        }(),
    };
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  return AuthController(ref);
});
