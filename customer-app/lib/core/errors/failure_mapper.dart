import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException, StorageException;

import 'app_failure.dart';

/// Turns whatever an SDK or the database threw into an [AppFailure].
///
/// Identical mapping logic to the worker app. The trusted RPCs in migration
/// 0014 use the same prefix convention (FORBIDDEN:, CONFLICT:, INVALID:,
/// NOT_FOUND:) so this mapper is a shared contract with the backend.
abstract final class FailureMapper {
  static AppFailure from(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;

    if (error is PostgrestException) return _fromPostgrest(error);
    if (error is AuthException) {
      return AuthFailure(
        message: 'Your session has ended. Please sign in again.',
        debugDetail: error.message,
        cause: error,
        requiresReauthentication: true,
      );
    }
    if (error is StorageException) {
      return UploadFailure(
        message: 'That file could not be uploaded. Try again.',
        debugDetail: error.message,
        cause: error,
      );
    }
    if (error is FirebaseAuthException) return _fromFirebaseAuth(error);
    if (error is FirebaseException) {
      return UploadFailure(
        message: 'That file could not be uploaded. Try again.',
        debugDetail: '${error.plugin}/${error.code}: ${error.message}',
        cause: error,
        isResumable:
            error.code == 'retry-limit-exceeded' || error.code == 'canceled',
      );
    }

    if (error is SocketException || error is HttpException) {
      return NetworkFailure(debugDetail: error.toString(), cause: error);
    }
    if (error is TimeoutException) {
      return TimeoutFailure(debugDetail: error.toString(), cause: error);
    }
    if (error is FormatException) {
      return ServerFailure(
        debugDetail: 'Malformed response: ${error.message}',
        cause: error,
      );
    }

    return UnexpectedFailure(debugDetail: error.toString(), cause: error);
  }

  static AppFailure _fromPostgrest(PostgrestException error) {
    final raw = error.message;
    final message = _stripPrefix(raw);

    // A request that reached PostgREST as `anon` comes back with the HTTP
    // status in `code` and the Postgres 42501 buried in the message body, so
    // the switch below never sees it and it fell through to "something went
    // wrong at our end". Say what it is instead.
    if (error.code == '401' && raw.contains('42501')) {
      return PermissionFailure(
        message: 'Your sign-in is not fully set up yet. Try again in a moment.',
        debugDetail: raw,
        cause: error,
      );
    }

    switch (error.code) {
      case '42501':
        return PermissionFailure(
          message: message,
          debugDetail: raw,
          cause: error,
        );
      case 'P0002':
      case 'PGRST116':
        return NotFoundFailure(message: message, debugDetail: raw, cause: error);
      case '23505':
        return ConflictFailure(message: message, debugDetail: raw, cause: error);
      case '23514':
      case '23502':
      case '22P02':
        return ValidationFailure(
            message: message, debugDetail: raw, cause: error);
      case '23503':
        return NotFoundFailure(
          message: 'That is no longer available.',
          debugDetail: raw,
          cause: error,
        );
      case '42P01':
      case 'PGRST301':
        return PermissionFailure(
          message: 'You are not able to see that.',
          debugDetail: raw,
          cause: error,
        );
      case 'PGRST002':
      case '57014':
        return TimeoutFailure(debugDetail: raw, cause: error);
      case 'PGRST303':
        // "JWT issued at future" / "JWT expired": the phone's clock is out of
        // step with the server's, not a real authorisation problem. Signing
        // out here would lock a customer out over a wrong clock.
        return ClockSkewFailure(debugDetail: raw, cause: error);
    }

    return ServerFailure(debugDetail: '${error.code}: $raw', cause: error);
  }

  static AppFailure _fromFirebaseAuth(FirebaseAuthException error) {
    final message = switch (error.code) {
      'invalid-phone-number' => 'That phone number does not look right.',
      'invalid-verification-code' =>
        'That code is not correct. Check and try again.',
      'invalid-verification-id' ||
      'session-expired' =>
        'That code has expired. Ask for a new one.',
      'too-many-requests' =>
        'Too many attempts. Wait a few minutes before trying again.',
      'quota-exceeded' =>
        'We cannot send a code right now. Try again shortly.',
      'user-disabled' =>
        'This account has been disabled. Contact support.',
      'network-request-failed' =>
        'No internet connection. Check your network and try again.',
      'operation-not-allowed' =>
        'Phone sign-in is not enabled. Contact support.',
      'credential-already-in-use' ||
      'account-exists-with-different-credential' =>
        'That number is already registered to another account.',
      'requires-recent-login' => 'Please sign in again to continue.',
      _ => 'Sign-in failed. Please try again.',
    };

    if (error.code == 'network-request-failed') {
      return NetworkFailure(debugDetail: error.code, cause: error);
    }

    return AuthFailure(
      message: message,
      debugDetail: '${error.code}: ${error.message}',
      cause: error,
      requiresReauthentication:
          error.code == 'user-disabled' || error.code == 'requires-recent-login',
    );
  }

  static String _stripPrefix(String raw) {
    final match = RegExp(
      r'^(FORBIDDEN|NOT_FOUND|CONFLICT|INVALID|INVALID_TRANSITION):\s*',
    ).firstMatch(raw);

    var text = match == null ? raw : raw.substring(match.end);

    final context = text.indexOf('\nCONTEXT:');
    if (context > 0) text = text.substring(0, context);

    text = text.trim();
    if (text.isEmpty) return 'That did not work. Please try again.';

    final capitalised = text[0].toUpperCase() + text.substring(1);
    return RegExp(r'[.!?]$').hasMatch(capitalised)
        ? capitalised
        : '$capitalised.';
  }
}
