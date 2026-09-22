import 'package:flutter/foundation.dart';

/// Minimal structured logger.
///
/// In development every message goes to debugPrint. In production only warnings
/// and errors are emitted (Crashlytics handles the rest). The API matches the
/// worker-app logger so shared code can use either without changes.
class AppLogger {
  const AppLogger(this.tag);

  final String tag;

  void info(String message, [Map<String, Object?>? context]) {
    if (kDebugMode) _emit('INFO', message, context);
  }

  void warning(String message, [Map<String, Object?>? context]) {
    _emit('WARN', message, context);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _emit('ERROR', message, {
      if (error != null) 'error': error.toString(),
      if (context != null) ...context,
    });
    if (stackTrace != null && kDebugMode) {
      debugPrint(stackTrace.toString());
    }
  }

  void _emit(String level, String message, Map<String, Object?>? context) {
    final ctx = context?.entries.map((e) => '${e.key}=${e.value}').join(' ');
    debugPrint('[$level] [$tag] $message${ctx != null ? ' | $ctx' : ''}');
  }
}
