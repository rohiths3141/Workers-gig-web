import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/data/mappers/mappers.dart';

import '../fixtures/live_shape_rows.dart';

/// Every mapper, against rows shaped like the live database's.
///
/// The shapes come from `test/fixtures/live_shapes.json`, profiled from the
/// real tables through this app's own select lists. Two rows are built per
/// query: one with everything populated, and one with every nullable column
/// null — which is where mappers actually fail, because a column that is null
/// on every row in production tends to be non-null in whoever wrote the test's
/// imagination.
void main() {
  final shapes = LiveShapes.load();

  /// Runs [map] over the full and sparse shapes of [query], and over one row
  /// per recorded value of [varying] so every status is exercised.
  void mapsLiveShapeOf(
    String query,
    Object? Function(Map<String, dynamic> row) map, {
    String? varying,
  }) {
    // A table with no rows yet profiles to no columns, and asserting against
    // the empty row that produces would only measure the fixture. Skipping says
    // so out loud instead of passing — or failing — for the wrong reason.
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
              'A column that is null in the live $query table made this mapper '
              'throw. Read it with a nullable cast or give it a default.',
        );
      }, skip: skip);

      if (varying != null) {
        test('maps every $varying the live table holds', () {
          for (final row in shapes.eachValueOf(query, varying)) {
            expect(() => map(row), returnsNormally, reason: '$varying=${row[varying]}');
          }
        }, skip: skip);
      }
    });
  }

  group('Mappers survive live data shapes', () {
    mapsLiveShapeOf('workers', WorkerMapper.fromRow, varying: 'status');
    mapsLiveShapeOf('services', ServiceMapper.fromRow);
    mapsLiveShapeOf('bookings', JobMapper.fromRow, varying: 'status');
    mapsLiveShapeOf('worker_gigs', GigMapper.fromRow, varying: 'status');
    mapsLiveShapeOf('wallets', WalletMapper.fromRow);
    mapsLiveShapeOf('worker_verifications', VerificationMapper.fromRow,
        varying: 'status');
    mapsLiveShapeOf('notifications', NotificationMapper.fromRow);
    mapsLiveShapeOf('media_assets', MediaMapper.fromRow, varying: 'purpose');
  });

  group('The profile itself is usable', () {
    test('every query the tests rely on was actually profiled', () {
      // A table with no rows yet profiles to nothing, and a test that silently
      // maps an empty row proves nothing. Naming them here keeps that visible
      // rather than passing by default.
      final empty = [
        for (final name in shapes.names)
          if (!shapes.hasRows(name)) name,
      ];
      printOnFailure('Profiled with no rows: $empty');
      expect(
        shapes.hasRows('bookings') && shapes.hasRows('workers'),
        isTrue,
        reason: 'The core tables profiled empty — re-run profile-app-data.mjs '
            'against a database that has data in it.',
      );
    });
  });
}
