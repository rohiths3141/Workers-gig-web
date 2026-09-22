import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/config/app_config.dart';
import '../logging/app_logger.dart';

/// Owns the Supabase connection.
///
/// Supabase is used for business data, Realtime and RPC — never for auth and
/// never for storage. Identity comes from Firebase, and Supabase is configured
/// for Third-Party Auth against the same Firebase project, so
/// `auth.jwt()->>'sub'` is the Firebase UID and RLS applies to every row this
/// client reads.
///
/// The `accessToken` callback below is the whole integration: the SDK asks for
/// a token before each request, and we hand it the current Firebase ID token.
/// There is no second session to keep in sync and nothing to expire
/// independently of Firebase.
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

  /// [idTokenProvider] returns the current Firebase ID token, or null when the
  /// worker is signed out. It is called on every request, so it must be cheap:
  /// the Firebase SDK caches the token and refreshes it only when it is close
  /// to expiry.
  static Future<SupabaseClientProvider> initialize({
    required AppConfig config,
    required Future<String?> Function() idTokenProvider,
  }) async {
    if (_instance != null) return _instance!;

    await Supabase.initialize(
      url: config.supabaseUrl,
      // The publishable (anon) key. Public by design: it authorizes nothing
      // on its own, because RLS resolves the caller from the Firebase token.
      publishableKey: config.supabaseAnonKey,
      accessToken: idTokenProvider,
      // The app's own auth state lives in Firebase. Supabase must not try to
      // persist or restore a session of its own.
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        // A worker on a train loses signal constantly. Log noise from every
        // reconnect is not useful.
        logLevel: RealtimeLogLevel.error,
      ),
      postgrestOptions: const PostgrestClientOptions(schema: 'public'),
      debug: config.isDevelopment,
    );

    _log.info('Supabase ready', {'environment': config.environment});

    _instance = SupabaseClientProvider._(Supabase.instance.client);
    return _instance!;
  }

  /// Drops every Realtime subscription. Called on sign-out so a signed-out
  /// device stops receiving another session's events.
  Future<void> disposeChannels() async {
    await _client.removeAllChannels();
  }

  /// Pushes the current Firebase ID token into the Realtime client directly.
  ///
  /// The `accessToken` callback passed to Supabase.initialize() is resolved
  /// lazily by realtime_client on socket connect, and a channel's first
  /// `phx_join` can race ahead of that resolution — going out signed with
  /// the anon key instead of the caller's real token, so RLS-protected
  /// Realtime streams fail even though the caller is really signed in.
  /// Calling this proactively whenever the caller becomes signed in closes
  /// that race.
  Future<void> syncRealtimeAuth(String? idToken) async {
    try {
      await _client.realtime.setAuth(idToken);
    } catch (e) {
      _log.warning('Could not sync Realtime auth: $e');
    }
  }
}
