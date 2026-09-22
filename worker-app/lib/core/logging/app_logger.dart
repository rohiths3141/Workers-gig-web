import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Structured logging with a deny-list.
///
/// Anything on [_sensitiveKeys] is redacted before it reaches a log sink, so a
/// document number or a customer's address cannot end up in a crash report
/// because someone logged a whole response body while debugging.
class AppLogger {
  const AppLogger(this._name);

  final String _name;

  static const _sensitiveKeys = <String>{
    'password', 'token', 'id_token', 'idtoken', 'access_token', 'refresh_token',
    'apikey', 'api_key', 'authorization', 'secret',
    'aadhaar', 'aadhar', 'pan', 'pan_number', 'document_number', 'account_number',
    'ifsc', 'arrival_code', 'otp', 'verification_code',
    'phone', 'email', 'address_line', 'latitude', 'longitude',
    'full_name', 'customer_name',
  };

  void debug(String message, [Map<String, Object?>? context]) =>
      _log(LogLevel.debug, message, context);

  void info(String message, [Map<String, Object?>? context]) =>
      _log(LogLevel.info, message, context);

  void warning(String message, [Map<String, Object?>? context]) =>
      _log(LogLevel.warning, message, context);

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _log(LogLevel.error, message, context, error, stackTrace);
  }

  void _log(
    LogLevel level,
    String message, [
    Map<String, Object?>? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Debug lines cost time and battery on a low-end device and say nothing to
    // a worker; they exist only in a debug build.
    if (!kDebugMode && level == LogLevel.debug) return;

    final redacted = context == null ? '' : ' ${redact(context)}';

    developer.log(
      '$message$redacted',
      name: _name,
      level: switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      },
      error: error,
      stackTrace: stackTrace,
    );

    // developer.log() only reaches DevTools' logging view, not the plain
    // `flutter run` console — a warning or error would otherwise be
    // invisible to anyone not attached with DevTools. debugPrint reaches
    // both, and is a no-op outside debug builds.
    if (kDebugMode && (level == LogLevel.warning || level == LogLevel.error)) {
      final tag = level == LogLevel.error ? 'ERROR' : 'WARN';
      debugPrint(
        '[$tag] [$_name] $message$redacted${error != null ? ' | error=$error' : ''}',
      );
    }
  }

  /// Replaces the value of any sensitive key with `***`, recursively.
  @visibleForTesting
  static Map<String, Object?> redact(Map<String, Object?> input) {
    return input.map((key, value) {
      if (_sensitiveKeys.contains(key.toLowerCase())) {
        return MapEntry(key, '***');
      }
      if (value is Map<String, Object?>) return MapEntry(key, redact(value));
      if (value is Map) {
        return MapEntry(key, redact(Map<String, Object?>.from(value)));
      }
      if (value is List) {
        return MapEntry(
          key,
          value
              .map((e) => e is Map ? redact(Map<String, Object?>.from(e)) : e)
              .toList(growable: false),
        );
      }
      return MapEntry(key, value);
    });
  }

  static bool isSensitiveKey(String key) => _sensitiveKeys.contains(key.toLowerCase());
}
