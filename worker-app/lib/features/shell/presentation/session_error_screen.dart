import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/errors/app_failure.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../core/localization/l10n.dart';

/// The worker is authenticated but their profile could not be loaded.
///
/// This is the exact situation the previous application resolved by inventing a
/// verified profile with sample jobs and a fake wallet. It instead says what
/// happened and offers the two things that can help: retry, or sign out.
class SessionErrorScreen extends ConsumerWidget {
  const SessionErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).valueOrNull;
    final l10n = context.l10n;
    final failure = session is SessionError
        ? session.failure
        : UnexpectedFailure(message: l10n.sessionProfileLoadFailedRetry);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FailureView(
                failure: failure,
                onRetry: () =>
                    ref.read(sessionProvider.notifier).refresh(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () =>
                        ref.read(sessionProvider.notifier).refresh(),
                    child: Text(l10n.commonTryAgain),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () =>
                        ref.read(sessionProvider.notifier).signOut(),
                    child: Text(l10n.commonSignOut),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
