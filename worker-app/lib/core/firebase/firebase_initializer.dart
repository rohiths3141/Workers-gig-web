import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../app/config/app_config.dart';
import '../logging/app_logger.dart';

/// Brings Firebase up and wires crash reporting.
///
/// Configuration comes from the platform files that `flutterfire configure`
/// writes — `google-services.json` on Android and `GoogleService-Info.plist` on
/// iOS — so no project identifier is compiled into Dart or committed here.
abstract final class FirebaseInitializer {
  static const _log = AppLogger('Firebase');

  static Future<void> initialize(AppConfig config) async {
    await Firebase.initializeApp();

    if (config.enableCrashReporting) {
      // Flutter framework errors.
      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // Errors from outside the Flutter zone, e.g. a platform channel.
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(true);
    } else {
      // Keep a debugging session out of the production dashboard, and print
      // the error where the developer will see it instead.
      FlutterError.onError = FlutterError.dumpErrorToConsole;
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);
    }

    _log.info('Firebase ready', {'crashReporting': config.enableCrashReporting});
  }

  /// Associates crash reports with a worker.
  ///
  /// The Firebase UID only. Not the phone number, not the name, not the worker
  /// code — a crash report is not a place to accumulate identifying data about
  /// someone who is just trying to do their job.
  static Future<void> setUser(String? firebaseUid) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(firebaseUid ?? '');
  }

  static Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance
        .recordError(error, stackTrace, reason: reason, fatal: fatal);
  }
}
