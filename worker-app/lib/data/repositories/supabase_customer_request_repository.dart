import '../../core/errors/result.dart';
import '../../domain/entities/customer_service_request.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseCustomerRequestDiscoveryRepository
    extends SupabaseRepositoryBase
    implements CustomerRequestDiscoveryRepository {
  SupabaseCustomerRequestDiscoveryRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<CustomerServiceRequest>>> findEligibleRequests({
    required double latitude,
    required double longitude,
    double radiusKm = 15,
  }) =>
      guard(
        () async {
          final rows = await db.rpc(
            'worker_find_eligible_requests',
            params: {
              'p_latitude': latitude,
              'p_longitude': longitude,
              'p_radius_km': radiusKm,
            },
          );
          return (rows as List)
              .map((r) => CustomerServiceRequest.fromJson(
                  Map<String, dynamic>.from(r as Map)))
              .toList();
        },
        operation: 'findEligibleRequests',
      );

  @override
  Future<Result<CustomerServiceRequest>> getRequest(String requestId) =>
      guard(
        () async {
          final row = await db
              .from('customer_service_requests')
              .select('''
                *, services!inner(name)
              ''')
              .eq('id', requestId)
              .single();
          final map = Map<String, dynamic>.from(row);
          if (map['services'] is Map) {
            map['category_name'] = (map['services'] as Map)['name'];
          }
          map.putIfAbsent('category_name', () => '');
          return CustomerServiceRequest.fromJson(map);
        },
        operation: 'getRequest',
      );
}
