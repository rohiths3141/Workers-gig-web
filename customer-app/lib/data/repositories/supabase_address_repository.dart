import '../../core/errors/result.dart';
import '../../domain/entities/customer_address.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseAddressRepository extends SupabaseRepositoryBase
    implements AddressRepository {
  const SupabaseAddressRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<CustomerAddress>>> getAddresses() =>
      guard(() async {
        final rows = await db
            .from('customer_addresses')
            .select()
            .order('is_default', ascending: false)
            .order('created_at', ascending: true);

        return (rows as List)
            .map((r) => CustomerAddress.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Result<CustomerAddress>> upsertAddress({
    String? addressId,
    required String label,
    required String addressLine,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) =>
      guard(() async {
        final row = await db.rpc('customer_upsert_address', params: {
          if (addressId != null) 'p_address_id': addressId,
          'p_label': label,
          'p_address_line': addressLine,
          if (city != null) 'p_city': city,
          if (state != null) 'p_state': state,
          if (pincode != null) 'p_pincode': pincode,
          if (latitude != null) 'p_latitude': latitude,
          if (longitude != null) 'p_longitude': longitude,
          'p_is_default': isDefault,
        }).single();
        return CustomerAddress.fromJson(row as Map<String, dynamic>);
      });

  @override
  Future<Result<void>> deleteAddress(String addressId) =>
      guard(() async {
        await db.rpc('customer_delete_address', params: {
          'p_address_id': addressId,
        });
      });
}
