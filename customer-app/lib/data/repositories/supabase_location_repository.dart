import 'dart:async';

import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/worker_location.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseLocationRepository extends SupabaseRepositoryBase
    implements LocationRepository {
  SupabaseLocationRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  static const _log = AppLogger('LocationRepo');

  @override
  Stream<WorkerLocation?> watchWorkerLocation(String bookingId) {
    final controller = StreamController<WorkerLocation?>();

    final subscription = db
        .from('worker_locations')
        .stream(primaryKey: ['id'])
        .eq('booking_id', bookingId)
        .order('recorded_at', ascending: false)
        .limit(1)
        .listen(
          (rows) {
            if (rows.isEmpty) {
              controller.add(null);
            } else {
              try {
                controller
                    .add(WorkerLocation.fromJson(rows.first as Map<String, dynamic>));
              } catch (e) {
                _log.warning('WorkerLocation parse error: $e');
              }
            }
          },
          onError: (error) => _log.error('watchWorkerLocation error', error: error),
        );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  @override
  Future<Result<WorkerLocation?>> getLatestWorkerLocation(
      String bookingId) =>
      guardNullable(() async {
        final rows = await db
            .from('worker_locations')
            .select()
            .eq('booking_id', bookingId)
            .order('recorded_at', ascending: false)
            .limit(1);

        if ((rows as List).isEmpty) return null;
        return WorkerLocation.fromJson(rows.first as Map<String, dynamic>);
      });
}
