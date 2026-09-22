import '../../core/errors/result.dart';
import '../../domain/entities/material_request.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseMaterialRepository extends SupabaseRepositoryBase
    implements MaterialRepository {
  SupabaseMaterialRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<MaterialRequest>>> getMaterialsForBooking(
          String bookingId) =>
      guard(() async {
        final rows = await db
            .from('materials')
            .select()
            .eq('booking_id', bookingId)
            .order('created_at', ascending: true);

        return (rows as List)
            .map((r) =>
                MaterialRequest.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  @override
  Stream<List<MaterialRequest>> watchMaterials(String bookingId) {
    return db
        .from('materials')
        .stream(primaryKey: ['id'])
        .eq('booking_id', bookingId)
        .order('created_at', ascending: true)
        .map((rows) => (rows as List)
            .map((r) =>
                MaterialRequest.fromJson(r as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<Result<MaterialRequest>> approveMaterial(String materialId) =>
      guard(() async {
        final row = await db
            .rpc('customer_approve_material',
                params: {'p_material_id': materialId})
            .single();
        return MaterialRequest.fromJson(row as Map<String, dynamic>);
      });

  @override
  Future<Result<MaterialRequest>> rejectMaterial(String materialId,
          {String? reason}) =>
      guard(() async {
        final row = await db
            .rpc('customer_reject_material', params: {
              'p_material_id': materialId,
              if (reason != null) 'p_reason': reason,
            })
            .single();
        return MaterialRequest.fromJson(row as Map<String, dynamic>);
      });
}
