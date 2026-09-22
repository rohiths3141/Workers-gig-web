import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/app_locale.dart';
import '../../../shared/widgets/common_widgets.dart';

/// Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SectionHeader(title: 'Language'),
          AppCard(
            padding: EdgeInsets.zero,
            // The selected value and the change handler moved onto the group
            // in Flutter 3.32; each tile now only names the value it stands
            // for.
            child: RadioGroup<AppLocale>(
              groupValue: locale,
              onChanged: (selected) {
                if (selected == null) return;
                ref.read(localeControllerProvider.notifier).setLocale(selected);
              },
              child: Column(
                children: [
                  for (final option in AppLocale.values)
                    RadioListTile<AppLocale>(
                      value: option,
                      title: Text(option.nativeName),
                      subtitle: Text(
                        // Honest about coverage. A language that is only
                        // partly translated says so, rather than leaving the
                        // worker to discover half the app is still English.
                        option.isFullyTranslated
                            ? option.englishName
                            : '${option.englishName} · partly translated',
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          const SectionHeader(title: 'About'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of service'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _open('https://wervexa.example/terms'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy policy'),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                  onTap: () => _open('https://wervexa.example/privacy'),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.support_agent_rounded),
                  title: const Text('Help and support'),
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
            label: const Text('Sign out'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => _deleteAccount(context),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete my account'),
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
    final confirmed = await confirmAction(
      context,
      title: 'Sign out?',
      message: 'You will need your phone number and a code to sign back in.',
      confirmLabel: 'Sign out',
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
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete your account'),
        content: Text(
          'Deleting an account affects your job history, your earnings records and any open payments, so it is handled by our support team rather than automatically.\n\n'
          'Raise a support request and we will confirm once it is done.',
          style: AppTypography.bodyMedium
              .copyWith(color: dialogContext.inkSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(Routes.support);
            },
            child: const Text('Contact support'),
          ),
        ],
      ),
    );
  }
}
