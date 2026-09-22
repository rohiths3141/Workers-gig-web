import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/config/app_config.dart';
import '../logging/app_logger.dart';

/// Owns the Supabase connection for the Customer App.
///
/// Identical integration to the worker app: Firebase holds the session;
/// Supabase receives the Firebase ID token on every request. RLS on the
/// server side sees `auth.jwt()->>'sub'` as the Firebase UID and applies
/// the customer-scoped policies from migration 0009 and 0014.
class SupabaseClientProvider {
  SupabaseClientProvider._(this._client);

  static const _log = AppLogger('Supabase');

  final SupabaseClient _client;
  SupabaseClient get client => _client;

  static SupabaseClientProvider? _instance;

  static SupabaseClientProvider get instance {
    final provider = _instance;
    if (provider == null) {
      throw StateError('SupabaseClientProvider.initialize() has not run');
    }
    return provider;
  }

  static bool get isInitialized => _instance != null;

  static Future<SupabaseClientProvider> initialize({
    required AppConfig config,
    required Future<String?> Function() idTokenProvider,
  }) async {
    if (_instance != null) return _instance!;

    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
      accessToken: idTokenProvider,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.error,
      ),
      postgrestOptions: const PostgrestClientOptions(schema: 'public'),
      debug: config.isDevelopment,
    );

    _log.info('Supabase ready', {'environment': config.environment});

    _instance = SupabaseClientProvider._(Supabase.instance.client);
    return _instance!;
  }

  /// Drops all Realtime subscriptions on sign-out.
  Future<void> disposeChannels() async {
    await _client.removeAllChannels();
  }

  /// Pushes the current Firebase ID token into the Realtime client directly.
  ///
  /// The `accessToken` callback passed to Supabase.initialize() is resolved
  /// lazily by realtime_client on socket connect, and a channel's first
  /// `phx_join` can race ahead of that resolution — going out signed with
  /// the anon key instead of the caller's real token, so RLS-protected
  /// Realtime streams (notifications, live booking/location updates) fail
  /// with "permission denied ... GRANT SELECT ... TO anon" even though the
  /// caller is really signed in. Calling this proactively whenever the
  /// caller becomes signed in closes that race.
  Future<void> syncRealtimeAuth(String? idToken) async {
    try {
      await _client.realtime.setAuth(idToken);
    } catch (e) {
      _log.warning('Could not sync Realtime auth: $e');
    }
  }
}
