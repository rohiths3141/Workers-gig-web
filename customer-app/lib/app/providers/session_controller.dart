import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/auth/token_claims.dart';
import '../../core/errors/result.dart';
import '../../core/firebase/firebase_initializer.dart';
import '../../core/logging/app_logger.dart';
import '../../core/supabase/supabase_client_provider.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/repositories.dart';
import 'providers.dart';

/// Where the app should send the customer.
sealed class Session {
  const Session();
}

class SessionLoading extends Session {
  const SessionLoading();
  @override bool operator ==(Object o) => o is SessionLoading;
  @override int get hashCode => runtimeType.hashCode;
}

class SessionSignedOut extends Session {
  const SessionSignedOut();
  @override bool operator ==(Object o) => o is SessionSignedOut;
  @override int get hashCode => runtimeType.hashCode;
}

/// Firebase account exists but no customer profile yet.
class SessionNeedsRegistration extends Session {
  const SessionNeedsRegistration({
    required this.firebaseUid,
    this.phoneNumber,
  });
  final String firebaseUid;
  final String? phoneNumber;
  @override
  bool operator ==(Object o) =>
      o is SessionNeedsRegistration &&
      o.firebaseUid == firebaseUid &&
      o.phoneNumber == phoneNumber;
  @override
  int get hashCode => Object.hash(runtimeType, firebaseUid, phoneNumber);
}

class SessionReady extends Session {
  const SessionReady({required this.customer});
  final Customer customer;
  @override
  bool operator ==(Object o) =>
      o is SessionReady && o.customer.id == customer.id;
  @override
  int get hashCode => Object.hash(runtimeType, customer.id);
}

class SessionError extends Session {
  const SessionError(this.failure);
  final AppFailure failure;
  @override
  bool operator ==(Object o) =>
      o is SessionError && o.failure == failure;
  @override
  int get hashCode => Object.hash(runtimeType, failure);
}

/// The app has no backend configuration (missing --dart-define values).
/// This is a development/deployment problem, not a normal auth state —
/// it must never be papered over with a placeholder customer.
class SessionConfigurationError extends Session {
  const SessionConfigurationError();
  @override bool operator ==(Object o) => o is SessionConfigurationError;
  @override int get hashCode => runtimeType.hashCode;
}

/// Holds and resolves the current customer session.
///
/// Mirrors the worker-app SessionController. The difference is that the
/// customer has no multi-step onboarding: once the profile exists, they go
/// straight to the home screen.
class SessionController extends AsyncNotifier<Session> {
  static const _log = AppLogger('Session');

  /// Firebase UIDs already confirmed to carry the Supabase role claim this
  /// app run, so a routine token refresh doesn't re-hit the web tier.
  static final Set<String> _roleClaimVerified = {};

  Future<void> _ensureSupabaseRole(String firebaseUid) async {
    if (_roleClaimVerified.contains(firebaseUid)) return;

    final apiBaseUrl = ref.read(appConfigProvider).apiBaseUrl;
    if (apiBaseUrl.isEmpty) return;

    final tokenResult = await ref.read(authRepositoryProvider).idToken();
    final token = tokenResult.valueOrNull;
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/claims'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['ok'] != true) {
        _log.warning('Supabase role claim rejected: ${json['error']}');
        return;
      }

