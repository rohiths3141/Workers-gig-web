import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers/providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../domain/entities/support.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../core/localization/l10n.dart';

final notificationsProvider =
    StreamProvider.autoDispose<List<AppNotification>>((ref) {
  return ref.watch(notificationRepositoryProvider).watchNotifications();
});

/// The notification centre.
///
/// Reads `public.notifications` and nothing else. The previous application
/// displayed four hardcoded entries with no backend behind them, which meant
/// the screen said the same thing to every worker forever; there is no seed
/// data here and no way to render a notification the server did not send.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeNotifications),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllRead();
              ref.invalidate(notificationsProvider);
            },
            child: Text(context.l10n.notificationsMarkAllRead),
          ),
        ],
      ),
      body: AsyncValueView<List<AppNotification>>(
        value: notifications,
        onRetry: () => ref.invalidate(notificationsProvider),
        loading: const ListSkeleton(itemHeight: 80),
        onData: (items) {
          if (items.isEmpty) {
            return EmptyStateView(
              icon: Icons.notifications_none_rounded,
              title: context.l10n.notificationsEmpty,
              message: context.l10n.notificationsEmptyBody,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, index) {
              final notification = items[index];
              return _NotificationTile(
                notification: notification,
                onTap: () async {
                  await ref
                      .read(notificationRepositoryProvider)
                      .markRead(notification.id);
                  ref.invalidate(notificationsProvider);

                  final target = notification.deepLinkTarget;
                  if (target != null && context.mounted) context.push(target);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (notification.category) {
      NotificationCategory.job => (Icons.work_outline_rounded, AppColors.primary),
      NotificationCategory.material =>
        (Icons.inventory_2_outlined, AppColors.warning),
      NotificationCategory.payment =>
        (Icons.payments_outlined, AppColors.earnings),
      NotificationCategory.payout =>
        (Icons.arrow_outward_rounded, AppColors.earnings),
      NotificationCategory.verification =>
        (Icons.verified_outlined, AppColors.info),
      NotificationCategory.support =>
        (Icons.support_agent_rounded, AppColors.info),
      NotificationCategory.system =>
        (Icons.info_outline_rounded, AppColors.inkTertiary),
    };

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor:
          notification.isRead ? null : AppColors.primarySurface.withValues(alpha: 0.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: context.ink,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    )),
                const SizedBox(height: AppSpacing.xxs),
                Text(notification.body,
                    style: AppTypography.bodySmall
                        .copyWith(color: context.inkSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat('d MMM, h:mm a').format(notification.createdAt),
                  style: AppTypography.bodySmall
                      .copyWith(color: context.inkTertiary),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
