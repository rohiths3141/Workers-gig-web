import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../router/app_router.dart';
import 'providers.dart';
import 'session_controller.dart';

const _log = AppLogger('PushRegistration');

/// The push token this device last registered, and for whom.
///
/// A standalone holder with no dependencies of its own, and the reason this
/// file and [SessionController] can both reach the token without a cycle:
/// `pushRegistrationProvider` listens to `sessionProvider`, so a sign-out that
/// read the registration back would be Riverpod's `CircularDependencyError` —
/// thrown, in debug, on the sign-out button.
class RegisteredPushToken {
  String? token;
  String? firebaseUid;

  void clear() {
    token = null;
    firebaseUid = null;
  }
}

final registeredPushTokenProvider =
    Provider<RegisteredPushToken>((ref) => RegisteredPushToken());

/// Registers this device for push once a worker profile exists, and keeps the
/// registration current if FCM rotates the token.
///
/// `push_tokens` and the `worker_register_push_token` RPC already existed —
/// nothing in the app ever called `FirebaseMessaging` to get a token in the
/// first place, so no notification the backend queued could ever be
/// delivered. This is the missing wire, not a new backend contract.
///
/// It never raises the system permission dialog by itself. Asking the moment
/// profile setup opened gave the worker a prompt with no idea what it was
/// for; [PushRegistration.requestPermissionAndRegister] is called from a
/// screen that has explained the reason first.
class PushRegistration {
  PushRegistration(this._ref);

  final Ref _ref;

  /// Process-wide listeners (token rotation, notification taps) are wired once.
  bool _listening = false;

  /// What this device has registered, and for whom.
  ///
  /// Registration used to be latched on a plain `_started` flag, which meant
  /// the token was bound to whichever worker signed in first after launch. On
  /// a shared phone — the normal case here, where a small pool of test numbers
  /// is recycled — the second worker to sign in was never registered at all
  /// and received no job alerts, while the first worker's row stayed active
  /// and kept receiving theirs. Keyed by UID, a change of worker re-registers.
  RegisteredPushToken get _registered =>
      _ref.read(registeredPushTokenProvider);

  StreamSubscription<String>? _tokenRefresh;

  /// True when notifications are not currently getting through, so a screen
  /// can explain what they are for before raising the system prompt.
  ///
  /// Deliberately not a `notDetermined` check: that status is an iOS concept.
  /// On Android the plugin reports `authorized` or `denied` from
  /// `areNotificationsEnabled()`, so a worker who has never been asked looks
  /// exactly like one who said no — and testing for `notDetermined` meant the
  /// explanation never appeared on Android at all.
  Future<bool> get needsPermissionPrompt async {
    try {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      return settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional;
    } catch (e) {
      _log.warning('Could not read the notification settings: $e');
      return false;
    }
  }

  /// Raises the system prompt, then registers if the worker allowed it.
  /// Returns whether push is now permitted.
  Future<bool> requestPermissionAndRegister() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final granted =
          settings.authorizationStatus != AuthorizationStatus.denied;
      if (granted) await _registerCurrentToken();
      return granted;
    } catch (e) {
      _log.warning('Could not request notification permission: $e');
      return false;
    }
  }

  /// Best-effort throughout: getToken() throws when Firebase Installations
  /// cannot reach Google (FIS_AUTH_ERROR), and a worker who cannot receive
  /// push must still be able to use the app.
  Future<void> _registerCurrentToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _register(token);
    } catch (e) {
      _log.warning('Could not register for push notifications: $e');
    }
  }

  Future<void> _register(String token) async {
    final result =
        await _ref.read(notificationRepositoryProvider).registerPushToken(
              token: token,
              platform: Platform.isIOS ? 'IOS' : 'ANDROID',
            );
    result.fold(
      (_) {
        _registered
          ..token = token
          ..firebaseUid = _ref.read(firebaseUidProvider);
      },
      // Left unrecorded on failure, so the next session change tries again
      // rather than assuming a registration that never happened.
      (failure) =>
          _log.warning('Could not register push token: ${failure.message}'),
    );
  }

  // The payload keys come from notify_workers_new_request() (migration 0041).
  void _openFromNotification(RemoteMessage message) {
    final requestId = message.data['request_id'];
    if (message.data['type'] == 'service_request' && requestId is String) {
      _ref.read(appRouterProvider).push('/customer-requests/$requestId');
    }
  }

  Future<void> start() async {
    // Re-runs when the signed-in worker changes, so the token follows the
    // worker actually using the phone.
    final uid = _ref.read(firebaseUidProvider);
    if (uid != null && uid != _registered.firebaseUid) {
      // Only register when the worker has already allowed notifications —
      // never prompt from here.
      try {
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();
        if (settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional) {
          await _registerCurrentToken();
        }
      } catch (e) {
        _log.warning('Could not read the notification settings: $e');
      }
    }

    if (_listening) return;
    _listening = true;

    try {
      final launchMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (launchMessage != null) _openFromNotification(launchMessage);
    } catch (e) {
      _log.warning('Could not read the launch notification: $e');
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_openFromNotification);

    // A token can rotate at any time (reinstall, app data clear, FCM's own
    // rotation) — re-registering keeps push working without asking the
    // worker to do anything.
    _tokenRefresh = FirebaseMessaging.instance.onTokenRefresh
        .handleError((Object e) =>
            _log.warning('Push token refresh stream failed: $e'))
        .listen((newToken) async {
      // Only while someone is signed in: a rotation that arrives after
      // sign-out has no profile to register against.
      if (_ref.read(firebaseUidProvider) == null) return;
      await _register(newToken);
    });
  }

  void dispose() {
    unawaited(_tokenRefresh?.cancel());
  }
}

/// The builder here runs exactly once per process: it never calls `ref.watch`,
/// only `ref.listen`, so nothing about a later session refresh re-executes it
/// or creates a second `onTokenRefresh` subscription.
final pushRegistrationProvider = Provider<PushRegistration>((ref) {
  final registration = PushRegistration(ref);
  ref.onDispose(registration.dispose);

  ref.listen(sessionProvider, (previous, next) {
    final session = next.valueOrNull;
    if (session is SessionOnboarding || session is SessionReady) {
      unawaited(registration.start());
    }
  }, fireImmediately: true);

  return registration;
});
