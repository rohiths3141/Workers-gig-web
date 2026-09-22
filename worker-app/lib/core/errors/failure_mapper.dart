import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, FunctionException, PostgrestException, StorageException;

import 'app_failure.dart';

/// Turns whatever an SDK or the database threw into an [AppFailure].
///
/// This is the only place that knows about Postgres error codes and Firebase
/// error strings. Everything above it deals in [AppFailure] and never sees a
/// SQLSTATE, a stack trace, or a provider's internal wording.
///
/// The trusted operations in migration 0013 raise with a deliberate prefix and
/// SQLSTATE pair, e.g.
///
///     raise exception 'CONFLICT: this job is no longer available'
///       using errcode = '23505';
///
/// so the mapping below is a contract with the database, not guesswork. The
/// text after the prefix is written for the worker and is passed through
/// unchanged — the server is a better place to phrase "the customer has not
/// approved this material yet" than the client is.
abstract final class FailureMapper {
  static AppFailure from(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;

    if (error is PostgrestException) return _fromPostgrest(error);
    if (error is FunctionException) return _fromEdgeFunction(error);
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
        isResumable: error.code == 'retry-limit-exceeded' || error.code == 'canceled',
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

  /// An Edge Function refusal.
  ///
  /// The functions already answer with a worker-readable `{"error": "..."}`
  /// body — `kyc-digilocker` says "DigiLocker verification is unavailable
  /// right now" — but without this the whole thing fell through to
  /// `UnexpectedFailure` and the screen showed "Something went wrong. Please
  /// try again." The server's wording is better than ours; use it.
  static AppFailure _fromEdgeFunction(FunctionException error) {
    final details = error.details;
    String? message;
    if (details is Map) {
      final body = details['error'] ?? details['message'];
      if (body is String && body.trim().isNotEmpty) message = body.trim();
    } else if (details is String && details.trim().isNotEmpty) {
      message = details.trim();
    }

    final detail = 'edge function ${error.status}: $details';

    // 401/403 is this caller's token, not the function being unavailable.
    if (error.status == 401 || error.status == 403) {
      return AuthFailure(
        message: message ?? 'Please sign in again to continue.',
        debugDetail: detail,
        cause: error,
        requiresReauthentication: error.status == 401,
      );
    }

    return ServerFailure(
      message: message ?? 'That service is unavailable right now. Try again shortly.',
      debugDetail: detail,
      cause: error,
    );
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
      // FORBIDDEN — the caller is not allowed. May carry eligibility reasons in
      // the exception DETAIL, which worker_set_availability() populates.
      case '42501':
        return PermissionFailure(
          message: message,
          debugDetail: raw,
          cause: error,
          reasons: _eligibilityReasons(error.details),
        );

      // NOT_FOUND — gone, or never visible to this caller. The two are
      // deliberately indistinguishable.
      case 'P0002':
      case 'PGRST116':
        return NotFoundFailure(message: message, debugDetail: raw, cause: error);

      // CONFLICT — someone else won the race, or this already happened.
      case '23505':
        return ConflictFailure(message: message, debugDetail: raw, cause: error);

      // INVALID — a check constraint or a deliberate validation refusal.
      case '23514':
      case '23502':
      case '22P02':
        if (raw.contains('INSUFFICIENT_FUNDS')) {
          return InsufficientFundsFailure(
            message: message,
            availableMinor: _availableMinor(raw),
            debugDetail: raw,
            cause: error,
          );
        }
        return ValidationFailure(message: message, debugDetail: raw, cause: error);

      // Referenced row missing — a stale id on the client.
      case '23503':
        return NotFoundFailure(
          message: 'That is no longer available.',
          debugDetail: raw,
          cause: error,
        );

      // RLS refused the row outright.
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

      // "JWT issued at future" / "JWT expired": the phone's clock is out of
      // step with the server's, not a real authorisation problem. Signing out
      // here would lock a worker out over a wrong clock.
      case 'PGRST303':
        return ClockSkewFailure(debugDetail: raw, cause: error);
    }

    if (raw.contains('INSUFFICIENT_FUNDS')) {
      return InsufficientFundsFailure(
        message: message,
        availableMinor: _availableMinor(raw),
        debugDetail: raw,
        cause: error,
      );
    }

    return ServerFailure(debugDetail: '${error.code}: $raw', cause: error);
  }

  static AppFailure _fromFirebaseAuth(FirebaseAuthException error) {
    final message = switch (error.code) {
      'invalid-phone-number' => 'That phone number does not look right.',
      'invalid-verification-code' => 'That code is not correct. Check and try again.',
      'invalid-verification-id' ||
      'session-expired' =>
        'That code has expired. Ask for a new one.',
      'too-many-requests' =>
        'Too many attempts. Wait a few minutes before trying again.',
      'quota-exceeded' => 'We cannot send a code right now. Try again shortly.',
      'user-disabled' => 'This account has been disabled. Contact support.',
      'network-request-failed' =>
        'No internet connection. Check your network and try again.',
      'operation-not-allowed' =>
        'Phone sign-in is not enabled, or SMS to this region is blocked. '
        'Check Firebase Console settings.',
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

  /// The database raises `'CONFLICT: this job is no longer available'`. The
  /// prefix is for this mapper; the worker sees only what follows it.
  static String _stripPrefix(String raw) {
    final match = RegExp(
      r'^(FORBIDDEN|NOT_FOUND|CONFLICT|INVALID|INSUFFICIENT_FUNDS|INVALID_TRANSITION):\s*',
    ).firstMatch(raw);

    var text = match == null ? raw : raw.substring(match.end);

    // Drop a trailing "CONTEXT:"/"QUERY:" block if PostgREST included one.
    final context = text.indexOf('\nCONTEXT:');
    if (context > 0) text = text.substring(0, context);

    text = text.trim();
    if (text.isEmpty) return 'That did not work. Please try again.';

    // Capitalise, and end the sentence, so server text reads as UI copy.
    final capitalised = text[0].toUpperCase() + text.substring(1);
    return RegExp(r'[.!?]$').hasMatch(capitalised) ? capitalised : '$capitalised.';
  }

  /// `worker_set_availability` puts the full eligibility payload in DETAIL.
  static List<EligibilityReason> _eligibilityReasons(Object? details) {
    if (details == null) return const [];
    try {
      final decoded = details is String ? jsonDecode(details) : details;
      if (decoded is! Map) return const [];
      final reasons = decoded['reasons'];
      if (reasons is! List) return const [];
      return reasons
          .whereType<Map>()
          .map((r) => EligibilityReason.fromJson(Map<String, dynamic>.from(r)))
          .toList(growable: false);
    } catch (_) {
      // A malformed detail block must never mask the underlying refusal.
      return const [];
    }
  }

  /// `request_payout` raises "requested X but the wallet holds Y".
  static int _availableMinor(String raw) {
    final match = RegExp(r'wallet holds (\d+)').firstMatch(raw);
    return match == null ? 0 : int.tryParse(match.group(1)!) ?? 0;
  }
}
