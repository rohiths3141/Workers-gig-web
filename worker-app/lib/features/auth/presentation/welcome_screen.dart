import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/language_picker.dart';
import '../../../core/localization/l10n.dart';

/// The product introduction.
///
/// Four short promises, not a four-slide carousel a worker has to swipe
/// through every time. It is shown only when signed out; there is no "show
/// again on launch" behaviour.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static List<(IconData, String, String)> _promises(AppLocalizations l10n) => [
        (
          Icons.work_outline_rounded,
          l10n.welcomePromiseWorkTitle,
          l10n.welcomePromiseWorkBody,
        ),
        (
          Icons.verified_outlined,
          l10n.welcomePromiseSkillsTitle,
          l10n.welcomePromiseSkillsBody,
        ),
        (
          Icons.timeline_rounded,
          l10n.welcomePromiseTrackTitle,
          l10n.welcomePromiseTrackBody,
        ),
        (
          Icons.account_balance_wallet_outlined,
          l10n.welcomePromisePaidTitle,
          l10n.welcomePromisePaidBody,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                        // First thing on the first screen: a worker who cannot
                        // read English has to be able to switch before
                        // anything else.
                        const Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: LanguageButton(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // The full lockup, on the one screen that introduces
                        // the product rather than getting on with the work.
                        const BrandLogo(width: 168),
                        const SizedBox(height: AppSpacing.xl),
                        Text(l10n.welcomeHeadline,
                            style: AppTypography.displayLarge
                                .copyWith(color: context.ink)),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.welcomeSubtitle,
                          style: AppTypography.bodyLarge
                              .copyWith(color: context.inkSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        for (final (icon, title, body) in _promises(l10n))
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
                    child: Text(l10n.welcomeGetStarted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.welcomeCodeNotice,
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
