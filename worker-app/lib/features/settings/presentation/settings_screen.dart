import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/language_picker.dart';

/// Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          SectionHeader(title: l10n.settingsLanguage),
          // Every language listed carries every string in the app — the l10n
          // completeness test fails the build otherwise — so there is no
          // "partly translated" caveat left to show here.
          const AppCard(
            padding: EdgeInsets.zero,
            child: LanguageList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          SectionHeader(title: l10n.settingsAbout),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.settingsTerms),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _open('https://wervexa.example/terms'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.settingsPrivacy),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _open('https://wervexa.example/privacy'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.support_agent_rounded),
                  title: Text(l10n.settingsHelp),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(Routes.support),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          OutlinedButton.icon(
            onPressed: () => _signOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.commonSignOut),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => _deleteAccount(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.settingsDeleteAccount),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await confirmAction(
      context,
      title: l10n.settingsSignOutTitle,
      message: l10n.settingsSignOutBody,
      confirmLabel: l10n.commonSignOut,
    );
    if (!confirmed) return;
    await ref.read(sessionProvider.notifier).signOut();
  }

  /// Account deletion.
  ///
  /// Deliberately not a local wipe. Deleting the account here would orphan the
  /// worker's bookings and ledger entries, and give them no way to confirm
  /// anything actually happened. It is a real request that operations process,
  /// and until that workflow exists this says so plainly rather than showing a
  /// button that only clears the phone.
  Future<void> _deleteAccount(BuildContext context) async {
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteTitle),
        content: Text(
          l10n.settingsDeleteBody,
          style: AppTypography.bodyMedium
              .copyWith(color: dialogContext.inkSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(Routes.support);
            },
            child: Text(l10n.settingsContactSupport),
          ),
        ],
      ),
    );
  }
}
