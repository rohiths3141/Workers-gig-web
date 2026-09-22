import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';

/// The app's enums against the database's.
///
/// Every enum here mirrors a Postgres type, and `_parse` throws on a value it
/// does not recognise rather than guessing — which is the right behaviour, and
/// also means a value added in SQL and not added in Dart is a crash the first
/// time a row carrying it reaches a worker's phone. Nothing in the build or the
/// analyzer catches that, because the two definitions never meet at compile
/// time.
///
/// They meet here. `test/fixtures/db_enums.json` is generated from the
/// migrations by `web/supabase/scripts/generate-db-contract.mjs`; regenerate it
/// after any migration that touches an enum and this test will say whether the
/// apps still understand the database.
void main() {
  final fixture = jsonDecode(
    File('test/fixtures/db_enums.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final dbEnums = (fixture['enums'] as Map).cast<String, dynamic>();
  final dbChecks = (fixture['checkConstraints'] as Map).cast<String, dynamic>();

  List<String> dbValues(Map<String, dynamic> source, String name) {
    final values = source[name];
    if (values == null) {
      fail(
        'The fixture has no "$name". Either the migration that defines it was '
        'not parsed, or it was renamed. Regenerate with '
        '`node web/supabase/scripts/generate-db-contract.mjs`.',
      );
    }
    return (values as List).cast<String>();
  }

  /// Asserts [parse] accepts every value the database can store in [dbType].
  void covers<T>(
    String dbType,
    T Function(String?) parse,
    List<String> wires, {
    Map<String, dynamic>? from,
  }) {
    final expected = dbValues(from ?? dbEnums, dbType);
    final missing = expected.where((v) => !wires.contains(v)).toList();

    expect(
      missing,
      isEmpty,
      reason:
          'public.$dbType can store $missing, and this app would throw on it. '
          'Add ${missing.length == 1 ? 'that value' : 'those values'} to the '
          'Dart enum, or stop parsing this column into an enum.',
    );

    // Parsing must actually work, not just look like it does.
    for (final value in expected) {
      expect(() => parse(value), returnsNormally, reason: '$dbType "$value"');
    }
  }

  group('Dart enums cover the database', () {
    test('worker_status', () => covers('worker_status', WorkerStatus.parse,
        WorkerStatus.values.map((e) => e.wire).toList()));

    test('worker_availability', () => covers(
        'worker_availability',
        WorkerAvailability.parse,
        WorkerAvailability.values.map((e) => e.wire).toList()));

    test('booking_status', () => covers('booking_status', BookingStatus.parse,
        BookingStatus.values.map((e) => e.wire).toList()));

    test('verification_type', () => covers(
        'verification_type',
        VerificationType.parse,
        VerificationType.values.map((e) => e.wire).toList()));

    test('verification_status', () => covers(
        'verification_status',
        VerificationStatus.parse,
        VerificationStatus.values.map((e) => e.wire).toList()));

    test('gig_status', () => covers('gig_status', GigStatus.parse,
        GigStatus.values.map((e) => e.wire).toList()));

    test('material_status', () => covers('material_status', MaterialStatus.parse,
        MaterialStatus.values.map((e) => e.wire).toList()));

    test('wallet_transaction_type', () => covers(
        'wallet_transaction_type',
        WalletTransactionType.parse,
        WalletTransactionType.values.map((e) => e.wire).toList()));

    test('payout_status', () => covers('payout_status', PayoutStatus.parse,
        PayoutStatus.values.map((e) => e.wire).toList()));

    test('support_status', () => covers('support_status', SupportStatus.parse,
        SupportStatus.values.map((e) => e.wire).toList()));

    test('support_category', () => covers(
        'support_category',
        SupportCategory.parse,
        SupportCategory.values.map((e) => e.wire).toList()));

    test('claim_status', () => covers('claim_status', ClaimStatus.parse,
        ClaimStatus.values.map((e) => e.wire).toList()));

    test('insurance_status', () => covers(
        'insurance_status',
        InsuranceStatus.parse,
        InsuranceStatus.values.map((e) => e.wire).toList()));

    test('media_purpose', () => covers('media_purpose', MediaPurpose.parse,
        MediaPurpose.values.map((e) => e.wire).toList()));

    test('media_upload_status', () => covers(
        'media_upload_status',
        MediaUploadStatus.parse,
        MediaUploadStatus.values.map((e) => e.wire).toList()));

    test('service_request_status', () => covers(
        'service_request_status',
        ServiceRequestStatus.parse,
        ServiceRequestStatus.values.map((e) => e.wire).toList()));

    test('budget_type', () => covers('budget_type', BudgetType.parse,
        BudgetType.values.map((e) => e.wire).toList()));

    test('schedule_type', () => covers('schedule_type', ScheduleType.parse,
        ScheduleType.values.map((e) => e.wire).toList()));

    test('offer_status', () => covers('offer_status', OfferStatus.parse,
        OfferStatus.values.map((e) => e.wire).toList()));

    test('booking_source', () => covers('booking_source', BookingSource.parse,
        BookingSource.values.map((e) => e.wire).toList()));

    // A text column with a CHECK rather than a Postgres enum, but parsed the
    // same throwing way, so it needs the same coverage.
    test('worker_gigs.pricing_unit', () => covers(
          'pricing_unit',
          PricingUnit.parse,
          PricingUnit.values.map((e) => e.wire).toList(),
          from: dbChecks,
        ));
  });

  group('Parsing refuses to guess', () {
    test('an unknown value throws rather than defaulting to something safe-looking', () {
      expect(() => BookingStatus.parse('NOT_A_STATUS'), throwsArgumentError);
      expect(() => WorkerStatus.parse(''), throwsArgumentError);
    });

    test('a null throws rather than silently picking the first value', () {
      expect(() => BookingStatus.parse(null), throwsArgumentError);
    });
  });
}
