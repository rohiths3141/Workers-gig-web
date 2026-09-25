import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/localization/app_locale.dart';
import '../../core/logging/app_logger.dart';
import '../../core/maps/polyline_codec.dart';
import '../../core/money/money.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/repositories.dart';
import '../mappers/mappers.dart';
import 'supabase_repository_base.dart';

/// Jobs, offers and the booking lifecycle.
///
/// Every state change goes through `worker_advance_booking`, which delegates to
/// the platform's single state-machine writer. This app never writes
/// `bookings.status`, never decides whether a transition is legal, and never
/// treats a local optimistic update as truth: after any mutation the row is
/// re-read, so what the worker sees is what the database holds.
final class SupabaseJobRepository extends SupabaseRepositoryBase
    implements JobRepository {
  SupabaseJobRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('JobRepository'));

  /// Customer name and phone are selected, but RLS only returns them when this
  /// worker is assigned to the booking. Before assignment the embed comes back
  /// empty and the UI shows an approximate area instead.
  static const _columns = '''
    id, booking_code, status, service_id, gig_id, problem_description,
    scheduled_at, address_line, city, state, pincode, latitude, longitude,
    quoted_amount_minor, labour_amount_minor, material_amount_minor,
    platform_fee_minor, worker_amount_minor, final_amount_minor, currency,
    arrival_verified_at, accepted_at, confirmed_at, travel_started_at,
    arrived_at, work_started_at, completed_at, paid_at, cancelled_at,
    cancellation_reason, created_at,
    services(name, slug), customers(full_name, phone), worker_gigs(title)
  ''';

  /// Mirrors [BookingStatus.isActive]. AWAITING_APPROVAL is here, not under
  /// "Done": the work is finished but the customer has not approved it and no
  /// money has moved.
  static const _activeStatuses = [
    'ACCEPTED',
    'CONFIRMED',
    'TRAVELING',
    'ARRIVED',
    'IN_PROGRESS',
    'AWAITING_APPROVAL',
  ];


  @override
  Future<Result<PagedResult<Job>>> getJobs({
    required JobListFilter filter,
    int limit = 20,
    int offset = 0,
  }) =>
      guard(
        operation: 'getJobs(${filter.name})',
        () async {
          if (filter == JobListFilter.offers) {
            final offers = await _loadOffers();
            return PagedResult(
              items: offers.map((o) => o.job).toList(growable: false),
              hasMore: false,
            );
          }

          var query = db.from('bookings').select(_columns);

          query = switch (filter) {
            JobListFilter.active => query.inFilter('status', _activeStatuses),
            JobListFilter.upcoming =>
              query.inFilter('status', ['ACCEPTED', 'CONFIRMED']),
            JobListFilter.completed => query.inFilter(
                'status', ['COMPLETED', 'PAYMENT_PENDING', 'PAID', 'CLOSED']),
            JobListFilter.cancelled =>
              query.inFilter('status', ['CANCELLED', 'EXPIRED', 'DISPUTED']),
            JobListFilter.offers => query,
          };

          // One row beyond the page, so "has more" is known without a count
          // query over the worker's whole history.
          final rows = await query
              .order('created_at', ascending: false)
              .range(offset, offset + limit);

          final hasMore = rows.length > limit;
          final page = hasMore ? rows.sublist(0, limit) : rows;

          return PagedResult(
            items: page
                .map((r) => JobMapper.fromRow(Map<String, dynamic>.from(r)))
                .toList(growable: false),
            hasMore: hasMore,
          );
        },
      );

  @override
  Future<Result<Job>> getJob(String bookingId) => guard(
        operation: 'getJob',
        () async {
          final row =
              await db.from('bookings').select(_columns).eq('id', bookingId).single();
          return JobMapper.fromRow(row);
        },
      );

  @override
  Future<Result<List<JobEvent>>> getJobTimeline(String bookingId) => guard(
        operation: 'getJobTimeline',
        () async {
          final rows = await db
              .from('booking_events')
              .select('id, event_type, from_status, to_status, note, created_at')
              .eq('booking_id', bookingId)
              .order('created_at', ascending: true);

          return rows
              .map((r) => JobMapper.eventFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Future<Result<List<JobOffer>>> getOffers() =>
      guard(operation: 'getOffers', _loadOffers);

  Future<List<JobOffer>> _loadOffers() async {
    final windowMinutes =
        await readSetting<int>('offer.response_window_minutes', (v) => parseIntOr(v, 10)) ??
            10;

    // RLS on booking_match_candidates already restricts this to rows where
    // was_offered is true and the worker is this worker. The filters below make
    // the intent explicit and keep the payload small.
    final rows = await db
        .from('booking_match_candidates')
        .select('''
          id, rank, distance_km, offered_at, response,
          bookings!inner($_columns)
        ''')
        .eq('was_offered', true)
        .isFilter('response', null)
        .eq('bookings.status', 'REQUESTED')
        .order('offered_at', ascending: false);

    final window = Duration(minutes: windowMinutes);

    return rows
        .map((r) =>
            JobMapper.offerFromRow(Map<String, dynamic>.from(r), responseWindow: window))
        // An offer whose window has closed is not shown. Letting a worker tap
        // accept on something the server will refuse wastes their time and
        // reads as the app being broken.
        .where((offer) => !offer.isExpired)
        .toList(growable: false);
  }

  @override
  Stream<List<JobOffer>> watchOffers() async* {
    // The Realtime payload is the candidate row alone, without the embedded
    // booking, so an insert is a signal to re-read rather than data to render.
    // worker_id on this table is the workers.id UUID, not the Firebase UID.
    final workerId = await resolveWorkerId();

    // Same startup-race guard as watchWallet(): Realtime JWT can lag the HTTP
    // session; one retry after 2 s covers that without hiding real failures.
    Stream<List<JobOffer>> makeStream() => watchRows(
          table: 'booking_match_candidates',
          primaryKey: ['id'],
          filterColumn: 'worker_id',
          filterValue: workerId,
        ).asyncMap((_) => _loadOffers());

    var firstErrorSeen = false;
    try {
      await for (final event in makeStream()) {
        yield event;
      }
      return;
    } catch (_) {
      firstErrorSeen = true;
    }

    if (firstErrorSeen) {
      await Future<void>.delayed(const Duration(seconds: 2));
      yield* makeStream();
    }
  }

  @override
  Stream<Job> watchJob(String bookingId) {
    return watchRows(
      table: 'bookings',
      primaryKey: ['id'],
      filterColumn: 'id',
      filterValue: bookingId,
    ).asyncMap((rows) async {
      if (rows.isEmpty) {
        throw NotFoundFailure(message: AppStrings.current.jobOfferExpired);
      }
      // Re-read through the select with its joins: the Realtime row carries no
      // embedded service or customer.
      final row =
          await db.from('bookings').select(_columns).eq('id', bookingId).single();
      return JobMapper.fromRow(row);
    });
  }

  @override
  Future<Result<Job?>> getActiveJob() => guard(
        operation: 'getActiveJob',
        () async {
          final row = await db
              .from('bookings')
              .select(_columns)
              .inFilter('status', _activeStatuses)
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();

          // Null means no active job — a normal state, shown as an empty state.
          return row == null ? null : JobMapper.fromRow(row);
        },
      );

  @override
  Future<Result<Job>> acceptOffer(String bookingId) => guard(
        operation: 'acceptOffer',
        () async {
          // The server locks the booking before reading its state, so exactly
          // one of two racing workers wins. The loser gets a 23505, which the
          // mapper turns into a ConflictFailure and the UI renders as
          // "someone else took this job" rather than a generic error.
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_accept_offer',
            params: {'p_booking_id': bookingId},
          );

          // Re-read for the joins the RPC's bare row does not carry.
          final full = await db
              .from('bookings')
              .select(_columns)
              .eq('id', row['id'] as String)
              .single();

          return JobMapper.fromRow(full);
        },
      );

  @override
  Future<Result<void>> declineOffer(String bookingId, {String? reason}) => guard(
        operation: 'declineOffer',
        () async {
          await db.rpc<dynamic>(
            'worker_decline_offer',
            params: {'p_booking_id': bookingId, 'p_reason': reason},
          );
        },
      );

  @override
  Future<Result<Job>> advance(
    String bookingId,
    BookingStatus toStatus, {
    String? reason,
  }) =>
      guard(
        operation: 'advance(${toStatus.wire})',
        () async {
          await db.rpc<dynamic>(
            'worker_advance_booking',
            params: {
              'p_booking_id': bookingId,
              'p_to_status': toStatus.wire,
              'p_reason': reason,
            },
          );

          final row =
              await db.from('bookings').select(_columns).eq('id', bookingId).single();
          return JobMapper.fromRow(row);
        },
      );

  @override
  Future<Result<ArrivalVerification>> verifyArrival(
    String bookingId,
    String code,
  ) =>
      guard(
        operation: 'verifyArrival',
        () async {
          // The correct code is never sent to this device — RLS does not expose
          // bookings.arrival_code to the worker — so there is nothing here to
          // compare against and no way to shortcut the check. Whatever the
          // server returns is the answer, including a refusal.
          final json = await db.rpc<Map<String, dynamic>>(
            'worker_verify_arrival',
            params: {'p_booking_id': bookingId, 'p_code': code.trim()},
          );

          return ArrivalVerification(
            isVerified: json['verified'] == true,
            alreadyVerified: json['already_verified'] == true,
            attemptsRemaining: parseMinor(json['attempts_remaining']),
          );
        },
      );

  @override
  Future<Result<CompletionReadiness>> getCompletionReadiness(String bookingId) =>
      guard(
        operation: 'getCompletionReadiness',
        () async {
          final booking = await db
              .from('bookings')
              .select('arrival_verified_at')
              .eq('id', bookingId)
              .single();

          final media = await db
              .from('media_assets')
              .select('purpose')
              .eq('booking_id', bookingId)
              .eq('upload_status', 'COMPLETED')
              .isFilter('deleted_at', null);

          final purposes =
              media.map((m) => m['purpose'] as String?).whereType<String>().toSet();

          final pending = await db
              .from('materials')
              .select('id')
              .eq('booking_id', bookingId)
              .inFilter('status', ['REQUESTED', 'CUSTOMER_REVIEW']);

          return CompletionReadiness(
            isArrivalVerified: booking['arrival_verified_at'] != null,
            hasBeforeWorkEvidence: purposes.contains('BOOKING_BEFORE_WORK'),
            hasAfterWorkEvidence: purposes.contains('BOOKING_AFTER_WORK'),
            pendingMaterialCount: pending.length,
          );
        },
      );

  @override
  Future<Result<void>> rateCustomer({
    required String bookingId,
    required int rating,
    String? comment,
  }) =>
      guard(
        operation: 'rateCustomer',
        () async {
          await db.rpc<dynamic>(
            'worker_rate_customer',
            params: {
              'p_booking_id': bookingId,
              'p_rating': rating,
              'p_comment': comment,
            },
          );
        },
      );

  @override
  Future<Result<void>> updateLocation({
    required String bookingId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? speed,
  }) =>
      guard(
        operation: 'updateLocation',
        () async {
          await db.rpc<dynamic>(
            'worker_update_location',
            params: {
              'p_booking_id': bookingId,
              'p_latitude': latitude,
              'p_longitude': longitude,
              if (accuracy != null) 'p_accuracy': accuracy,
              if (heading != null) 'p_heading': heading,
              if (speed != null) 'p_speed': speed,
            },
          );
        },
      );

  @override
  Future<Result<RouteInfo>> computeRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) =>
      guard(
        operation: 'computeRoute',
        () async {
          final response = await db.functions.invoke(
            'compute-route',
            body: {
              'origin': {'latitude': originLat, 'longitude': originLng},
              'destination': {'latitude': destLat, 'longitude': destLng},
            },
          );

          final body = response.data as Map<String, dynamic>;
          if (body['error'] != null) {
            throw ServerFailure(debugDetail: body['error'] as String);
          }

          final encoded = body['encodedPolyline'] as String?;
          return RouteInfo(
            distanceMeters: (body['distanceMeters'] as num?)?.toInt(),
            durationSeconds: (body['durationSeconds'] as num?)?.toInt(),
            points: encoded == null ? const [] : decodePolyline(encoded),
          );
        },
      );
}

