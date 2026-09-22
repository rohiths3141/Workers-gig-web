import '../../core/errors/result.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_problem.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseCatalogueRepository extends SupabaseRepositoryBase
    implements CatalogueRepository {
  const SupabaseCatalogueRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  @override
  Future<Result<List<ServiceCategory>>> getServices() =>
      guard(() async {
        final rows = await db
            .from('services')
            .select('id, name, slug, description, short_description, icon_key, display_order')
            .eq('is_active', true)
            .order('display_order', ascending: true);

        return (rows as List)
            .map((r) => ServiceCategory.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Result<List<ServiceProblem>>> getServiceProblems(String serviceId) =>
      guard(() async {
        final rows = await db
            .from('service_problems')
            .select('id, service_id, title, description')
            .eq('service_id', serviceId)
            .order('display_order', ascending: true);

        return (rows as List)
            .map((r) => ServiceProblem.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<Result<List<ServiceProblem>>> getAllServiceProblems() =>
      guard(() async {
        // No service filter. The row-level policy on service_problems already
        // limits this to problems belonging to an active service, so the
        // unfiltered read returns the same catalogue the per-service call
        // would, without needing to know the service first.
        final rows = await db
            .from('service_problems')
            .select('id, service_id, title, description')
            .order('display_order', ascending: true);

        return (rows as List)
            .map((r) => ServiceProblem.fromJson(r as Map<String, dynamic>))
            .toList();
      });
}
