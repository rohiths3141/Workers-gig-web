import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers/session_controller.dart';
import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/localization/l10n.dart';
import '../../../domain/entities/support.dart';
import '../../../domain/entities/worker.dart';
import '../../../shared/widgets/common_widgets.dart';
import 'profile_controller.dart';

/// The worker's profile and everything reached from it.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final worker = ref.watch(currentWorkerProvider);
    final rating = ref.watch(ratingSummaryProvider).valueOrNull;

    if (worker == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navProfile),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          _ProfileHeader(worker: worker, rating: rating),
          const SizedBox(height: AppSpacing.lg),

          if (worker.profileCompletion < 1) ...[
            AppCard(
              onTap: () => context.push(Routes.editProfile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelledProgress(
                    label: l10n.profileCompleteness,
                    value: worker.profileCompletion,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.profileCompletenessBody,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: l10n.profileJobsDone,
                    value: '${worker.jobsCompleted}',
                  ),
                ),
                Container(width: 1, height: 36, color: context.border),
                Expanded(
                  child: _Stat(
                    label: l10n.profileRating,
                    // Unrated is "—", never 0.0. Zero reads as terrible; the
                    // truth is simply that nobody has rated them yet.
                    value: rating?.hasRatings ?? false
                        ? rating!.average!.toStringAsFixed(1)
                        : '—',
                  ),
                ),
                Container(width: 1, height: 36, color: context.border),
                Expanded(
                  child: _Stat(
                    label: l10n.profileExperience,
                    value: worker.experienceYears == 0
                        ? '—'
                        : l10n.profileExperienceYears('${worker.experienceYears}'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _MenuGroup(
            items: [
              _MenuItem(
                icon: Icons.person_outline_rounded,
                label: l10n.profileEdit,
                onTap: () => context.push(Routes.editProfile),
              ),
              _MenuItem(
                icon: Icons.storefront_outlined,
                label: l10n.gigsTitle,
                onTap: () => context.push(Routes.gigs),
              ),
              _MenuItem(
                icon: Icons.verified_outlined,
                label: l10n.verificationTitle,
                onTap: () => context.push(Routes.verification),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _MenuGroup(
            items: [
              _MenuItem(
                icon: Icons.notifications_none_rounded,
                label: l10n.homeNotifications,
                onTap: () => context.push(Routes.notifications),
              ),
              _MenuItem(
                icon: Icons.support_agent_rounded,
                label: l10n.settingsHelp,
                onTap: () => context.push(Routes.support),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: l10n.settingsTitle,
                onTap: () => context.push(Routes.settings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // The worker code is what support will ask for, so it is shown where
          // they can read it out rather than buried in a debug screen.
          Center(
            child: Text(
              worker.workerCode,
              style: AppTypography.bodySmall.copyWith(color: context.inkTertiary),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.worker, this.rating});

  final Worker worker;
  final RatingSummary? rating;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          WorkerAvatar(
            name: worker.fullName,
            photoUrl: worker.profilePhotoUrl,
            size: 64,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker.fullName,
                    style:
                        AppTypography.titleLarge.copyWith(color: context.ink)),
                const SizedBox(height: AppSpacing.xxs),
                Text(formatIndianPhone(worker.phone),
                    style: AppTypography.bodyMedium
                        .copyWith(color: context.inkSecondary)),
                const SizedBox(height: AppSpacing.sm),
                // Only shown when the server says the worker is verified.
                if (worker.isKycVerified && worker.isBackgroundVerified)
                  StatusBadge(
                    label: context.l10n.profileVerified,
                    color: AppColors.success,
                    icon: Icons.verified_rounded,
                  )
                else
                  StatusBadge(
                    label: context.l10n.profileNotVerified,
                    color: AppColors.warning,
                    icon: Icons.info_outline_rounded,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTypography.headlineMedium.copyWith(color: context.ink)),
        const SizedBox(height: AppSpacing.xxs),
        Text(label,
            style:
                AppTypography.bodySmall.copyWith(color: context.inkSecondary)),
      ],
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(height: 1, indent: 56, color: context.border),
          ],
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Comfortably above the 48dp floor.
      minVerticalPadding: AppSpacing.lg,
      leading: Icon(icon, color: context.inkSecondary),
      title: Text(label,
          style: AppTypography.bodyLarge.copyWith(color: context.ink)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

/// "9292929292" or "+919292929292" -> "+91 92929 29292". Anything that isn't a
/// 10-digit Indian mobile number is shown unchanged.
String formatIndianPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  final local = digits.length == 12 && digits.startsWith('91')
      ? digits.substring(2)
      : digits;
  if (local.length != 10) return raw;
  return '+91 ${local.substring(0, 5)} ${local.substring(5)}';
}
