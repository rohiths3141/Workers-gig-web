import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Shown when the app has no backend configuration at all (missing
/// SUPABASE_URL / SUPABASE_ANON_KEY --dart-define values). This is a
/// development/deployment problem, distinct from a normal network error —
/// the app must say so plainly rather than pretending to be usable.
class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings_suggest_outlined, color: Colors.white, size: 56),
              const SizedBox(height: 20),
              const Text(
                'App not configured',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'This build is missing SUPABASE_URL and SUPABASE_ANON_KEY. '
                'Run with:\n\n'
                '--dart-define-from-file=dart-defines.env\n\n'
                'so the app can reach the real backend.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
