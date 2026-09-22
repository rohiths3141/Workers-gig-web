import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../core/errors/app_failure.dart';
import '../../core/errors/failure_mapper.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/repositories/repositories.dart';

/// Firebase Authentication, phone OTP only.
///
/// There is no password path anywhere on this platform, which removes the whole
/// class of attack the previous application was vulnerable to — it accepted any
/// password and fabricated a verified profile. Here the only credential is a
/// code sent to a number the worker controls, verified by Firebase, and the app
/// holds no way to produce a signed-in state on its own.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  static const _log = AppLogger('Auth');

  final fb.FirebaseAuth _auth;

  @override
  Stream<AuthState> authStateChanges() {
    // idTokenChanges rather than authStateChanges: it also fires when a refresh
    // fails or the account is disabled server-side, which is exactly when the
    // app must stop trusting the session.
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
      return const Err(ValidationFailure(
        message: 'Enter a 10-digit mobile number.',
        fieldErrors: {'phone': 'Enter a 10-digit mobile number'},
      ));
    }

    final completer = Completer<Result<AuthAwaitingOtp>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: normalised,
        timeout: const Duration(seconds: 60),
        // Android can auto-read the SMS. When it does, the code below still
        // routes through verifyOtp so there is exactly one sign-in path.
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
      onTimeout: () => const Err(TimeoutFailure(
        message: 'We could not send the code. Check your network and try again.',
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
      return const Err(ValidationFailure(message: 'Enter the code you received.'));
    }

    try {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        // Defensive: Firebase should never return a null user on success.
        return const Err(AuthFailure(
          message: 'Sign-in did not complete. Please try again.',
        ));
      }

      _log.info('Worker signed in');
      return Ok(AuthSignedIn(
        firebaseUid: user.uid,
        phoneNumber: user.phoneNumber,
      ));
    } catch (error, stack) {
      // Not logged with the code or the number attached.
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
      return const Err(AuthFailure(
        message: 'Please sign in to continue.',
        requiresReauthentication: true,
      ));
    }

    try {
      final token = await user.getIdToken(forceRefresh);
      if (token == null || token.isEmpty) {
        return const Err(AuthFailure(
          message: 'Your session has ended. Please sign in again.',
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
      _log.info('Worker signed out');
      return const Ok(null);
    } catch (error, stack) {
      return Err(FailureMapper.from(error, stack));
    }
  }

  @override
  Future<Result<void>> requestAccountDeletion({required String reason}) async {
    // Deliberately not implemented as a local wipe. Deleting the Firebase user
    // here would orphan the platform-side records, leave bookings and ledger
    // entries pointing at a missing identity, and give the worker no way to
    // check that anything happened. The real workflow is a server-side request
    // that operations process, and it does not exist yet — so this refuses
    // rather than pretending.
    return const Err(ValidationFailure(
      message:
          'Account deletion is handled by our support team. Raise a request and '
          'we will confirm once it is done.',
    ));
  }

  /// Accepts "9876543210", "09876543210", "+91 98765 43210" and returns E.164.
  ///
  /// Defaults to +91 when no country code is given, because that is where the
  /// platform operates. An explicit country code is always respected.
  ///
  /// Returns null for anything that is not a usable number, so a typo is
  /// refused here rather than costing the worker a wasted OTP.
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
