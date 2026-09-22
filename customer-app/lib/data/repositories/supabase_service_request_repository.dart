import 'dart:async';

import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseServiceRequestRepository extends SupabaseRepositoryBase
    implements ServiceRequestRepository {
  SupabaseServiceRequestRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  static const _log = AppLogger('ServiceRequestRepo');
  static const _table = 'customer_service_requests';

  @override
  Future<Result<ServiceRequest>> createServiceRequest({
    required String categoryId,
    required String title,
    required String description,
    required BudgetType budgetType,
    int? budgetMinMinor,
    int? budgetMaxMinor,
    required ScheduleType scheduleType,
    DateTime? scheduledDate,
    String? timeWindowStart,
    String? timeWindowEnd,
    required String addressLine,
    String? city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    String? additionalNotes,
  }) =>
      guard(() async {
        final row = await db
            .rpc('customer_create_service_request', params: {
              'p_category_id': categoryId,
              'p_title': title,
              'p_description': description,
              'p_budget_type': budgetType.wire,
              if (budgetMinMinor != null) 'p_budget_min_minor': budgetMinMinor,
              if (budgetMaxMinor != null) 'p_budget_max_minor': budgetMaxMinor,
              'p_schedule_type': scheduleType.wire,
              if (scheduledDate != null)
                'p_scheduled_date': scheduledDate.toIso8601String().split('T')[0],
              if (timeWindowStart != null) 'p_time_window_start': timeWindowStart,
              if (timeWindowEnd != null) 'p_time_window_end': timeWindowEnd,
              'p_address_line': addressLine,
              if (city != null) 'p_city': city,
              if (state != null) 'p_state': state,
              if (pincode != null) 'p_pincode': pincode,
              if (latitude != null) 'p_latitude': latitude,
              if (longitude != null) 'p_longitude': longitude,
              if (additionalNotes != null) 'p_additional_notes': additionalNotes,
            })
            .single();
        return _parseRow(row);
      });

  @override
  Future<Result<List<ServiceRequest>>> getMyServiceRequests() =>
      guard(() async {
        final rows = await db
            .from(_table)
            .select('''
              *, services!inner(name)
            ''')
            .order('created_at', ascending: false);

        return (rows as List).map((r) => _parseRow(r)).toList();
      });

  @override
  Stream<List<ServiceRequest>> watchMyServiceRequests() {
    final controller = StreamController<List<ServiceRequest>>();

    // Seed with current data.
    getMyServiceRequests().then((result) {
      result.fold(
        (requests) {
          if (!controller.isClosed) controller.add(requests);
        },
        (_) {},
      );
    });

    final subscription = db
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen(
          (rows) {
            try {
              final requests = (rows as List).map((r) => _parseRow(r)).toList();
              if (!controller.isClosed) controller.add(requests);
            } catch (e) {
              _log.warning('watchMyServiceRequests parse error',
                  {'error': e.toString()});
            }
          },
          onError: (error) {
            _log.error('watchMyServiceRequests stream error', error: error);
          },
        );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  @override
  Future<Result<ServiceRequest>> getServiceRequest(String requestId) =>
      guard(() async {
        final row = await db
            .from(_table)
            .select('''
              *, services!inner(name)
            ''')
            .eq('id', requestId)
            .single();
        return _parseRow(row);
      });

  @override
  Stream<ServiceRequest> watchServiceRequest(String requestId) {
    final controller = StreamController<ServiceRequest>();

    // Seed.
    getServiceRequest(requestId).then((result) {
      result.fold(
        (request) {
          if (!controller.isClosed) controller.add(request);
        },
        (_) {},
      );
    });

    final subscription = db
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('id', requestId)
        .listen(
          (rows) {
            if (rows.isNotEmpty) {
              try {
                final map = Map<String, dynamic>.from(rows.first as Map);
                map.putIfAbsent('category_name', () => '');
                controller.add(ServiceRequest.fromJson(map));
              } catch (e) {
                _log.warning('watchServiceRequest parse error',
                    {'error': e.toString()});
              }
            }
          },
          onError: (error) {
            _log.error('watchServiceRequest stream error', error: error);
          },
        );

    controller.onCancel = () => subscription.cancel();
    return controller.stream;
  }

  @override
  Future<Result<ServiceRequest>> cancelServiceRequest(String requestId) =>
      guard(() async {
        final row = await db
            .rpc('customer_cancel_service_request', params: {
              'p_request_id': requestId,
            })
            .single();
        return _parseRow(row);
      });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  ServiceRequest _parseRow(dynamic raw) {
    final map = Map<String, dynamic>.from(raw as Map);
    // Flatten joined service name.
    if (map['services'] is Map) {
      map['category_name'] = (map['services'] as Map)['name'];
    }
    map.putIfAbsent('category_name', () => '');
    return ServiceRequest.fromJson(map);
  }
}
