/// Every way a customer-side request can fail, as a closed set.
///
/// Identical sealed hierarchy to the worker app. The server writes the
/// customer-readable messages, so nothing here contains hard-coded wording
/// that could disagree with what the backend says.
sealed class AppFailure implements Exception {
  const AppFailure({required this.message, this.debugDetail, this.cause});

  /// Shown to the customer. Plain language, no error codes.
  final String message;

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
    super.message = 'No internet connection. Check your network and try again.',
    super.debugDetail,
    super.cause,
  });
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'That took too long. Try again.',
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
    super.message = 'Something went wrong at our end. Please try again.',
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
    super.message =
        "Your phone's date and time look out of sync. Turn on automatic "
            'date & time in Settings, then try again.',
    super.debugDetail,
    super.cause,
  });
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.message = 'Something went wrong. Please try again.',
    super.debugDetail,
    super.cause,
  });
}
