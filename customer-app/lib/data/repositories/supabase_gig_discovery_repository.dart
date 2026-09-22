import '../../core/errors/result.dart';
import '../../domain/entities/gig_card.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseGigDiscoveryRepository extends SupabaseRepositoryBase
    implements GigDiscoveryRepository {
  const SupabaseGigDiscoveryRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<GigCard>>> findGigs({
    required String serviceId,
    required double latitude,
    required double longitude,
    double radiusKm = 25,
  }) =>
      guard(() async {
        // ignore: avoid_print
        print('[FindGigs] calling RPC: serviceId=$serviceId lat=$latitude lng=$longitude radius=$radiusKm');
        final rows = await db.rpc('customer_find_gigs', params: {
          'p_service_id': serviceId,
          'p_latitude': latitude,
          'p_longitude': longitude,
          'p_radius_km': radiusKm,
        });
        // ignore: avoid_print
        print('[FindGigs] RPC returned ${(rows as List).length} rows');
        return (rows as List)
            .map((r) => GigCard.fromJson(r as Map<String, dynamic>))
            .toList();
      });
}
