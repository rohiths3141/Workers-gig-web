import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../core/localization/l10n.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/bookings')) return 2;
    if (location.startsWith('/notifications')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        context.go('/bookings');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);
    final l10n = context.l10n;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.inkTertiary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore_rounded),
              label: l10n.navExplore,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_month_rounded),
              label: l10n.navBookings,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_outlined),
              activeIcon: const Icon(Icons.notifications_rounded),
              label: l10n.navAlerts,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_rounded),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
