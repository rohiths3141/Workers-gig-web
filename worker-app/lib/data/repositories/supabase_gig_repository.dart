import 'dart:io';

import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/gig.dart';
import '../../domain/entities/media.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';
import 'supabase_repository_base.dart';

/// The worker's gigs.
///
/// A worker holds as many gigs as their approved trades allow. There is no
/// count check anywhere in this class, no `if (gigs.isNotEmpty) disableCreate`,
/// and no assumption that a worker has one trade. Where the business wants a
/// ceiling it is a `platform_settings` row the server reads — absent by
/// default, and never a hardcoded client rule.
final class SupabaseGigRepository extends SupabaseRepositoryBase
    implements GigRepository {
  SupabaseGigRepository(
    super.db, {
    required super.currentFirebaseUid,
    required MediaRepository media,
  })  : _media = media,
        super(logger: const AppLogger('GigRepository'));

  final MediaRepository _media;

  static const _columns = '''
    id, worker_id, service_id, title, description, status, price_minor, currency,
    pricing_unit, estimated_duration_minutes, service_radius_km, rejection_reason,
    submitted_at, reviewed_at, jobs_completed, created_at, updated_at,
    services(name, slug)
  ''';


  @override
  Future<Result<List<Gig>>> getMyGigs() => guard(
        operation: 'getMyGigs',
        () async {
          // Filtered to this worker explicitly. RLS alone is not enough: the
          // worker_gigs_active_read policy lets every authenticated user read
          // every ACTIVE gig (customers browse them), so without this filter
          // other workers' live gigs appeared here as the worker's own.
          // Archived gigs are excluded from the list but not deleted: past
          // bookings still point at them.
          final workerId = await resolveWorkerId();
          final rows = await db
              .from('worker_gigs')
              .select(_columns)
              .eq('worker_id', workerId)
              .neq('status', 'ARCHIVED')
              // Explicit: postgrest's order() defaults to DESCENDING, and a
              // bare call reads like ascending to whoever writes the next one.
              .order('status', ascending: false)
              .order('created_at', ascending: false);

          return rows
              .map((r) => GigMapper.fromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Stream<List<Gig>> watchMyGigs() {
    return db
        .from('worker_gigs')
        .stream(primaryKey: ['id'])
        .asyncMap((_) async {
          // Same explicit worker filter as getMyGigs().
          final workerId = await resolveWorkerId();
          final rows = await db
              .from('worker_gigs')
              .select(_columns)
              .eq('worker_id', workerId)
              .neq('status', 'ARCHIVED')
              .order('created_at', ascending: false);

          return rows
              .map((r) => GigMapper.fromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        });
  }

  @override
  Future<Result<Gig>> getGig(String gigId) => guard(
        operation: 'getGig',
        () async {
          final row =
              await db.from('worker_gigs').select(_columns).eq('id', gigId).single();
          return GigMapper.fromRow(row);
        },
      );

  @override
  Future<Result<List<ServiceCategory>>> getAvailableCategories() => guard(
        operation: 'getAvailableCategories',
        () async {
          // Only trades this worker is approved for, plus their primary trade.
          // Offering anything else in the picker would invite a refusal the
          // worker cannot understand or act on.
          final approved = await db
              .from('worker_services')
              .select('service_id')
              .eq('is_approved', true);

          final worker = await db
              .from('workers')
              .select('primary_service_id')
              .eq('firebase_uid', uid)
              .maybeSingle();

          final ids = <String>{
            ...approved.map((r) => r['service_id'] as String),
            if (worker?['primary_service_id'] is String)
              worker!['primary_service_id'] as String,
          };

          if (ids.isEmpty) return const <ServiceCategory>[];

          final rows = await db
              .from('services')
              .select(
                  'id, name, slug, short_description, icon_key, required_verifications, base_visit_fee_minor')
              .inFilter('id', ids.toList())
              .eq('is_active', true)
              .order('name', ascending: true);

          return rows
              .map((r) => ServiceMapper.fromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<Gig>> saveDraft(GigDraft draft) => _upsert(draft, submit: false);

  @override
  Future<Result<Gig>> publish(GigDraft draft) => _upsert(draft, submit: true);

  Future<Result<Gig>> _upsert(GigDraft draft, {required bool submit}) => guard(
        operation: submit ? 'publishGig' : 'saveGigDraft',
        () async {
          // Validate locally first so the worker gets field-level errors rather
          // than one server message. The check constraints on worker_gigs say
          // the same thing, and the server has the final word either way.
          final errors = draft.validate();
          if (submit && errors.isNotEmpty) {
            throw ValidationFailure(
              message: errors.values.first,
              fieldErrors: errors,
            );
          }

          final row = await db.rpc<Map<String, dynamic>>(
            'worker_upsert_gig',
            params: {
              'p_gig_id': draft.id,
              'p_service_id': draft.serviceId,
              'p_title': draft.title.trim(),
              'p_description': draft.description.trim().isEmpty
                  ? null
                  : draft.description.trim(),
              'p_price_minor': draft.priceMinor,
              'p_pricing_unit': draft.pricingUnit.wire,
              'p_estimated_duration_minutes': draft.estimatedDurationMinutes,
              'p_service_radius_km': draft.serviceRadiusKm,
              'p_submit': submit,
            },
          );

          final full = await db
              .from('worker_gigs')
              .select(_columns)
              .eq('id', row['id'] as String)
              .single();

          return GigMapper.fromRow(full);
        },
      );

  @override
  Future<Result<Gig>> pause(String gigId) =>
      _setStatus(gigId, GigStatus.paused, 'pauseGig');

  @override
  Future<Result<Gig>> resume(String gigId) =>
      _setStatus(gigId, GigStatus.active, 'resumeGig');

  @override
  Future<Result<Gig>> archive(String gigId) =>
      _setStatus(gigId, GigStatus.archived, 'archiveGig');

  Future<Result<Gig>> _setStatus(
    String gigId,
    GigStatus status,
    String operation,
  ) =>
      guard(
        operation: operation,
        () async {
          await db.rpc<dynamic>(
            'worker_set_gig_status',
            params: {'p_gig_id': gigId, 'p_status': status.wire},
          );

          final row =
              await db.from('worker_gigs').select(_columns).eq('id', gigId).single();
          return GigMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Gig>> addPhoto(String gigId, File image) async {
    UploadTask? finished;

    await for (final task in _media.upload(
      file: image,
      purpose: MediaPurpose.workerProfilePhoto,
      gigId: gigId,
    )) {
      if (task.state == UploadState.failed) {
        return Err(UploadFailure(
          message: task.failure ?? 'That photo could not be uploaded.',
          isResumable: true,
        ));
      }
      if (task.state == UploadState.completed) finished = task;
    }

    if (finished == null) {
      return const Err(UploadFailure(
        message: 'That photo could not be uploaded. Try again.',
        isResumable: true,
      ));
    }

    return getGig(gigId);
  }
}
