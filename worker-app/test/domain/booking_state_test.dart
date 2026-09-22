import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/domain/entities/enums.dart';
import 'package:wervexa_worker/core/money/money.dart';
import 'package:wervexa_worker/domain/entities/job.dart';

/// The booking lifecycle as the worker's app understands it.
///
/// The server is authoritative — `worker_advance_booking` validates every move
/// and refuses anything a worker may not do. These tests cover the client's
/// half: that it offers the right next step, and never offers one the server
/// would refuse.
void main() {
  group('Worker next step', () {
    test('follows the platform lifecycle in order', () {
      expect(BookingStatus.confirmed.workerNextStatus, BookingStatus.traveling);
      expect(BookingStatus.traveling.workerNextStatus, BookingStatus.arrived);
      expect(BookingStatus.arrived.workerNextStatus, BookingStatus.inProgress);
      expect(BookingStatus.inProgress.workerNextStatus,
          BookingStatus.awaitingApproval);
    });

    test('stops where the worker\'s part ends', () {
      // Everything past AWAITING_APPROVAL belongs to the customer, the payment
      // webhook or operations. Offering a button here would produce a refusal.
      for (final status in [
        BookingStatus.awaitingApproval,
        BookingStatus.completed,
        BookingStatus.paymentPending,
        BookingStatus.paid,
        BookingStatus.closed,
        BookingStatus.disputed,
        BookingStatus.cancelled,
        BookingStatus.expired,
      ]) {
        expect(status.workerNextStatus, isNull, reason: '$status');
      }
    });

    test('offers nothing while the customer has not confirmed', () {
      // ACCEPTED -> CONFIRMED is the customer's move, not the worker's.
      expect(BookingStatus.accepted.workerNextStatus, isNull);
    });

    test('a worker can never reach COMPLETED directly', () {
      final reachable = BookingStatus.values
          .map((s) => s.workerNextStatus)
          .whereType<BookingStatus>()
          .toSet();

      expect(reachable.contains(BookingStatus.completed), isFalse);
      expect(reachable.contains(BookingStatus.paid), isFalse);
      expect(reachable.contains(BookingStatus.closed), isFalse);
    });
  });

  group('Status groupings', () {
    test('active means the worker has something to do', () {
      expect(BookingStatus.traveling.isActive, isTrue);
      expect(BookingStatus.inProgress.isActive, isTrue);
      expect(BookingStatus.completed.isActive, isFalse);
    });

    test('terminal means nothing further will happen', () {
      expect(BookingStatus.closed.isTerminal, isTrue);
      expect(BookingStatus.cancelled.isTerminal, isTrue);
      expect(BookingStatus.expired.isTerminal, isTrue);
      expect(BookingStatus.disputed.isTerminal, isFalse);
    });
  });

  group('Completion readiness', () {
    CompletionReadiness readiness({
      bool arrival = true,
      bool before = true,
      bool after = true,
      int pending = 0,
    }) =>
        CompletionReadiness(
          isArrivalVerified: arrival,
          hasBeforeWorkEvidence: before,
          hasAfterWorkEvidence: after,
          pendingMaterialCount: pending,
        );

    test('allows completion when everything the server requires is done', () {
      expect(readiness().canComplete, isTrue);
    });

    test('blocks without a verified arrival', () {
      final r = readiness(arrival: false);
      expect(r.canComplete, isFalse);
      expect(r.blockers.first, contains('Verify arrival'));
    });

    test('blocks without after-work evidence', () {
      final r = readiness(after: false);
      expect(r.canComplete, isFalse);
      expect(r.blockers, contains(contains('finished work')));
    });

    test('blocks while a material is still with the customer', () {
      final r = readiness(pending: 2);
      expect(r.canComplete, isFalse);
      expect(r.blockers, contains(contains('2 material requests')));
    });

    test('does not block on before-work evidence, which is optional', () {
      // The server requires only after-work evidence. Blocking on before-work
      // would refuse a worker the server would have let through.
      expect(readiness(before: false).canComplete, isTrue);
    });

    test('lists every blocker, not just the first', () {
      final r = readiness(arrival: false, after: false, pending: 1);
      expect(r.blockers, hasLength(3));
    });
  });

  group('Offer expiry', () {
    JobOffer offer(Duration remaining) => JobOffer(
          job: Job(
            id: 'b1',
            bookingCode: 'BK-1',
            status: BookingStatus.requested,
            serviceId: 's1',
            serviceName: 'Electrical',
            problemDescription: 'Fan not working',
            addressLine: '12 Anna Nagar',
            materialAmount: const Money.zero(),
            createdAt: DateTime.now(),
          ),
          rank: 1,
          distanceKm: 3.2,
          offeredAt: DateTime.now(),
          expiresAt: DateTime.now().add(remaining),
        );

    test('an offer inside its window is live', () {
      expect(offer(const Duration(minutes: 5)).isExpired, isFalse);
    });

    test('an offer past its window is expired', () {
      expect(offer(const Duration(seconds: -1)).isExpired, isTrue);
    });

    test('remaining time never goes negative', () {
      expect(offer(const Duration(minutes: -5)).timeRemaining, Duration.zero);
    });
  });
}
