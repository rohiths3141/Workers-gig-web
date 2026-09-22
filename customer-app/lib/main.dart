import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/config/app_config.dart';
import 'app/providers/providers.dart';
import 'app/providers/push_registration_provider.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/logging/app_logger.dart';
import 'core/supabase/supabase_client_provider.dart';

/// Firebase options for com.wervexa.app (Android).
/// Values sourced from google-services.json — safe to commit (public config).
const _androidOptions = FirebaseOptions(
  apiKey: 'AIzaSyBY68gchkPTlltTUt9oYhM0da9EVLK4Mz4',
  appId: '1:38879531950:android:fe21d05f1e085338536e3f',
  messagingSenderId: '38879531950',
  projectId: 'workers-gig',
  storageBucket: 'workers-gig.firebasestorage.app',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  const logger = AppLogger('Main');

  logger.info('Initializing Wervexa Customer App (${config.environment})...');

  // Initialize Firebase with explicit options — avoids dependency on
  // values.xml which is generated at build time from google-services.json.
  try {
    await Firebase.initializeApp(options: _androidOptions);
    await FirebaseInitializer.configurePostInit(config);
    logger.info('Firebase initialized successfully');
  } catch (e, st) {
    logger.error('Firebase initialization failed: $e', error: e, stackTrace: st);
  }

  // Initialize Supabase Client with Firebase ID token provider.
  // If credentials are missing (dev run without --dart-define) the client
  // is not initialized; the session resolves to SessionSignedOut so the
  // auth screen is shown and the rest of the app is not broken.
  if (config.isComplete) {
    try {
      await SupabaseClientProvider.initialize(
        config: config,
        idTokenProvider: () async => FirebaseAuth.instance.currentUser?.getIdToken(),
      );
      logger.info('Supabase initialized successfully');
    } catch (e, st) {
      logger.error('Supabase initialization failed: $e', error: e, stackTrace: st);
    }
  } else {
    logger.warning(
      'Supabase NOT initialized — missing keys: ${config.missingKeys.join(', ')}. '
      'Pass --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... to enable data features.',
    );
  }

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const WervexaCustomerApp(),
    ),
  );
}

class WervexaCustomerApp extends ConsumerWidget {
  const WervexaCustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    ref.watch(pushRegistrationProvider);

    return MaterialApp.router(
      title: 'Wervexa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
