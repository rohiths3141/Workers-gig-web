import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, FunctionException, PostgrestException, StorageException;

import '../localization/app_locale.dart';
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
        message: AppStrings.current.errorSessionEnded,
        debugDetail: error.message,
        cause: error,
        requiresReauthentication: true,
      );
    }
    if (error is StorageException) {
      return UploadFailure(
        message: AppStrings.current.errorUploadFailed,
        debugDetail: error.message,
        cause: error,
      );
    }
    if (error is FirebaseAuthException) return _fromFirebaseAuth(error);
    if (error is FirebaseException) {
      return UploadFailure(
        message: AppStrings.current.errorUploadFailed,
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
        message: message ?? AppStrings.current.authErrorSignInAgain,
        debugDetail: detail,
        cause: error,
        requiresReauthentication: error.status == 401,
      );
    }

    return ServerFailure(
      message: message ?? AppStrings.current.errorServiceUnavailable,
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
        message: AppStrings.current.errorSignInNotReady,
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
          message: AppStrings.current.errorNoLongerAvailable,
          debugDetail: raw,
          cause: error,
        );

      // RLS refused the row outright.
      case '42P01':
      case 'PGRST301':
        return PermissionFailure(
          message: AppStrings.current.errorNotAllowedToSee,
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
    final l10n = AppStrings.current;
    final message = switch (error.code) {
      'invalid-phone-number' => l10n.authErrorInvalidPhone,
      'invalid-verification-code' => l10n.authErrorWrongCode,
      'invalid-verification-id' ||
      'session-expired' =>
        l10n.authErrorCodeExpired,
      'too-many-requests' => l10n.authErrorTooManyAttempts,
      'quota-exceeded' => l10n.authErrorQuota,
      'user-disabled' => l10n.authErrorDisabled,
      'network-request-failed' => l10n.errorNoInternet,
      'operation-not-allowed' => l10n.authErrorPhoneNotEnabledRegion,
      'credential-already-in-use' ||
      'account-exists-with-different-credential' =>
        l10n.authErrorNumberInUse,
      'requires-recent-login' => l10n.authErrorSignInAgain,
      _ => l10n.authErrorSignInFailed,
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
    if (text.isEmpty) return AppStrings.current.errorDidNotWork;

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
