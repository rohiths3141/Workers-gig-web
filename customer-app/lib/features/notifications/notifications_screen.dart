import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers/providers.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/localization/l10n.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_none,
              title: l10n.notificationsEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                tileColor: item.isUnread ? AppColors.primary.withValues(alpha: 0.04) : null,
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    _getIconForTemplate(item.templateKey),
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: item.isUnread ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  item.body,
                  style: const TextStyle(fontSize: 12, color: AppColors.ink),
                ),
                trailing: Text(
                  _relativeTime(context, item.queuedAt),
                  style: const TextStyle(fontSize: 10, color: AppColors.inkSecondary),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                onTap: item.isUnread
                    ? () => ref.read(notificationRepositoryProvider).markRead(item.id)
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorState(
          message: l10n.notificationsLoadFailed,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
      ),
    );
  }

  IconData _getIconForTemplate(String templateKey) {
    if (templateKey.contains('booking')) return Icons.check_circle_outline;
    if (templateKey.contains('travel') || templateKey.contains('arriv')) return Icons.navigation_outlined;
    if (templateKey.contains('material')) return Icons.build_outlined;
    if (templateKey.contains('review') || templateKey.contains('complet')) return Icons.star_outline;
    if (templateKey.contains('payment')) return Icons.payments_outlined;
    return Icons.notifications_none;
  }

  String _relativeTime(BuildContext context, DateTime time) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 2) return l10n.timeYesterday;
    return DateFormat('d MMM', context.dateLocale).format(time);
  }
}
