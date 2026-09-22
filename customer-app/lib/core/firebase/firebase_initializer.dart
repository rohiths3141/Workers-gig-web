import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../app/config/app_config.dart';
import '../logging/app_logger.dart';

/// Brings Firebase up and wires crash reporting for the Customer App.
///
/// Configuration comes from the platform files that `flutterfire configure`
/// writes — google-services.json on Android, GoogleService-Info.plist on iOS.
/// No project identifier is compiled into Dart.
abstract final class FirebaseInitializer {
  static const _log = AppLogger('Firebase');

  /// Full init: calls Firebase.initializeApp() then configures Crashlytics.
  /// Use when you want the options loaded from google-services.json / values.xml.
  static Future<void> initialize(AppConfig config) async {
    await Firebase.initializeApp();
    await configurePostInit(config);
  }

  /// Configures Crashlytics after Firebase has already been initialized.
  /// Call this when you pass explicit [FirebaseOptions] to initializeApp().
  static Future<void> configurePostInit(AppConfig config) async {
    if (config.enableCrashReporting) {
      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      FlutterError.onError = FlutterError.dumpErrorToConsole;
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);
    }

    _log.info('Firebase ready', {'crashReporting': config.enableCrashReporting});
  }

  /// Associates crash reports with a customer (Firebase UID only — no PII).
  static Future<void> setUser(String? firebaseUid) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(firebaseUid ?? '');
  }
}
