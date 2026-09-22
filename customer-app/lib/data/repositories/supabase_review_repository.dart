import '../../core/errors/result.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseReviewRepository extends SupabaseRepositoryBase
    implements ReviewRepository {
  SupabaseReviewRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<void>> rateWorker({
    required String bookingId,
    required int rating,
    String? comment,
  }) =>
      guard(() async {
        await db.rpc('customer_rate_worker', params: {
          'p_booking_id': bookingId,
          'p_rating': rating,
          if (comment != null && comment.trim().isNotEmpty) 'p_comment': comment.trim(),
        });
      });
}
