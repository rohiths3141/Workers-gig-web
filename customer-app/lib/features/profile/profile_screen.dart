import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers/providers.dart';
import '../../app/providers/session_controller.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/language_picker.dart';
import '../../core/localization/l10n.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider).value;
    final customer = sessionState is SessionReady ? sessionState.customer : null;
    final authRepo = ref.watch(authRepositoryProvider);
    final locale = ref.watch(localeControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // User header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Text(
                        customer != null && customer.fullName.isNotEmpty
                            ? customer.fullName[0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer?.fullName ?? l10n.profileFallbackName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (customer?.phone != null && customer!.phone.isNotEmpty)
                            Text(
                              customer.phone,
                              style: const TextStyle(color: AppColors.inkSecondary, fontSize: 13),
                            ),
                          if (customer?.email != null)
                            Text(
                              customer!.email!,
                              style: const TextStyle(color: AppColors.inkSecondary, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                      tooltip: l10n.editProfileTitle,
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings options list
              _buildProfileOption(
                icon: Icons.translate_rounded,
                title: l10n.profileLanguage,
                subtitle: locale.nativeName,
                onTap: () => showLanguagePicker(context),
              ),
              _buildProfileOption(
                icon: Icons.location_on_outlined,
                title: l10n.profileAddresses,
                subtitle: l10n.profileAddressesSubtitle,
                onTap: () => context.push('/profile/addresses'),
              ),
              _buildProfileOption(
                icon: Icons.history,
                title: l10n.profileHistory,
                subtitle: l10n.profileHistorySubtitle,
                onTap: () => context.go('/bookings'),
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: l10n.profileSupport,
                subtitle: l10n.profileSupportSubtitle,
                onTap: () => context.push('/profile/support'),
              ),

              const SizedBox(height: 32),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await authRepo.signOut();
                    ref.read(sessionProvider.notifier).signOut();
                  },
                  icon: const Icon(Icons.logout, color: AppColors.statusError),
                  label: Text(
                    l10n.commonSignOut,
                    style: const TextStyle(
                      color: AppColors.statusError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.statusError),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.inkSecondary),
      ),
    );
  }
}
