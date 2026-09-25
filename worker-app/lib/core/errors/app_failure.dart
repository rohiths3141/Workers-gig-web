import '../../l10n/app_localizations.dart';
import '../localization/app_locale.dart';

/// Every way a request can fail, as a closed set.
///
/// The point of this file is that a caller cannot forget a case, and that no
/// database or SDK text ever reaches a worker's screen. Each failure carries a
/// [message] already written for the person holding the phone, and an optional
/// [debugDetail] that goes to logging and crash reporting only.
sealed class AppFailure implements Exception {
  const AppFailure({String? message, this.debugDetail, this.cause})
      : _message = message;

  final String? _message;

  /// Shown to the worker. Plain language, no jargon, no error codes.
  ///
  /// A failure the server or the app described carries that wording. One
  /// that only knows its kind is worded when it is shown, in the language on
  /// screen at that moment.
  String get message => _message ?? _defaultMessage(AppStrings.current);

  String _defaultMessage(AppLocalizations l10n) => switch (this) {
        NetworkFailure() => l10n.errorNoInternet,
        TimeoutFailure() => l10n.errorTimeout,
        ServerFailure() => l10n.errorServer,
        ClockSkewFailure() => l10n.errorClockSkew,
        _ => l10n.errorUnexpected,
      };

  /// For logs and Crashlytics. Never rendered.
  final String? debugDetail;

  final Object? cause;

  /// Whether offering a "Try again" button makes sense. Retrying a permission
  /// error just wastes the worker's time.
  bool get isRetryable => switch (this) {
        NetworkFailure() => true,
        TimeoutFailure() => true,
        ServerFailure() => true,
        UnexpectedFailure() => true,
        ClockSkewFailure() => true,
        _ => false,
      };

  @override
  String toString() => '$runtimeType: $message${debugDetail == null ? '' : ' ($debugDetail)'}';
}

/// No usable connection, or the request never reached the server.
final class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

/// The server refused: the caller is not allowed to do this.
final class PermissionFailure extends AppFailure {
  const PermissionFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.reasons = const [],
  });

  /// Structured reasons, when the server supplied them — an ineligible worker
  /// gets a task list rather than a dead end.
  final List<EligibilityReason> reasons;
}

/// The thing being acted on is gone, or was never visible to this caller.
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    required super.message,
    super.debugDetail,
    super.cause,
  });
}

/// Someone else got there first, or this was already done.
final class ConflictFailure extends AppFailure {
  const ConflictFailure({
    required super.message,
    super.debugDetail,
    super.cause,
  });
}

/// The input was rejected. [message] is the server's own wording, which is
/// written for the worker.
final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}

final class InsufficientFundsFailure extends AppFailure {
  const InsufficientFundsFailure({
    required super.message,
    required this.availableMinor,
    super.debugDetail,
    super.cause,
  });

  final int availableMinor;
}

/// Signed out, token expired, or the account was disabled. The session layer
/// watches for this and returns the worker to the sign-in screen.
final class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.requiresReauthentication = false,
  });

  final bool requiresReauthentication;
}

/// The upload itself failed. Distinct from a network failure because the UI
/// offers resume rather than a plain retry.
final class UploadFailure extends AppFailure {
  const UploadFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.isResumable = false,
  });

  final bool isResumable;
}

/// The server reached, understood, and broke.
final class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

/// Nothing above matched. Always reported to crash monitoring.
final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

/// The phone's clock disagrees with the server's, so the Firebase ID token
/// looks like it was issued in the future (PostgREST PGRST303) and every
/// request is rejected until the skew passes. Retrying after a short wait
/// clears a small skew; a large one is the worker's device settings.
final class ClockSkewFailure extends AppFailure {
  const ClockSkewFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

/// One reason a worker is not currently eligible to receive jobs, as returned
/// by the `worker_eligibility` contract.
class EligibilityReason {
  const EligibilityReason({
    required this.code,
    required this.message,
    this.action,
  });

  factory EligibilityReason.fromJson(Map<String, dynamic> json) => EligibilityReason(
        code: json['code'] as String? ?? 'UNKNOWN',
        message: json['message'] as String? ??
            AppStrings.current.eligibilityStepIncomplete,
        action: json['action'] as String?,
      );

  /// Machine-readable, e.g. `KYC_REQUIRED`.
  final String code;

  /// Worker-readable, written by the server.
  final String message;

  /// Where to send the worker to fix it, e.g. `verification/kyc`.
  final String? action;
}
