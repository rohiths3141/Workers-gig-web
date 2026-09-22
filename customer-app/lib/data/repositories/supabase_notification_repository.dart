import 'dart:async';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseNotificationRepository extends SupabaseRepositoryBase
    implements NotificationRepository {
  SupabaseNotificationRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  static const _log = AppLogger('NotificationRepo');

  @override
  Future<void> registerPushToken(String token, String platform) async {
    await db.rpc('customer_register_push_token', params: {
      'p_token': token,
      'p_platform': platform,
    });
  }

  @override
  Stream<List<AppNotification>> watchNotifications() {
    final controller = StreamController<List<AppNotification>>();

    final subscription = db
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('channel', 'IN_APP')
        .order('queued_at', ascending: false)
        .listen(
          (rows) {
            try {
              controller.add(rows
                  .map((r) => AppNotification.fromJson(r))
                  .toList());
            } catch (e, st) {
              _log.error('watchNotifications parse error', error: e, stackTrace: st);
              controller.addError(e, st);
            }
          },
          onError: (Object error, StackTrace st) {
            _log.error('watchNotifications stream error', error: error, stackTrace: st);
            controller.addError(error, st);
          },
        );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  @override
  Future<void> markRead(String notificationId) async {
    await db
        .from('notifications')
        .update({'read_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', notificationId);
  }
}
