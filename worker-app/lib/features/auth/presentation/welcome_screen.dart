import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/brand_logo.dart';

/// The product introduction.
///
/// Four short promises, not a four-slide carousel a worker has to swipe
/// through every time. It is shown only when signed out; there is no "show
/// again on launch" behaviour.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _promises = [
    (
      Icons.work_outline_rounded,
      'Get suitable work',
      'Jobs near you, matched to the trades you actually offer.'
    ),
    (
      Icons.verified_outlined,
      'Prove your skills',
      'Your ITI and diploma certificates, verified once and shown to every customer.'
    ),
    (
      Icons.timeline_rounded,
      'Track every job',
      'From accepting a job to finishing it, with photo records at each step.'
    ),
    (
      Icons.account_balance_wallet_outlined,
      'Get paid securely',
      'Every rupee recorded, with a clear statement and withdrawals on your terms.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // The list is taller than the fold, and with the button sitting
            // flush underneath it the last promise was cut mid-word with
            // nothing to say it continued. The fade marks the edge.
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xxxl),
                        // The full lockup, on the one screen that introduces
                        // the product rather than getting on with the work.
                        const BrandLogo(width: 168),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Work that finds you',
                            style: AppTypography.displayLarge
                                .copyWith(color: context.ink)),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Wervexa connects skilled professionals with customers who need them.',
                          style: AppTypography.bodyLarge
                              .copyWith(color: context.inkSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        for (final (icon, title, body) in _promises)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSpacing.xl),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: context.surfaceMuted,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Icon(icon,
                                      size: 22, color: AppColors.primary),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(title,
                                          style: AppTypography.titleMedium
                                              .copyWith(color: context.ink)),
                                      const SizedBox(height: AppSpacing.xxs),
                                      Text(body,
                                          style: AppTypography.bodyMedium
                                              .copyWith(
                                                  color: context.inkSecondary)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: AppSpacing.xxxl,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              context.surface.withValues(alpha: 0),
                              context.surface,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () => context.push(Routes.auth),
                    child: const Text('Get started'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'We will send a one-time code to your mobile number.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkTertiary),
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
