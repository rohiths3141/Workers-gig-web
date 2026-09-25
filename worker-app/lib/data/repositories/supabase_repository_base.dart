import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/errors/failure_mapper.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../core/localization/app_locale.dart';

/// Shared plumbing for the Supabase-backed repositories.
///
/// Two things live here so every repository gets them identically:
///
///   * [guard] turns any thrown error into an [AppFailure]. Note what it does
///     *not* do — there is no `onError: returnSampleData` parameter and no
///     fallback value. A failure is returned as a failure, which is what forces
///     the UI to show an error with a retry instead of inventing content.
///
///   * [watchRows] builds a Realtime stream that is always filtered to this
///     worker's own rows. Nothing subscribes to a whole table.
abstract base class SupabaseRepositoryBase {
  SupabaseRepositoryBase(
    this.db, {
    required this.currentFirebaseUid,
    AppLogger? logger,
  }) : _log = logger ?? const AppLogger('Repository');

  final SupabaseClient db;

  /// The signed-in Firebase UID, from the auth layer.
  ///
  /// It comes from here rather than from `db.auth` because this client is
  /// configured for Supabase third-party auth: it holds no session of its own
  /// and `db.auth` throws outright when touched. Identity on this platform
  /// lives in exactly one place, and this is how a repository reads it.
  final String? Function() currentFirebaseUid;

  final AppLogger _log;

  /// The caller's Firebase UID, or a refusal.
  ///
  /// Used to filter a query or a Realtime subscription to the caller's own
  /// rows. RLS enforces the same restriction server-side, so this is about
  /// asking the right question rather than about trusting the answer.
  String get uid {
    final value = currentFirebaseUid();
    if (value == null || value.isEmpty) {
      throw AuthFailure(
        message: AppStrings.current.authSignInToContinue,
        requiresReauthentication: true,
      );
    }
    return value;
  }

  String? _cachedWorkerId;

  /// The Firebase UID [_cachedWorkerId] was resolved for.
  ///
  /// The cache is keyed rather than bare because these repositories are
  /// app-lifetime singletons: `workerRepositoryProvider` and its siblings are
  /// plain `Provider`s, and signing out invalidates only the session, not
  /// them. A bare cache therefore survived a sign-out, and the next worker to
  /// use the same phone — routine here, where a handful of test numbers are
  /// recycled — queried `booking_match_candidates`, `wallets` and their own
  /// gigs with the *previous* worker's UUID. RLS denies most of that, so it
  /// surfaced as a worker who could not see their own offers rather than as
  /// one who could see someone else's; either way the answer was wrong.
  String? _cachedWorkerIdFor;

  /// The caller's `workers.id` (a Postgres UUID) — distinct from [uid], which
  /// is the Firebase UID string. Several tables (`booking_match_candidates`,
  /// `wallets`, ...) key `worker_id` as a UUID foreign key, so filtering them
  /// with the Firebase UID string fails at the database with "invalid input
  /// syntax for type uuid".
  ///
  /// Cached against the UID it belongs to, so it cannot outlive the session
  /// that produced it.
  Future<String> resolveWorkerId() async {
    final currentUid = uid;
    final cached = _cachedWorkerId;
    if (cached != null && _cachedWorkerIdFor == currentUid) return cached;

    final row = await db
        .from('workers')
        .select('id')
        .eq('firebase_uid', currentUid)
        .single();
    _cachedWorkerIdFor = currentUid;
    return _cachedWorkerId = row['id'] as String;
  }

  /// Drops anything cached for the signed-in worker.
  ///
  /// Called on sign-out so nothing resolved for one account can be read by the
  /// next. [resolveWorkerId] is already safe on its own — this makes the
  /// intent explicit and gives a subclass one place to extend.
  void clearSessionCache() {
    _cachedWorkerId = null;
    _cachedWorkerIdFor = null;
  }

  /// Runs [action], mapping any thrown error onto an [AppFailure].
  Future<Result<T>> guard<T>(
    Future<T> Function() action, {
    required String operation,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final value = await action().timeout(timeout);
      return Ok(value);
    } on TimeoutException catch (error, stack) {
      _log.warning('$operation timed out');
      return Err(FailureMapper.from(error, stack));
    } catch (error, stack) {
      final failure = FailureMapper.from(error, stack);
      // Log the developer-facing detail; the worker sees failure.message.
      _log.error(
        '$operation failed',
        error: error,
        stackTrace: stack,
        context: {'failure': failure.runtimeType.toString()},
      );
      return Err(failure);
    }
  }

  /// A Realtime stream over one table, filtered to a single column value.
  ///
  /// [primaryKey] is required by the SDK to diff rows. The filter is mandatory
  /// rather than optional so that subscribing to everything is not something a
  /// caller can do by omission.
  Stream<List<Map<String, dynamic>>> watchRows({
    required String table,
    required List<String> primaryKey,
    required String filterColumn,
    required String filterValue,
  }) {
    return db
        .from(table)
        .stream(primaryKey: primaryKey)
        .eq(filterColumn, filterValue)
        .handleError((Object error, StackTrace stack) {
      // A dropped subscription must not take the screen down with it. The
      // stream surfaces the error, and the controller keeps the last good value
      // while showing a reconnecting state.
      _log.warning('Realtime stream error on $table: $error');
      throw FailureMapper.from(error, stack);
    });
  }

  /// Reads a platform setting, e.g. `payout.minimum_amount_minor`.
  ///
  /// Only settings marked public are readable by a client; the RLS policy
  /// decides, not this method.
  Future<T?> readSetting<T>(String key, T Function(Object) parse) async {
    try {
      final row = await db
          .from('platform_settings')
          .select('value')
          .eq('key', key)
          .maybeSingle();

      final value = row?['value'];
      return value == null ? null : parse(value);
    } catch (_) {
      // A missing or unreadable setting falls back to the caller's default.
      // This is configuration, not data: it cannot mislead a worker about
      // money or state.
      return null;
    }
  }
}

/// Thrown when an RPC returns something the app cannot interpret. Surfaces as a
/// [ServerFailure] rather than being silently absorbed.
class UnexpectedResponseException implements Exception {
  const UnexpectedResponseException(this.message);
  final String message;

  @override
  String toString() => 'UnexpectedResponseException: $message';
}
