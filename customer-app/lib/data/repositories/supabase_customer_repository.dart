import '../../core/errors/result.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseCustomerRepository extends SupabaseRepositoryBase
    implements CustomerRepository {
  const SupabaseCustomerRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<Customer?>> getCurrentCustomer() => guardNullable(() async {
        final row = await db
            .rpc('customer_get_profile')
            .maybeSingle();
        // customer_get_profile() returns public.customers (a single-row
        // type, not SETOF), so "no profile yet" comes back as a row of
        // all-null columns rather than as no row at all — treat a null id
        // as "does not exist" instead of trying to parse it as a Customer.
        if (row == null || row['id'] == null) return null;
        return Customer.fromJson(row as Map<String, dynamic>);
      });

  @override
  Future<Result<Customer?>> claimExistingAccount() => guardNullable(() async {
        // Like customer_get_profile, this returns public.customers, so
        // "nothing to claim" arrives as a row of all-null columns. The app
        // sends no phone number: the server matches the OTP-verified one on
        // the token, which is the only thing that makes this safe.
        final row = await db.rpc('customer_claim_account').maybeSingle();
        if (row == null || row['id'] == null) return null;
        return Customer.fromJson(row);
      });

  @override
  Future<Result<Customer>> createProfile({
    required String fullName,
    required String phone,
    String? email,
  }) =>
      guard(() async {
        final row = await db.rpc('customer_create_profile', params: {
          'p_full_name': fullName,
          'p_phone': phone,
          if (email != null) 'p_email': email,
        }).single();
        return Customer.fromJson(row as Map<String, dynamic>);
      });

  @override
  Future<Result<Customer>> updateProfile({
    required String fullName,
    String? email,
  }) =>
      guard(() async {
        final uid = currentFirebaseUid();
        if (uid == null) {
          throw StateError('Not signed in');
        }
        final row = await db
            .from('customers')
            .update({
              'full_name': fullName,
              'email': email,
            })
            .eq('firebase_uid', uid)
            .select()
            .single();
        return Customer.fromJson(row);
      });

  @override
  Future<Result<Customer>> updateLocation({
    required double latitude,
    required double longitude,
    String? city,
    String? state,
    String? pincode,
  }) =>
      guard(() async {
        final uid = currentFirebaseUid();
        if (uid == null) {
          throw StateError('Not signed in');
        }
        final row = await db
            .from('customers')
            .update({
              'latitude': latitude,
              'longitude': longitude,
              if (city != null) 'city': city,
              if (state != null) 'state': state,
              if (pincode != null) 'pincode': pincode,
            })
            .eq('firebase_uid', uid)
            .select()
            .single();
        return Customer.fromJson(row);
      });
}
