import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';

/// Shown while the session is resolving at startup.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The artwork is baked onto a white background, so the screen stays white
    // in both themes to avoid a visible plate behind it.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Flexible(
                flex: 12,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Image.asset(
                    'assets/images/splash_workers.png',
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Wervexa',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Home services, done right.',
                style: TextStyle(
                  color: AppColors.inkSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
