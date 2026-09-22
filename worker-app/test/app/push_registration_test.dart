import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/app/providers/push_registration_provider.dart';

/// Which worker this device's push token belongs to.
///
/// `push_tokens` is keyed on the token, and `worker_register_push_token` does
/// `on conflict (token) do update set profile_id = excluded.profile_id` — so
/// re-registering is how a device moves from one worker to the next, and not
/// re-registering is how it fails to.
///
/// Registration used to be latched behind a single process-wide `_started`
/// flag. Whoever signed in first after launch got the token; the second worker
/// to sign in on the same phone was never registered and received no job
/// alerts at all, while the first worker's row stayed active and kept
/// receiving theirs. With a small pool of test numbers recycled across a
/// couple of handsets, "the second worker" is most of them.
void main() {
  late ProviderContainer container;
  late RegisteredPushToken registered;

  setUp(() {
    container = ProviderContainer();
    registered = container.read(registeredPushTokenProvider);
  });

  tearDown(() => container.dispose());

  group('The registered push token', () {
    test('starts empty', () {
      expect(registered.token, isNull);
      expect(registered.firebaseUid, isNull);
    });

    test('records which worker it belongs to', () {
      registered
        ..token = 'fcm-token'
        ..firebaseUid = 'firebase-uid-ravi';

      expect(registered.firebaseUid, 'firebase-uid-ravi');
    });

    test('a different worker on the same device is a different registration',
        () {
      registered
        ..token = 'fcm-token'
        ..firebaseUid = 'firebase-uid-ravi';

      // What `start()` compares against. Equal means "already registered for
      // this worker, nothing to do"; different means re-register.
      expect(registered.firebaseUid == 'firebase-uid-arun', isFalse,
          reason: 'Arun signing in must not be mistaken for Ravi still being '
              'registered');
    });

    test('clear() forgets both halves', () {
      registered
        ..token = 'fcm-token'
        ..firebaseUid = 'firebase-uid-ravi';

      registered.clear();

      expect(registered.token, isNull);
      expect(registered.firebaseUid, isNull,
          reason: 'A cleared registration must not match the next sign-in '
              'either, or the new worker is never registered');
    });

    test('is reachable without building anything that depends on the session',
        () {
      // The holder exists to be read from SessionController.signOut(), which
      // cannot reach pushRegistrationProvider: that one listens to
      // sessionProvider, so reading it back is a CircularDependencyError.
      // A container with no overrides and no Firebase must be able to read it.
      expect(() => ProviderContainer().read(registeredPushTokenProvider),
          returnsNormally);
    });
  });
}
