import '../localization/app_locale.dart';
import '../../l10n/app_localizations.dart';

/// Every way a customer-side request can fail, as a closed set.
///
/// Identical sealed hierarchy to the worker app. The server writes the
/// customer-readable messages, so nothing here contains hard-coded wording
/// that could disagree with what the backend says.
sealed class AppFailure implements Exception {
  const AppFailure({String? message, this.debugDetail, this.cause})
      : _message = message;

  final String? _message;

  /// Shown to the customer. Plain language, no error codes.
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

  /// For logs and Crashlytics only. Never rendered.
  final String? debugDetail;

  final Object? cause;

  bool get isRetryable => switch (this) {
        NetworkFailure() => true,
        TimeoutFailure() => true,
        ServerFailure() => true,
        UnexpectedFailure() => true,
        ClockSkewFailure() => true,
        _ => false,
      };

  @override
  String toString() =>
      '$runtimeType: $message${debugDetail == null ? '' : ' ($debugDetail)'}';
}

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

final class PermissionFailure extends AppFailure {
  const PermissionFailure({
    required super.message,
    super.debugDetail,
    super.cause,
  });
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    required super.message,
    super.debugDetail,
    super.cause,
  });
}

final class ConflictFailure extends AppFailure {
  const ConflictFailure({
    required super.message,
    super.debugDetail,
    super.cause,
  });
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}

final class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.requiresReauthentication = false,
  });

  final bool requiresReauthentication;
}

final class UploadFailure extends AppFailure {
  const UploadFailure({
    required super.message,
    super.debugDetail,
    super.cause,
    this.isResumable = false,
  });

  final bool isResumable;
}

final class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

/// The phone's clock disagrees with the server's, so the Firebase ID token
/// looks like it was issued in the future (PostgREST PGRST303) and every
/// request is rejected until the skew passes. Retrying after a short wait
/// clears a small skew; a large one is the customer's device settings.
final class ClockSkewFailure extends AppFailure {
  const ClockSkewFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.message,
    super.debugDetail,
    super.cause,
  });
}
