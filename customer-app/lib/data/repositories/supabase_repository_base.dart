import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/failure_mapper.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';

/// Base class for all Supabase repositories in the Customer App.
///
/// Provides the `guard` helper that maps any SDK exception to an AppFailure,
/// and `watchRows` for typed Realtime subscriptions.
/// Identical pattern to the worker-app SupabaseRepositoryBase.
abstract base class SupabaseRepositoryBase {
  const SupabaseRepositoryBase(
    this.db, {
    required this.currentFirebaseUid,
  });

  static const _log = AppLogger('SupabaseRepo');

  final SupabaseClient db;

  /// Returns the current Firebase UID, or null if signed out.
  final String? Function() currentFirebaseUid;

  /// Wraps a Supabase call and maps exceptions to [AppFailure].
  ///
  /// Logs the raw error before mapping it to a user-facing message, so a
  /// failure is never silently reduced to "something went wrong" with no
  /// trace of what actually happened.
  Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } catch (error, stackTrace) {
      _log.error('Supabase call failed', error: error, stackTrace: stackTrace);
      return Err(FailureMapper.from(error, stackTrace));
    }
  }

  /// Wraps a nullable Supabase call (returns null = not found, not an error).
  Future<Result<T?>> guardNullable<T>(Future<T?> Function() action) async {
    try {
      return Ok(await action());
    } catch (error, stackTrace) {
      _log.error('Supabase call failed', error: error, stackTrace: stackTrace);
      return Err(FailureMapper.from(error, stackTrace));
    }
  }
}
