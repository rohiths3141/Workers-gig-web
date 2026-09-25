import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../core/errors/failure_mapper.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/repositories/repositories.dart';
import '../../core/localization/app_locale.dart';

/// Firebase Authentication — phone OTP only.
///
/// Identical implementation to the worker app. The customer app uses the same
/// Firebase project (workers-gig) and the same auth method. The only
/// difference is that after sign-in the server resolves a customer row rather
/// than a worker row.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  static const _log = AppLogger('Auth');

  final fb.FirebaseAuth _auth;

  @override
  Stream<AuthState> authStateChanges() {
    return _auth.idTokenChanges().map(_toState);
  }

  @override
  AuthState get currentState => _toState(_auth.currentUser);

  AuthState _toState(fb.User? user) {
    if (user == null) return const AuthSignedOut();
    return AuthSignedIn(
      firebaseUid: user.uid,
      phoneNumber: user.phoneNumber,
    );
  }

  @override
  Future<Result<AuthAwaitingOtp>> requestOtp(String phoneNumber) async {
    final normalised = _normalisePhone(phoneNumber);
    if (normalised == null) {
      return Err(ValidationFailure(
        message: AppStrings.current.authPhoneTenDigits,
        fieldErrors: {'phone': AppStrings.current.authPhoneTenDigits},
      ));
    }

    final completer = Completer<Result<AuthAwaitingOtp>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: normalised,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (_) {},
        verificationFailed: (error) {
          if (!completer.isCompleted) {
            completer.complete(Err(FailureMapper.from(error)));
          }
        },
        codeSent: (verificationId, resendToken) {
          if (!completer.isCompleted) {
            completer.complete(Ok(AuthAwaitingOtp(
              verificationId: verificationId,
              phoneNumber: normalised,
              resendToken: resendToken,
            )));
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (!completer.isCompleted) {
            completer.complete(Ok(AuthAwaitingOtp(
              verificationId: verificationId,
              phoneNumber: normalised,
            )));
          }
        },
      );
    } catch (error, stack) {
      _log.error('OTP request failed', error: error, stackTrace: stack);
      if (!completer.isCompleted) {
        completer.complete(Err(FailureMapper.from(error, stack)));
      }
    }

    return completer.future.timeout(
      const Duration(seconds: 90),
      onTimeout: () => Err(TimeoutFailure(
        message: AppStrings.current.authCodeSendTimeout,
      )),
    );
  }

  @override
  Future<Result<AuthSignedIn>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final code = smsCode.trim();
    if (code.length < 4 || int.tryParse(code) == null) {
      return Err(
          ValidationFailure(message: AppStrings.current.authEnterReceivedCode));
    }

    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        return Err(AuthFailure(
          message: AppStrings.current.authSignInIncomplete,
        ));
      }

      _log.info('Customer signed in');
      return Ok(AuthSignedIn(
        firebaseUid: user.uid,
        phoneNumber: user.phoneNumber,
      ));
    } catch (error, stack) {
      _log.warning('OTP verification rejected');
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<AuthAwaitingOtp>> resendOtp({
    required String phoneNumber,
    int? resendToken,
  }) =>
      requestOtp(phoneNumber);

  @override
  Future<Result<String>> idToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) {
      return Err(AuthFailure(
        message: AppStrings.current.authSignInToContinue,
        requiresReauthentication: true,
      ));
    }

    try {
      final token = await user.getIdToken(forceRefresh);
      if (token == null || token.isEmpty) {
        return Err(AuthFailure(
          message: AppStrings.current.errorSessionEnded,
          requiresReauthentication: true,
        ));
      }
      return Ok(token);
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      _log.info('Customer signed out');
      return const Ok(null);
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @visibleForTesting
  static String? normalisePhone(String input) => _normalisePhone(input);

  static String? _normalisePhone(String input) {
    var digits = input.replaceAll(RegExp(r'[^\d+]'), '');

    if (digits.startsWith('+')) {
      final rest = digits.substring(1);
      if (rest.length < 10 || rest.length > 15) return null;
      return '+$rest';
    }

    if (digits.startsWith('0')) digits = digits.substring(1);
    if (digits.startsWith('91') && digits.length == 12) return '+$digits';
    if (digits.length == 10 && RegExp(r'^[6-9]').hasMatch(digits)) {
      return '+91$digits';
    }
    return null;
  }
}
