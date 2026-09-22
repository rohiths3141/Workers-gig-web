import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/domain/entities/booking.dart';
import 'package:wervexa_customer/domain/entities/customer.dart';
import 'package:wervexa_customer/domain/entities/customer_address.dart';
import 'package:wervexa_customer/domain/entities/material_request.dart';
import 'package:wervexa_customer/domain/entities/payment.dart';
import 'package:wervexa_customer/domain/entities/service_category.dart';
import 'package:wervexa_customer/domain/entities/service_problem.dart';
import 'package:wervexa_customer/domain/entities/service_request.dart';
import 'package:wervexa_customer/domain/entities/service_request_offer.dart';
import 'package:wervexa_customer/domain/entities/worker_location.dart';

import '../fixtures/live_shape_rows.dart';

/// Every `fromJson`, against rows shaped like the live database's.
///
/// The shapes come from `test/fixtures/live_shapes.json`, profiled from the
/// real tables through this app's own select lists. Two rows are built per
/// query: one with everything populated, and one with every nullable column
/// null — which is where these break, because a booking with no worker yet, no
/// final amount and no scheduled time is the normal state of a fresh request,
/// not an edge case.
void main() {
  final shapes = LiveShapes.load();

  void mapsLiveShapeOf(
    String query,
    Object? Function(Map<String, dynamic> row) map, {
    String? varying,
  }) {
    final skip = shapes.hasRows(query)
        ? null
        : 'The live $query table was empty when profile-app-data.mjs last ran, '
            'so there is no shape to check. Re-run it once this table has rows.';

    group(query, () {
      test('maps a fully populated row', () {
        expect(() => map(shapes.full(query)), returnsNormally);
      }, skip: skip);

      test('maps a row with every nullable column null', () {
        expect(
          () => map(shapes.sparse(query)),
          returnsNormally,
          reason:
              'A column that is null in the live $query table made this parse '
              'throw. Read it with a nullable cast or give it a default.',
        );
      }, skip: skip);

      if (varying != null) {
        test('maps every $varying the live table holds', () {
          for (final row in shapes.eachValueOf(query, varying)) {
            expect(() => map(row), returnsNormally,
                reason: '$varying=${row[varying]}');
          }
        }, skip: skip);
      }
    });
  }

  group('Entities survive live data shapes', () {
    mapsLiveShapeOf('bookings', Booking.fromJson, varying: 'status');
    mapsLiveShapeOf('booking_events', BookingEvent.fromJson);
    mapsLiveShapeOf('customers', Customer.fromJson, varying: 'status');
    mapsLiveShapeOf('customer_addresses', CustomerAddress.fromJson);
    mapsLiveShapeOf('services', ServiceCategory.fromJson);
    mapsLiveShapeOf('service_problems', ServiceProblem.fromJson);
    mapsLiveShapeOf('materials', MaterialRequest.fromJson, varying: 'status');
    mapsLiveShapeOf('payments', Payment.fromJson, varying: 'status');
    mapsLiveShapeOf('worker_locations', WorkerLocation.fromJson);
    mapsLiveShapeOf('customer_service_requests', ServiceRequest.fromJson,
        varying: 'status');
    mapsLiveShapeOf('service_request_offers', ServiceRequestOffer.fromJson,
        varying: 'status');
  });

  group('The profile itself is usable', () {
    test('the core tables were profiled with real rows', () {
      final empty = [
        for (final name in shapes.names)
          if (!shapes.hasRows(name)) name,
      ];
      printOnFailure('Profiled with no rows: $empty');
      expect(
        shapes.hasRows('bookings') && shapes.hasRows('services'),
        isTrue,
        reason: 'The core tables profiled empty — re-run profile-app-data.mjs '
            'against a database that has data in it.',
      );
    });
  });
}