/// Materials, requested by the worker and approved by the customer.
///
/// There is deliberately no method here that sets a material to APPROVED. The
/// worker asks; the customer decides; the server keeps them apart.
final class SupabaseMaterialRepository extends SupabaseRepositoryBase
    implements MaterialRepository {
  SupabaseMaterialRepository(
    super.db, {
    required super.currentFirebaseUid,
  }) : super(logger: const AppLogger('MaterialRepository'));

  static const _columns = '''
    id, booking_id, name, description, quantity, unit, estimated_cost_minor,
    actual_cost_minor, currency, status, customer_rejection_reason, created_at
  ''';

  @override
  Future<Result<List<MaterialRequest>>> getMaterials(String bookingId) => guard(
        operation: 'getMaterials',
        () async {
          final rows = await db
              .from('materials')
              .select(_columns)
              .eq('booking_id', bookingId)
              .order('created_at', ascending: true);

          return rows
              .map((r) => JobMapper.materialFromRow(Map<String, dynamic>.from(r)))
              .toList(growable: false);
        },
      );

  @override
  Stream<List<MaterialRequest>> watchMaterials(String bookingId) {
    return watchRows(
      table: 'materials',
      primaryKey: ['id'],
      filterColumn: 'booking_id',
      filterValue: bookingId,
    ).map((rows) {
      final materials = rows
          .map((r) => JobMapper.materialFromRow(Map<String, dynamic>.from(r)))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return materials;
    });
  }

  @override
  Future<Result<MaterialRequest>> requestMaterial({
    required String bookingId,
    required String name,
    required double quantity,
    required String unit,
    required Money estimatedCost,
    String? description,
  }) =>
      guard(
        operation: 'requestMaterial',
        () async {
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_request_material',
            params: {
              'p_booking_id': bookingId,
              'p_name': name.trim(),
              'p_quantity': quantity,
              'p_unit': unit.trim(),
              'p_estimated_cost_minor': estimatedCost.minor,
              'p_description': description?.trim(),
            },
          );
          return JobMapper.materialFromRow(row);
        },
      );

  @override
  Future<Result<MaterialRequest>> recordActualCost({
    required String materialId,
    required Money actualCost,
  }) =>
      guard(
        operation: 'recordActualCost',
        () async {
          // The server refuses without a completed receipt upload attached to
          // this material. An unevidenced cost is an unrecoverable cost.
          final row = await db.rpc<Map<String, dynamic>>(
            'worker_record_material_cost',
            params: {
              'p_material_id': materialId,
              'p_actual_cost_minor': actualCost.minor,
            },
          );
          return JobMapper.materialFromRow(row);
        },
      );
}
