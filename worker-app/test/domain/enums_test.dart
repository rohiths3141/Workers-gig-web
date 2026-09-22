import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';

/// The wire values must match the Postgres enums exactly. A mismatch would
/// surface as a runtime error deep in a screen, so it is pinned here.
void main() {
  group('Parsing refuses to guess', () {
    test('an unknown value throws rather than defaulting', () {
      // Quietly mapping an unknown status to a default would show a worker a
      // booking in the wrong state, which is worse than a visible error.
      expect(() => BookingStatus.parse('TELEPORTING'), throwsArgumentError);
      expect(() => WorkerStatus.parse('SOMETHING_NEW'), throwsArgumentError);
      expect(() => GigStatus.parse('WHATEVER'), throwsArgumentError);
    });

    test('a null value throws', () {
      expect(() => BookingStatus.parse(null), throwsArgumentError);
      expect(() => VerificationStatus.parse(null), throwsArgumentError);
    });
  });

  group('Wire values match the schema', () {
    test('booking_status', () {
      const expected = {
        'REQUESTED', 'ACCEPTED', 'CONFIRMED', 'TRAVELING', 'ARRIVED',
        'IN_PROGRESS', 'AWAITING_APPROVAL', 'COMPLETED', 'PAYMENT_PENDING',
        'PAID', 'CLOSED', 'CANCELLED', 'DISPUTED', 'EXPIRED',
      };
      expect(BookingStatus.values.map((v) => v.wire).toSet(), expected);
    });

    test('worker_status', () {
      const expected = {
        'REGISTERED', 'VERIFICATION_PENDING', 'ACTIVE', 'INACTIVE',
        'RESTRICTED', 'SUSPENDED', 'REJECTED', 'DEACTIVATED',
      };
      expect(WorkerStatus.values.map((v) => v.wire).toSet(), expected);
    });

    test('gig_status', () {
      const expected = {
        'DRAFT', 'PENDING_REVIEW', 'ACTIVE', 'PAUSED', 'REJECTED', 'ARCHIVED',
      };
      expect(GigStatus.values.map((v) => v.wire).toSet(), expected);
    });

    test('verification_status', () {
      const expected = {
        'NOT_SUBMITTED', 'PENDING', 'UNDER_REVIEW', 'MORE_INFO_REQUIRED',
        'APPROVED', 'REJECTED', 'EXPIRED', 'NOT_APPLICABLE',
      };
      expect(VerificationStatus.values.map((v) => v.wire).toSet(), expected);
    });

    test('wallet_transaction_type, with signs matching the ledger check', () {
      for (final type in WalletTransactionType.values) {
        expect(type.isCredit, type.wire.startsWith('CREDIT'), reason: type.wire);
      }
    });
  });

  group('Availability and eligibility are different questions', () {
    test('only ACTIVE workers can receive jobs', () {
      expect(WorkerStatus.active.canReceiveJobs, isTrue);
      for (final status in WorkerStatus.values.where((s) => s != WorkerStatus.active)) {
        expect(status.canReceiveJobs, isFalse, reason: '$status');
      }
    });

    test('a restricted worker can still use the app', () {
      // Hiding the whole app would leave them no way to resolve the
      // restriction or contact support.
      expect(WorkerStatus.restricted.canUseApp, isTrue);
      expect(WorkerStatus.suspended.canUseApp, isTrue);
      expect(WorkerStatus.verificationPending.canUseApp, isTrue);
      expect(WorkerStatus.deactivated.canUseApp, isFalse);
    });
  });

  group('Payout wording does not overclaim', () {
    test('only COMPLETED means the money actually moved', () {
      expect(PayoutStatus.completed.isSettled, isTrue);
      for (final status
          in PayoutStatus.values.where((s) => s != PayoutStatus.completed)) {
        expect(status.isSettled, isFalse, reason: '$status');
      }
    });

    test('requested and processing are in flight, not paid', () {
      expect(PayoutStatus.requested.isInFlight, isTrue);
      expect(PayoutStatus.processing.isInFlight, isTrue);
      expect(PayoutStatus.completed.isInFlight, isFalse);
    });
  });

  group('Materials', () {
    test('a worker cannot record a cost before the customer approves', () {
      expect(MaterialStatus.requested.canRecordCost, isFalse);
      expect(MaterialStatus.customerReview.canRecordCost, isFalse);
      expect(MaterialStatus.rejected.canRecordCost, isFalse);
      expect(MaterialStatus.approved.canRecordCost, isTrue);
      expect(MaterialStatus.purchased.canRecordCost, isTrue);
    });
  });
}
