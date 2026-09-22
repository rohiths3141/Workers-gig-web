/// Build-time configuration.
///
/// Every value arrives through `--dart-define`, so nothing that identifies an
/// environment is committed. The Supabase anon key is public by design — it
/// authorizes nothing on its own, because RLS resolves the caller from the
/// Firebase ID token. The service role key exists only on the server and has no
/// business being in a mobile binary; there is deliberately no field for it.
class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.apiBaseUrl,
    required this.environment,
    required this.enableCrashReporting,
    required this.enableAnalytics,
  });

  factory AppConfig.fromEnvironment() {
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
      environment: environment,
      // Off in development so a debugging session does not pollute production
      // dashboards, and so nothing is reported before consent is meaningful.
      enableCrashReporting: bool.fromEnvironment(
        'ENABLE_CRASH_REPORTING',
        defaultValue: environment != 'development',
      ),
      enableAnalytics: bool.fromEnvironment(
        'ENABLE_ANALYTICS',
        defaultValue: environment != 'development',
      ),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;

  /// The trusted web tier. Used for the operations Supabase cannot do directly:
  /// minting signed Supabase Storage URLs, and confirming an upload landed.
  final String apiBaseUrl;

  final String environment;
  final bool enableCrashReporting;
  final bool enableAnalytics;

  bool get isProduction => environment == 'production';
  bool get isDevelopment => environment == 'development';

  /// Missing configuration must fail loudly at startup rather than surface much
  /// later as a confusing network error in front of a worker.
  List<String> get missingKeys => [
        if (supabaseUrl.isEmpty) 'SUPABASE_URL',
        if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
        if (apiBaseUrl.isEmpty) 'API_BASE_URL',
      ];

  bool get isComplete => missingKeys.isEmpty;
}
