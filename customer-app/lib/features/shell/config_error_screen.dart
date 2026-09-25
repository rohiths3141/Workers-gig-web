import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/l10n.dart';

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
              Text(
                context.l10n.configErrorTitle,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.configErrorBody(
                  'SUPABASE_URL, SUPABASE_ANON_KEY',
                  '--dart-define-from-file=dart-defines.env',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
