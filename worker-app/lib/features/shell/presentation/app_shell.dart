import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/l10n.dart';

/// The four-tab shell.
///
/// Home, Jobs, Wallet, Profile. Four, not ten: a worker glancing at this while
/// holding a drill needs to hit the right one without looking, and every extra
/// destination makes the others smaller and harder to hit. Notifications live
/// in the top bar, support inside Profile.
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static List<(String, IconData, IconData, String)> _destinations(
          AppLocalizations l10n) =>
      [
        (Routes.home, Icons.home_outlined, Icons.home_rounded, l10n.navHome),
        (Routes.jobs, Icons.work_outline_rounded, Icons.work_rounded, l10n.navJobs),
        (
          Routes.wallet,
          Icons.account_balance_wallet_outlined,
          Icons.account_balance_wallet_rounded,
          l10n.navWallet
        ),
        (
          Routes.profile,
          Icons.person_outline_rounded,
          Icons.person_rounded,
          l10n.navProfile
        ),
      ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final destinations = _destinations(context.l10n);
    final index = destinations.indexWhere((d) => location.startsWith(d.$1));

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(destinations[i].$1),
        // 64dp keeps every tab comfortably above the 48dp floor once the label
        // is accounted for.
        height: 64 + AppSpacing.sm,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final (_, icon, selectedIcon, label) in destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selectedIcon),
              label: label,
            ),
        ],
      ),
    );
  }
}
