import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/config/app_config.dart';
import 'app/providers/providers.dart';
import 'app/providers/push_registration_provider.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/localization/app_locale.dart';
import 'core/supabase/supabase_client_provider.dart';
import 'data/repositories/firebase_auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();

  // Missing configuration fails visibly at launch rather than surfacing much
  // later as a confusing network error in front of a worker mid-job.
  if (!config.isComplete) {
    runApp(_ConfigurationError(missing: config.missingKeys));
    return;
  }

  await SystemChrome.setPreferredOrientations([
    // The app is used one-handed while standing. Landscape adds nothing and
    // makes every target harder to hit.
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await FirebaseInitializer.initialize(config);

    // Supabase authenticates every request with the current Firebase ID token, so
    // there is one session, held by Firebase, and nothing to keep in sync.
    final auth = FirebaseAuthRepository();
    await SupabaseClientProvider.initialize(
      config: config,
      idTokenProvider: () async {
        final result = await auth.idToken();
        return result.valueOrNull;
      },
    );

    runApp(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          // The same instance the Supabase client reads its token from, so there
          // is exactly one auth object in the process.
          authRepositoryProvider.overrideWithValue(auth),
        ],
        child: const WorkerApp(),
      ),
    );
  } catch (e) {
    runApp(_InitializationError(error: e));
  }
}

class WorkerApp extends ConsumerWidget {
  const WorkerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);
    ref.watch(pushRegistrationProvider);

    return MaterialApp.router(
      title: 'Wervexa Captain',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale.locale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Respects the worker's system text size, which many use turned up,
        // but stops a 2x setting from breaking every layout in the app.
        final scale = MediaQuery.textScalerOf(context).clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.4,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Shown when the app was built without the configuration it needs.
///
/// A developer-facing screen, but it fails loudly rather than letting a
/// misconfigured build reach a worker and appear to be broken at random.
class _ConfigurationError extends StatelessWidget {
  const _ConfigurationError({required this.missing});

  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings_outlined, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'This build is missing its configuration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pass these with --dart-define:\n\n${missing.join('\n')}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when Firebase or Supabase fails to initialize.
///
/// Catches the crash and shows it on screen instead of leaving the worker
/// staring at a white screen with no way to report what happened.
class _InitializationError extends StatelessWidget {
  const _InitializationError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'The app could not start.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
