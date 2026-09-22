import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;
import 'package:wervexa_worker/app/config/app_config.dart';
import 'package:wervexa_worker/app/providers/providers.dart';
import 'package:wervexa_worker/app/providers/push_registration_provider.dart';
import 'package:wervexa_worker/app/providers/session_controller.dart';
import 'package:wervexa_worker/core/errors/app_failure.dart';
import 'package:wervexa_worker/core/errors/result.dart';
import 'package:wervexa_worker/domain/entities/support.dart';
import 'package:wervexa_worker/domain/entities/worker.dart';
import 'package:wervexa_worker/domain/repositories/repositories.dart';

/// Signing out has to actually end the session on the device.
///
/// It used to do one thing — `ref.invalidateSelf()` — which re-resolved the
/// session and nothing else. Three things outlived it:
///
///   * the Realtime channels joined for the departing worker, so a signed-out
///     phone went on receiving their offers and booking changes;
///   * this device's push token, still active against their profile, so their
///     job alerts kept arriving on a phone they no longer held;
///   * every repository, each holding the `workers.id` it had resolved.
///
/// A handful of test numbers are recycled across the same phones here, so the
/// worker who signs in next is routinely a different person.
void main() {
  late _FakeAuthRepository auth;
  late _RecordingNotificationRepository notifications;
  late ProviderContainer container;

  const config = AppConfig(
    supabaseUrl: 'https://example.supabase.co',
    supabaseAnonKey: 'publishable-key',
    apiBaseUrl: 'https://example.test/api',
    environment: 'test',
    enableCrashReporting: false,
    enableAnalytics: false,
  );

  setUp(() {
    auth = _FakeAuthRepository();
    notifications = _RecordingNotificationRepository(auth);

    container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        // Repositories are built to prove they get rebuilt; none of them is
        // allowed to talk to a real project.
        supabaseClientProvider.overrideWithValue(
          SupabaseClient(
            'https://example.supabase.co',
            'publishable-key',
            httpClient: MockClient((request) async =>
                http.Response('[]', 200, request: request, headers: const {
                  'content-type': 'application/json',
                })),
            accessToken: () async => 'an-id-token',
          ),
        ),
        authRepositoryProvider.overrideWithValue(auth),
        notificationRepositoryProvider.overrideWithValue(notifications),
        // The session reads the worker repository while resolving; this test
        // is about what sign-out tears down, so the profile read is a stub.
        workerRepositoryProvider.overrideWithValue(_StubWorkerRepository()),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('Signing out', () {
    test('switches this device off for the departing worker', () async {
      auth.signIn('firebase-uid-ravi');
      container.read(registeredPushTokenProvider).token =
          'fcm-token-on-this-phone';

      await container.read(sessionProvider.notifier).signOut();

      expect(notifications.deactivated, ['fcm-token-on-this-phone'],
          reason: "The departing worker's alerts must stop arriving here");
      expect(auth.signedOut, isTrue);
    });

    test('deactivates the token before Firebase drops the session', () async {
      // The update is authorized by the caller's own ID token — RLS scopes it
      // to `firebase_uid = public.firebase_uid()`. Run it after sign-out and
      // there is no token left to authorize it with.
      auth.signIn('firebase-uid-ravi');
      container.read(registeredPushTokenProvider).token =
          'fcm-token-on-this-phone';

      await container.read(sessionProvider.notifier).signOut();

      expect(notifications.wasSignedInWhenDeactivated, isTrue);
    });

    test('does not fail the sign-out when the push row will not update',
        () async {
      // A worker must never be held on a screen because a best-effort cleanup
      // failed.
      notifications.failDeactivation = true;
      auth.signIn('firebase-uid-ravi');
      container.read(registeredPushTokenProvider).token =
          'fcm-token-on-this-phone';

      final result = await container.read(sessionProvider.notifier).signOut();

      expect(result.isOk, isTrue);
      expect(auth.signedOut, isTrue);
    });

    test('is a no-op on push when this device never registered', () async {
      auth.signIn('firebase-uid-ravi');

      await container.read(sessionProvider.notifier).signOut();

      expect(notifications.deactivated, isEmpty);
      expect(auth.signedOut, isTrue);
    });

    test('rebuilds every repository, so none carries a resolved id across',
        () async {
      auth.signIn('firebase-uid-ravi');

      final before = container.read(jobRepositoryProvider);
      final walletBefore = container.read(walletRepositoryProvider);

      await container.read(sessionProvider.notifier).signOut();

      expect(identical(container.read(jobRepositoryProvider), before), isFalse,
          reason: 'A rebuilt repository cannot hold the last session\'s '
              'workers.id');
      expect(identical(container.read(walletRepositoryProvider), walletBefore),
          isFalse);
    });

    test('does not reach back through a provider that depends on the session',
        () async {
      // `pushRegistrationProvider` listens to `sessionProvider`, so reading it
      // from here is a genuine cycle and Riverpod throws
      // CircularDependencyError for it — in debug, on the sign-out button.
      // The token is held in a provider with no dependencies precisely so this
      // path stays acyclic.
      auth.signIn('firebase-uid-ravi');
      container.read(registeredPushTokenProvider).token = 'fcm-token';

      await expectLater(
        container
            .read(sessionProvider.notifier)
            .signOut()
            .timeout(const Duration(seconds: 5)),
        completion(isA<Ok<void>>()),
      );
      expect(notifications.deactivated, ['fcm-token']);
    });

    test('forgets the token, so a later sign-out cannot re-send it', () async {
      auth.signIn('firebase-uid-ravi');
      container.read(registeredPushTokenProvider).token = 'fcm-token';

      await container.read(sessionProvider.notifier).signOut();
      await container.read(sessionProvider.notifier).signOut();

      expect(notifications.deactivated, ['fcm-token'],
          reason: 'A cleared registration must not be deactivated twice');
    });
  });
}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeAuthRepository implements AuthRepository {
  final _states = StreamController<AuthState>.broadcast();
  AuthState _current = const AuthSignedOut();
  bool signedOut = false;

  void signIn(String uid) {
    _current = AuthSignedIn(firebaseUid: uid, phoneNumber: '+919090909090');
    _states.add(_current);
  }

  @override
  AuthState get currentState => _current;

  @override
  Stream<AuthState> authStateChanges() => _states.stream;

  @override
  Future<Result<void>> signOut() async {
    signedOut = true;
    _current = const AuthSignedOut();
    _states.add(_current);
    return const Ok(null);
  }

  @override
  Future<Result<String>> idToken({bool forceRefresh = false}) async =>
      _current is AuthSignedIn
          ? const Ok('an-id-token')
          : const Err(AuthFailure(
              message: 'Please sign in to continue.',
              requiresReauthentication: true,
            ));

  @override
  Future<Result<AuthAwaitingOtp>> requestOtp(String phoneNumber) async =>
      throw UnimplementedError();

  @override
  Future<Result<AuthSignedIn>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Result<AuthAwaitingOtp>> resendOtp({
    required String phoneNumber,
    int? resendToken,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> requestAccountDeletion({required String reason}) async =>
      throw UnimplementedError();
}

class _RecordingNotificationRepository implements NotificationRepository {
  _RecordingNotificationRepository(this._auth);

  final _FakeAuthRepository _auth;
  final List<String> deactivated = [];
  bool failDeactivation = false;

  /// Whether a Firebase session still existed at the moment of the call.
  bool wasSignedInWhenDeactivated = false;

  @override
  Future<Result<void>> deactivatePushToken(String token) async {
    wasSignedInWhenDeactivated = !_auth.signedOut;
    if (failDeactivation) {
      return const Err(PermissionFailure(message: 'You are not able to see that.'));
    }
    deactivated.add(token);
    return const Ok(null);
  }

  @override
  Future<Result<void>> registerPushToken({
    required String token,
    required String platform,
    String? deviceLabel,
  }) async =>
      const Ok(null);

  @override
  Future<Result<PagedResult<AppNotification>>> getNotifications({
    int limit = 20,
    int offset = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Stream<List<AppNotification>> watchNotifications() =>
      throw UnimplementedError();

  @override
  Future<Result<int>> getUnreadCount() async => throw UnimplementedError();

  @override
  Future<Result<void>> markRead(String notificationId) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> markAllRead() async => throw UnimplementedError();
}

/// The session resolves a profile on the way in; nothing here is under test.
class _StubWorkerRepository implements WorkerRepository {
  @override
  Future<Result<Worker?>> getCurrentWorker() async => const Ok(null);

  @override
  Future<Result<Worker?>> claimExistingAccount() async => const Ok(null);

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
