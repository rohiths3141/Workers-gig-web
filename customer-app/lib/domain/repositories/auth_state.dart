/// The current Firebase authentication state.
///
/// Sealed so callers cannot forget a case. Matches the worker-app pattern exactly.
sealed class AuthState {
  const AuthState();
}

/// Still waiting for Firebase to emit its first event (app just started).
class AuthUnknown extends AuthState {
  const AuthUnknown();
}

class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

/// OTP was requested. The verificationId must be kept for [verifyOtp].
class AuthAwaitingOtp extends AuthState {
  const AuthAwaitingOtp({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;
}

class AuthSignedIn extends AuthState {
  const AuthSignedIn({
    required this.firebaseUid,
    this.phoneNumber,
  });
  final String firebaseUid;
  final String? phoneNumber;
}
