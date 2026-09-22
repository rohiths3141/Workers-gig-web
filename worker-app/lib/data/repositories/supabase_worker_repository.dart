import 'dart:io';

import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/gig.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/support.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';
import 'supabase_repository_base.dart';

/// The worker's own profile.
///
/// Reads go straight to PostgREST because RLS already limits every row to the
/// caller. Writes are split: the handful of columns the database grants a
/// worker `update` on are written directly, and everything else goes through an
/// RPC. The split is not a style choice — the grant in migration 0009 lists
/// exactly which columns a client may touch, and status, the verification flags,
/// rating and the restriction columns are not among them.
final class SupabaseWorkerRepository extends SupabaseRepositoryBase
    implements WorkerRepository {
  SupabaseWorkerRepository(
    super.db, {
    required super.currentFirebaseUid,
    required MediaRepository media,
  })  : _media = media,
        super(logger: const AppLogger('WorkerRepository'));

  final MediaRepository _media;

  static const _columns = '''
    id, firebase_uid, worker_code, full_name, phone, email, status, availability,
    primary_service_id, experience_years, bio, city, state, pincode, gender, address_line,
    latitude, longitude, service_radius_km, rating_avg, rating_count,
    jobs_completed, jobs_cancelled, is_kyc_verified, is_qualification_verified,
    is_skill_verified, is_background_verified, is_insured, verified_at,
    restriction_reason, created_at, updated_at
  ''';


  @override
  Future<Result<Worker?>> getCurrentWorker() => guard(
        operation: 'getCurrentWorker',
        () async {
          final row = await db
              .from('workers')
              .select(_columns)
              .eq('firebase_uid', uid)
              .maybeSingle();

          // Null is a real, expected answer: the Firebase account exists but
          // registration has not finished. It is not a failure, and it must not
          // be turned into an empty Worker.
          if (row == null) return null;

          final photoUrl = await _profilePhotoUrl(row['id'] as String);
          return WorkerMapper.fromRow(row, profilePhotoUrl: photoUrl);
        },
      );

  @override
  Stream<Worker> watchCurrentWorker() {
    return watchRows(
      table: 'workers',
      primaryKey: ['id'],
      filterColumn: 'firebase_uid',
      filterValue: uid,
    ).asyncMap((rows) async {
      if (rows.isEmpty) {
        throw const NotFoundFailure(message: 'Your profile could not be loaded.');
      }
      final row = rows.first;
      // The avatar is not a column on workers, so mapping the Realtime row
      // straight through dropped it and the worker's own photo blinked back to
      // their initials on every unrelated profile change.
      final photoUrl = await _profilePhotoUrl(row['id'] as String);
      return WorkerMapper.fromRow(row, profilePhotoUrl: photoUrl);
    });
  }

  @override
  Future<Result<Worker?>> claimExistingAccount() => guard(
        operation: 'claimExistingAccount',
        () async {
          // Returns the workers row, or SQL NULL when this caller's verified
          // number owns nothing. The server decides — the app sends no phone
          // number, so there is nothing here a client could claim with.
          final row = await db.rpc<dynamic>('worker_claim_account');
          if (row is! Map) return null;

          final map = Map<String, dynamic>.from(row);
          if (map['id'] == null) return null;

          final photoUrl = await _profilePhotoUrl(map['id'] as String);
          return WorkerMapper.fromRow(map, profilePhotoUrl: photoUrl);
        },
      );

  @override
  Future<Result<Worker>> createProfile({
    required String fullName,
    required String phone,
    String? email,
  }) =>
      guard(
        operation: 'createProfile',
        () async {
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_create_profile',
            params: {
              'p_full_name': fullName.trim(),
              'p_phone': phone.trim(),
              'p_email': email?.trim(),
            },
          );
          return WorkerMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Worker>> updateProfile({
    String? bio,
    int? experienceYears,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
    String? gender,
  }) =>
      guard(
        operation: 'updateProfile',
        () async {
          final patch = <String, dynamic>{
            if (bio != null) 'bio': bio.trim(),
            if (experienceYears != null) 'experience_years': experienceYears,
            if (addressLine != null) 'address_line': addressLine.trim(),
            if (city != null) 'city': city.trim(),
            if (state != null) 'state': state.trim(),
            if (pincode != null) 'pincode': pincode.trim(),
            if (gender != null) 'gender': gender,
          };

          if (patch.isEmpty) {
            throw const UnexpectedResponseException('Nothing to update');
          }

          final row = await db
              .from('workers')
              .update(patch)
              .eq('firebase_uid', uid)
              .select(_columns)
              .single();

          return WorkerMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Worker>> updateServiceArea({
    required double latitude,
    required double longitude,
    required double radiusKm,
    String? city,
    String? pincode,
  }) =>
      guard(
        operation: 'updateServiceArea',
        () async {
          if (latitude < -90 || latitude > 90) {
            throw const ValidationFailure(
                message: 'That location does not look right.');
          }
          if (longitude < -180 || longitude > 180) {
            throw const ValidationFailure(
                message: 'That location does not look right.');
          }
          if (radiusKm <= 0 || radiusKm > 100) {
            throw const ValidationFailure(
                message: 'Choose a travel distance between 1 and 100 km.');
          }

          final row = await db
              .from('workers')
              .update({
                'latitude': latitude,
                'longitude': longitude,
                'service_radius_km': radiusKm,
                if (city != null) 'city': city.trim(),
                if (pincode != null) 'pincode': pincode.trim(),
              })
              .eq('firebase_uid', uid)
              .select(_columns)
              .single();

          return WorkerMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Worker>> setPrimaryService(String serviceId) => guard(
        operation: 'setPrimaryService',
        () async {
          // primary_service_id is not in the client update grant, so this is an
          // RPC: choosing a trade has consequences for matching, and the server
          // decides whether the worker may claim it.
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_set_primary_service',
            params: {'p_service_id': serviceId},
          );
          return WorkerMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Worker>> updateProfilePhoto(File image) async {
    // The upload is a stream of progress states; the profile is only updated
    // once the server has confirmed the object actually landed.
    UploadTask? finished;

    await for (final task in _media.upload(
      file: image,
      purpose: MediaPurpose.workerProfilePhoto,
    )) {
      if (task.state == UploadState.failed) {
        return Err(UploadFailure(
          message: task.failure ?? 'That photo could not be uploaded.',
          isResumable: true,
        ));
      }
      if (task.state == UploadState.completed) finished = task;
    }

    if (finished?.mediaAssetId == null) {
      return const Err(UploadFailure(
        message: 'That photo could not be uploaded. Try again.',
        isResumable: true,
      ));
    }

    return getCurrentWorker().then(
      (result) => result.flatMap(
        (worker) => worker == null
            ? const Err(NotFoundFailure(message: 'Your profile could not be loaded.'))
            : Ok(worker),
      ),
    );
  }

  @override
  Future<Result<List<WorkerSkill>>> getSkills() => guard(
        operation: 'getSkills',
        () async {
          final rows = await db
              .from('worker_services')
              .select('service_id, is_approved, approved_at, services(name, slug)')
              .order('created_at', ascending: true);

          return rows
              .map((r) => WorkerMapper.skillFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<WorkerSkill>> requestSkill(String serviceId) => guard(
        operation: 'requestSkill',
        () async {
          // Arrives unapproved. Selecting a regulated trade is a request, and
          // the server is the one that decides whether it is granted.
          await db.rpc<dynamic>(
            'worker_request_service',
            params: {'p_service_id': serviceId},
          );

          final row = await db
              .from('worker_services')
              .select('service_id, is_approved, approved_at, services(name, slug)')
              .eq('service_id', serviceId)
              .single();

          return WorkerMapper.skillFromRow(row);
        },
      );

  @override
  Future<Result<EarningsSummary>> getEarningsSummary() => guard(
        operation: 'getEarningsSummary',
        () async {
          // Aggregated in the database rather than by pulling the whole ledger
          // to the device and adding it up: a worker with two years of history
          // should not download all of it to see today's total.
          final json = await db.rpc<Map<String, dynamic>>('worker_earnings_summary');

          return EarningsSummary(
            today: parseMoneyOrZero(json['today_minor']),
            thisWeek: parseMoneyOrZero(json['week_minor']),
            thisMonth: parseMoneyOrZero(json['month_minor']),
            lifetime: parseMoneyOrZero(json['lifetime_minor']),
          );
        },
      );

  @override
  Future<Result<RatingSummary>> getRatingSummary() => guard(
        operation: 'getRatingSummary',
        () async {
          final row = await db
              .from('workers')
              .select('rating_avg, rating_count')
              .eq('firebase_uid', uid)
              .single();

          final count = parseIntOr(row['rating_count'], 0);

          final distribution = <int, int>{};
          if (count > 0) {
            final ratings = await db
                .from('ratings')
                .select('rating')
                .eq('rater_type', 'CUSTOMER')
                .eq('is_hidden', false);

            for (final r in ratings) {
              final value = parseIntOr(r['rating'], 0);
              if (value >= 1 && value <= 5) {
                distribution[value] = (distribution[value] ?? 0) + 1;
              }
            }
          }

          return RatingSummary(
            // Null, not 0.0. An unrated worker is unrated, not terrible.
            average: parseDouble(row['rating_avg']),
            count: count,
            distribution: distribution,
          );
        },
      );

  @override
  Future<Result<List<Rating>>> getRatings({int limit = 20, int offset = 0}) =>
      guard(
        operation: 'getRatings',
        () async {
          final rows = await db
              .from('ratings')
              .select(
                  'id, booking_id, rating, comment, rater_type, created_at, bookings(booking_code, services(name))')
              .eq('rater_type', 'CUSTOMER')
              .eq('is_hidden', false)
              .order('created_at', ascending: false)
              .range(offset, offset + limit - 1);

          return rows
              .map((r) => RatingMapper.fromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  Future<String?> _profilePhotoUrl(String workerId) async {
    try {
      final row = await db
          .from('media_assets')
          .select('id')
          .eq('worker_id', workerId)
          .eq('purpose', 'WORKER_PROFILE_PHOTO')
          .eq('upload_status', 'COMPLETED')
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      final mediaId = row?['id'] as String?;
      if (mediaId == null) return null;

      final signed = await _media.signedUrl(mediaId);
      return signed.valueOrNull;
    } catch (_) {
      // A missing avatar is a cosmetic problem. It must not stop the profile
      // from loading, and the UI falls back to initials.
      return null;
    }
  }
}

/// Availability, kept separate from the profile because it is a different kind
/// of operation: it is gated on eligibility the server computes, and its
/// failure carries a task list rather than a message.
final class SupabaseAvailabilityRepository extends SupabaseRepositoryBase
    implements AvailabilityRepository {
  SupabaseAvailabilityRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('AvailabilityRepository'));

  @override
  Future<Result<WorkerEligibility>> getEligibility() => guard(
        operation: 'getEligibility',
        () async {
          final json = await db.rpc<Map<String, dynamic>>('worker_eligibility');
          return WorkerMapper.eligibilityFromJson(json);
        },
      );

  @override
  Future<Result<WorkerEligibility>> setAvailability(
    WorkerAvailability value,
  ) async {
    final result = await guard(
      operation: 'setAvailability',
      () async {
        final json = await db.rpc<Map<String, dynamic>>(
          'worker_set_availability',
          params: {'p_availability': value.wire},
        );

        final eligibility = json['eligibility'];
        if (eligibility is! Map) {
          throw const UnexpectedResponseException('No eligibility in response');
        }
        return WorkerMapper.eligibilityFromJson(
            Map<String, dynamic>.from(eligibility));
      },
    );

    // A refusal is not the end of the interaction. The server put the reasons
    // in the exception detail; the failure mapper lifted them out, and the UI
    // renders them as steps the worker can act on.
    return result;
  }
}

/// The platform service catalogue.
final class SupabaseCatalogueRepository extends SupabaseRepositoryBase
    implements CatalogueRepository {
  SupabaseCatalogueRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('CatalogueRepository'));

  static const _columns =
      'id, name, slug, short_description, icon_key, required_verifications, base_visit_fee_minor';

  @override
  Future<Result<List<ServiceCategory>>> getServices() => guard(
        operation: 'getServices',
        () async {
          final rows = await db
              .from('services')
              .select(_columns)
              .eq('is_active', true)
              .order('display_order', ascending: true)
              .order('name', ascending: true);

          return rows
              .map((r) => ServiceMapper.fromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<ServiceCategory>> getService(String serviceId) => guard(
        operation: 'getService',
        () async {
          final row =
              await db.from('services').select(_columns).eq('id', serviceId).single();
          return ServiceMapper.fromRow(row);
        },
      );
}