      final refreshRequired =
          (json['data'] as Map<String, dynamic>?)?['refreshRequired'] == true;
      if (refreshRequired && !await _awaitRoleClaimInToken()) {
        // Do not mark this UID verified: the next attempt should ask again
        // rather than assume a claim that never showed up.
        _log.warning('Supabase role claim not visible in the ID token yet');
        return;
      }
      _roleClaimVerified.add(firebaseUid);
    } catch (e) {
      _log.warning('Could not ensure Supabase role claim: $e');
    }
  }

  /// Refreshes the ID token until it actually carries `role: authenticated`.
  ///
  /// `setCustomUserClaims` and Firebase's token service settle independently,
  /// so a forced refresh immediately afterwards can still mint a token without
  /// the claim. That token is then cached for an hour and every Supabase
  /// request runs as `anon` — sign-in succeeds, and then the profile read is
  /// denied with nothing on screen to explain it.
  Future<bool> _awaitRoleClaimInToken() async {
    const delays = [
      Duration.zero,
      Duration(milliseconds: 800),
      Duration(milliseconds: 1600),
      Duration(seconds: 3),
    ];

    for (final delay in delays) {
      if (delay > Duration.zero) await Future<void>.delayed(delay);

      final token =
          (await ref.read(authRepositoryProvider).idToken(forceRefresh: true))
              .valueOrNull;
      if (hasSupabaseRole(token)) return true;
    }
    return false;
  }

  /// Whether [failure] is PostgREST refusing a request that reached it as
  /// `anon` rather than a genuine "you may not see this row".
  ///
  /// supabase-dart puts the HTTP status in `PostgrestException.code`, so the
  /// Postgres `42501` only appears inside the message body — which is why this
  /// matches on the text rather than the code.
  static bool _looksLikeAnonDenial(AppFailure? failure) {
    if (failure == null) return false;
    final detail = failure.debugDetail ?? '';
    return detail.contains('42501') || detail.contains('permission denied');
  }

  @override
  Future<Session> build() async {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      loading: () => const SessionLoading(),
      error: (error, _) => SessionError(
        error is AppFailure ? error : const UnexpectedFailure(),
      ),
      data: (authState) async {
        switch (authState) {
          case AuthSignedOut():
          case AuthUnknown():
            try { await FirebaseInitializer.setUser(null); } catch (_) {}
            return const SessionSignedOut();
          case AuthAwaitingOtp():
            return const SessionSignedOut();
          case AuthSignedIn(:final firebaseUid, :final phoneNumber):
            try { await FirebaseInitializer.setUser(firebaseUid); } catch (_) {}
            if (SupabaseClientProvider.isInitialized) {
              // Firebase ID tokens don't carry `role: authenticated` by
              // default; Supabase's third-party-auth mapping relies on that
              // claim to run the request as `authenticated` rather than
              // `anon`. Until the web tier stamps it onto this user (once,
              // server-side) and we pick up a token minted after that,
              // every RLS policy scoped to `authenticated` denies us even
              // though sign-in itself succeeded.
              await _ensureSupabaseRole(firebaseUid);
              final tokenResult = await ref.read(authRepositoryProvider).idToken();
              await SupabaseClientProvider.instance.syncRealtimeAuth(tokenResult.valueOrNull);
            }
            return _resolveCustomer(firebaseUid, phoneNumber);
        }
      },
    );
  }

  Future<Session> _resolveCustomer(
      String firebaseUid, String? phoneNumber) async {
    // If Supabase is not configured (dev run without --dart-define keys),
    // surface this as a real configuration error. Never fabricate a
    // customer session — the app must not look "populated" over a
    // disconnected backend.
    if (!SupabaseClientProvider.isInitialized) {
      _log.warning(
        'Supabase not initialized — missing --dart-define=SUPABASE_URL=... '
        '--dart-define=SUPABASE_ANON_KEY=...',
      );
      return const SessionConfigurationError();
    }

    var result = await _getCustomerWithClockSkewRetry();

    // A denial here means the token went out as `anon` — the role claim was
    // not on it after all. Ask the web tier again and retry once before
    // showing an error the customer can do nothing about.
    if (_looksLikeAnonDenial(result.failureOrNull)) {
      _log.warning('Profile read denied; re-provisioning the role claim');
      _roleClaimVerified.remove(firebaseUid);
      await _ensureSupabaseRole(firebaseUid);
      if (SupabaseClientProvider.isInitialized) {
        final token = await ref.read(authRepositoryProvider).idToken();
        await SupabaseClientProvider.instance
            .syncRealtimeAuth(token.valueOrNull);
      }
      result = await _getCustomerWithClockSkewRetry();
    }

    return result.fold(
      (customer) async {
        var resolved = customer;

        if (resolved == null) {
          // No row for this UID. Before concluding that registration never
          // happened, ask whether this caller's OTP-verified number already
          // owns an account. Firebase issues a *new* UID when a user record is
          // deleted and the same number signs in again, which left the
          // customer being sent to register and then refused there, because
          // the old row still held their number.
          final claimed =
              await ref.read(customerRepositoryProvider).claimExistingAccount();

          resolved = claimed.valueOrNull;
          if (resolved != null) {
            _log.info('Re-bound an existing account to a new Firebase UID');
          }
        }

        if (resolved == null) {
          return SessionNeedsRegistration(
            firebaseUid: firebaseUid,
            phoneNumber: phoneNumber,
          );
        }
        return SessionReady(customer: resolved);
      },
      (failure) {
        _log.warning('Could not resolve customer profile: $failure');
        if (failure is AuthFailure && failure.requiresReauthentication) {
          return const SessionSignedOut();
        }
        // Network/DB failure → show error but don't loop back to login.
        return SessionError(failure);
      },
    );
  }

  /// Loads the profile, retrying while PostgREST rejects the Firebase token
  /// as "issued at future".
  ///
  /// A phone whose clock runs a couple of seconds fast mints tokens Supabase
  /// will not accept yet; the request succeeds once real time catches up. A
  /// single 401 on launch used to surface as "Something went wrong", so wait
  /// it out before giving up — and force a fresh token each attempt in case
  /// the clock has since been corrected.
  Future<Result<Customer?>> _getCustomerWithClockSkewRetry() async {
    const backoff = [
      Duration(milliseconds: 900),
      Duration(milliseconds: 1800),
      Duration(milliseconds: 2700),
    ];

    final repo = ref.read(customerRepositoryProvider);
    var result = await repo.getCurrentCustomer();

    for (final delay in backoff) {
      final failure = result.failureOrNull;
      if (failure is! ClockSkewFailure) break;

      _log.warning('Token rejected as clock-skewed; retrying in '
          '${delay.inMilliseconds}ms');
      await Future<void>.delayed(delay);

      final refreshed =
          await ref.read(authRepositoryProvider).idToken(forceRefresh: true);
      if (SupabaseClientProvider.isInitialized) {
        await SupabaseClientProvider.instance
            .syncRealtimeAuth(refreshed.valueOrNull);
      }
      result = await repo.getCurrentCustomer();
    }

    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authState = ref.read(authRepositoryProvider).currentState;
      if (authState is! AuthSignedIn) return const SessionSignedOut();
      return _resolveCustomer(authState.firebaseUid, authState.phoneNumber);
    });
  }

  Future<Result<void>> signOut() async {
    final result = await ref.read(authRepositoryProvider).signOut();
    ref.invalidateSelf();
    return result;
  }
}

final sessionProvider =
    AsyncNotifierProvider<SessionController, Session>(SessionController.new);

final currentCustomerProvider = Provider<Customer?>((ref) {
  final session = ref.watch(sessionProvider).valueOrNull;
  return switch (session) {
    SessionReady(:final customer) => customer,
    _ => null,
  };
});
