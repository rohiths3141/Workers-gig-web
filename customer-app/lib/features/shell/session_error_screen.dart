import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../core/errors/result.dart';
import '../../core/localization/l10n.dart';

/// The customer is signed in but their profile could not be loaded.
///
/// Sending them back to the phone screen made a transient backend or clock
/// problem look like a sign-out, with no explanation and a fresh OTP to get
/// through. This says what happened and offers the two things that help.
class SessionErrorScreen extends ConsumerWidget {
  const SessionErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionProvider).valueOrNull;
    final failure = session is SessionError
        ? session.failure
        : UnexpectedFailure(message: l10n.sessionProfileLoadFailedRetry);
    final isClockSkew = failure is ClockSkewFailure;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                isClockSkew
                    ? Icons.schedule_rounded
                    : Icons.cloud_off_rounded,
                size: 56,
                color: AppColors.statusError,
              ),
              const SizedBox(height: 20),
              Text(
                isClockSkew ? l10n.sessionCheckClock : l10n.sessionProfileLoadFailed,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                failure.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.inkSecondary),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => ref.read(sessionProvider.notifier).refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.commonTryAgain,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(sessionProvider.notifier).signOut(),
                child: Text(l10n.commonSignOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
