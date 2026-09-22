import 'dart:async';

import 'package:flutter/widgets.dart' show AppLifecycleListener;

import '../../core/errors/result.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/repositories.dart';
import 'supabase_repository_base.dart';

final class SupabaseBookingRepository extends SupabaseRepositoryBase
    implements BookingRepository {
  SupabaseBookingRepository(
    super.db, {
    required super.currentFirebaseUid,
  });

  static const _log = AppLogger('BookingRepo');

  @override
  Future<Result<Booking>> createBooking({
    required String gigId,
    required String problemDescription,
    required String addressLine,
    required String city,
    String? state,
    String? pincode,
    double? latitude,
    double? longitude,
    DateTime? scheduledAt,
    String? notes,
  }) =>
      guard(() async {
        final row = await db.rpc('customer_create_booking', params: {
          'p_gig_id': gigId,
          'p_problem_description': problemDescription,
          'p_address_line': addressLine,
          'p_city': city,
          if (state != null) 'p_state': state,
          if (pincode != null) 'p_pincode': pincode,
          if (latitude != null) 'p_latitude': latitude,
          if (longitude != null) 'p_longitude': longitude,
          if (scheduledAt != null)
            // .toUtc() matters: a local DateTime serialises without an offset,
            // and timestamptz then reads it as UTC. A 9:00 AM booking reached
            // the worker's app as 2:30 PM.
            'p_scheduled_at': scheduledAt.toUtc().toIso8601String(),
          if (notes != null) 'p_notes': notes,
        }).single();
        return Booking.fromJson(row as Map<String, dynamic>);
      });

  @override
  Future<Result<List<Booking>>> getMyBookings() =>
      guard(() async {
        final rows = await db
            .from('bookings')
            .select(
              '''
              id, booking_code, customer_id, service_id, status,
              problem_description, address_line, city, state, pincode,
              quoted_amount_minor, final_amount_minor, currency,
              worker_id, scheduled_at, latitude, longitude, customer_notes,
              created_at, completed_at, cancelled_at, cancellation_reason,
              services!inner(name),
              workers(full_name, phone, rating_avg)
              ''',
            )
            .order('created_at', ascending: false);

        return (rows as List).map((r) {
          return Booking.fromJson(_flatten(r as Map));
        }).toList();
      });

  @override
  Future<Result<Booking>> getBooking(String bookingId) =>
      guard(() async {
        final row = await db
            .from('bookings')
            .select(
              '''
              id, booking_code, customer_id, service_id, status,
              problem_description, address_line, city, state, pincode,
              quoted_amount_minor, final_amount_minor, currency,
              worker_id, scheduled_at, latitude, longitude, customer_notes,
              created_at, completed_at, cancelled_at, cancellation_reason,
              services!inner(name),
              workers(full_name, phone, rating_avg)
              ''',
            )
            .eq('id', bookingId)
            .single();

        return Booking.fromJson(_flatten(row as Map));
      });

  /// Folds the embedded service and worker rows into the flat shape
  /// [Booking.fromJson] reads. The worker embed is what puts a name and a
  /// phone number on the tracking screen: without it the customer saw the
  /// service name where the person should be, and the call button was dead.
  Map<String, dynamic> _flatten(Map<dynamic, dynamic> row) {
    final map = Map<String, dynamic>.from(row);

    final service = map['services'];
    if (service is Map) map['service_name'] = service['name'];

    final worker = map['workers'];
    if (worker is Map) {
      map['worker_name'] = worker['full_name'];
      map['worker_phone'] = worker['phone'];
      map['worker_rating'] = worker['rating_avg'];
    }

    return map;
  }

  @override
  Stream<Booking> watchBooking(String bookingId) {
    final controller = StreamController<Booking>();

    // A realtime row is the bare bookings record: no joined service name, no
    // worker name. Rather than patch those back in field by field, every
    // change is a signal to re-read the full row, so what the screen shows is
    // always a complete booking.
    Future<void> reload() async {
      final result = await getBooking(bookingId);
      result.fold(
        (booking) {
          if (!controller.isClosed) controller.add(booking);
        },
        (_) {},
      );
    }

    reload();

    final subscription = db
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', bookingId)
        .listen(
          (rows) {
            if (rows.isNotEmpty) reload();
          },
          onError: (error) {
            _log.error('watchBooking stream error', error: error);
          },
        );

    // Realtime drops while the app is in the background, and nothing replays
    // what was missed. Coming back to a booking that moved on while the
    // customer was in another app used to show the old status indefinitely.
    final lifecycle = AppLifecycleListener(onResume: reload);

    controller.onCancel = () {
      lifecycle.dispose();
      return subscription.cancel();
    };
    return controller.stream;
  }

  @override
  Stream<List<BookingEvent>> watchBookingEvents(String bookingId) {
    return db
        .from('booking_events')
        .stream(primaryKey: ['id'])
        .eq('booking_id', bookingId)
        .order('created_at', ascending: true)
        .map((rows) => (rows as List)
            .map((r) => BookingEvent.fromJson(r as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<Result<Booking>> approveCompletion(String bookingId) =>
      guard(() async {
        final row = await db
            .rpc('customer_approve_completion', params: {
              'p_booking_id': bookingId,
            })
            .single();
        final map = Map<String, dynamic>.from(row as Map);
        map.putIfAbsent('service_name', () => '');
        return Booking.fromJson(map);
      });

  @override
  Future<Result<Booking>> cancelBooking(String bookingId,
      {String? reason}) =>
      guard(() async {
        final row = await db
            .rpc('customer_cancel_booking', params: {
              'p_booking_id': bookingId,
              if (reason != null) 'p_reason': reason,
            })
            .single();
        final map = Map<String, dynamic>.from(row as Map);
        map.putIfAbsent('service_name', () => '');
        return Booking.fromJson(map);
      });

  @override
  Future<Result<String>> getArrivalCode(String bookingId) =>
      guard(() async {
        final code = await db.rpc('customer_get_arrival_code', params: {
          'p_booking_id': bookingId,
        });
        return code as String;
      });
}
