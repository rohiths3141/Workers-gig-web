/// Build-time configuration via --dart-define.
///
/// Identical pattern to the worker app. The Supabase anon key is public by
/// design; the service role key never appears in a mobile binary.
class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.apiBaseUrl,
    required this.razorpayKeyId,
    required this.environment,
    required this.enableCrashReporting,
    required this.enableAnalytics,
  });

  factory AppConfig.fromEnvironment() {
    const environment =
        String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return const AppConfig(
      supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
      // Razorpay's key ID (not the secret) — safe to embed, same as any
      // payment SDK's publishable key. The secret lives only on the web
      // tier that creates orders and verifies signatures.
      razorpayKeyId: String.fromEnvironment('RAZORPAY_KEY_ID'),
      environment: environment,
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

  /// The trusted web tier for signed Supabase Storage URLs and other
  /// server-mediated operations (including Razorpay order creation/verification).
  final String apiBaseUrl;

  final String razorpayKeyId;

  final String environment;
  final bool enableCrashReporting;
  final bool enableAnalytics;

  bool get isProduction => environment == 'production';
  bool get isDevelopment => environment == 'development';

  List<String> get missingKeys => [
        if (supabaseUrl.isEmpty) 'SUPABASE_URL',
        if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
      ];

  bool get isComplete => missingKeys.isEmpty;
}
