import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import 'providers.dart';
import 'session_controller.dart';

const _log = AppLogger('PushRegistration');

/// Registers this device for push once a customer profile exists, and keeps
/// the registration current if FCM rotates the token.
///
/// `push_tokens` and `customer_register_push_token` already existed —
/// nothing in the app ever called `FirebaseMessaging` to obtain a token, so no
/// notification the backend queued could ever be delivered. This is the
/// missing wire, not a new backend contract.
///
/// The builder runs exactly once per process: it never calls `ref.watch`,
/// only `ref.listen`, so a later session refresh cannot re-execute it or
/// create a second `onTokenRefresh` subscription.
final pushRegistrationProvider = Provider<void>((ref) {
  var registered = false;

  Future<void> registerCurrentToken() async {
    // Everything here is best-effort. getToken() throws outright when Firebase
    // Installations cannot reach Google (FIS_AUTH_ERROR on a misconfigured or
    // offline build), and an app that cannot register for push must still
    // start: this used to surface as an unhandled exception at launch.
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _log.info('Push permission denied; not registering a token');
        return;
      }

      final token = await messaging.getToken();
      if (token == null) return;

      await ref.read(notificationRepositoryProvider).registerPushToken(
            token,
            Platform.isIOS ? 'IOS' : 'ANDROID',
          );
    } catch (e) {
      _log.warning('Could not register for push notifications: $e');
    }
  }

  Future<void> start() async {
    if (registered) return;
    registered = true;

    await registerCurrentToken();

    FirebaseMessaging.instance.onTokenRefresh
        .handleError((Object e) =>
            _log.warning('Push token refresh stream failed: $e'))
        .listen((newToken) async {
      try {
        await ref.read(notificationRepositoryProvider).registerPushToken(
              newToken,
              Platform.isIOS ? 'IOS' : 'ANDROID',
            );
      } catch (e) {
        _log.warning('Could not re-register refreshed push token: $e');
      }
    });
  }

  ref.listen(sessionProvider, (previous, next) {
    if (next.valueOrNull is SessionReady) {
      unawaited(start());
    }
  }, fireImmediately: true);
});
