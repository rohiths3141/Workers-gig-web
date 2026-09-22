import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/domain/entities/enums.dart';

/// What each booking status means *to the customer*.
///
/// These groupings decide what appears on Home and in each tab of My Bookings,
/// so a status in the wrong set is not a cosmetic problem — it is a booking the
/// customer paid for and cannot find.
void main() {
  group('A live booking is never invisible', () {
    // The screens divide bookings three ways: isActive drives the Home banner,
    // isFinished the Completed tab, and a small ended set the Cancelled tab.
    // Anything outside all three has no home on any screen.
    const endedOnItsOwnTab = {
      BookingStatus.cancelled,
      BookingStatus.expired,
      BookingStatus.disputed,
    };

    test('every status is either active, finished, or on the ended tab', () {
      final unplaced = BookingStatus.values
          .where((s) =>
              !s.isActive && !s.isFinished && !endedOnItsOwnTab.contains(s))
          .toList();

      expect(
        unplaced,
        isEmpty,
        reason: 'These statuses appear on no screen at all: $unplaced. '
            'A customer in one of them sees no sign of their booking.',
      );
    });

    test('a booking that has been placed but not yet matched is active', () {
      // REQUESTED is where every new booking sits — paid, waiting to be
      // matched to a worker. The worker app excludes it from isActive on
      // purpose (an unassigned job is an offer, not their work), and this app
      // had copied that set, so a customer booked, paid, went back to Home and
      // found nothing there.
      expect(BookingStatus.requested.isActive, isTrue);
      expect(BookingStatus.requested.isFinished, isFalse);
      expect(BookingStatus.requested.isTerminal, isFalse);
    });

    test('work in progress is active at every stage', () {
      for (final status in [
        BookingStatus.accepted,
        BookingStatus.confirmed,
        BookingStatus.traveling,
        BookingStatus.arrived,
        BookingStatus.inProgress,
      ]) {
        expect(status.isActive, isTrue, reason: '$status must stay on Home');
      }
    });

    test('a finished job waiting on the customer stays active', () {
      // The work is done but the money has not moved and there is a button
      // only the customer can press. Filing it under Completed would lose it.
      expect(BookingStatus.awaitingApproval.isActive, isTrue);
      expect(BookingStatus.awaitingApproval.needsCustomerAction, isTrue);
    });
  });

  group('Active and finished do not overlap', () {
    test('nothing is both active and finished', () {
      final both =
          BookingStatus.values.where((s) => s.isActive && s.isFinished).toList();
      expect(both, isEmpty, reason: '$both would appear in two tabs at once');
    });

    test('nothing is both active and terminal', () {
      final both =
          BookingStatus.values.where((s) => s.isActive && s.isTerminal).toList();
      expect(both, isEmpty);
    });

    test('terminal means nothing further will happen', () {
      expect(BookingStatus.closed.isTerminal, isTrue);
      expect(BookingStatus.cancelled.isTerminal, isTrue);
      expect(BookingStatus.expired.isTerminal, isTrue);
      // A dispute is still being worked on, so it is not terminal.
      expect(BookingStatus.disputed.isTerminal, isFalse);
    });
  });

  group('Payment', () {
    test('PAID is the settled end of the job, not the moment money was taken', () {
      // The customer pays up front, but the booking only reaches PAID once the
      // work is approved and the worker has been credited (migration 0054).
      // Treating it as "in progress" would keep finished jobs on Home forever.
      expect(BookingStatus.paid.isFinished, isTrue);
      expect(BookingStatus.paid.isActive, isFalse);
    });
  });

  group('Live tracking', () {
    test('is offered only while the worker is actually moving or working', () {
      for (final status in BookingStatus.values) {
        final expected = status == BookingStatus.traveling ||
            status == BookingStatus.arrived ||
            status == BookingStatus.inProgress;
        expect(status.showLiveTracking, expected, reason: '$status');
      }
    });

    test('a booking with no worker yet offers no map', () {
      expect(BookingStatus.requested.showLiveTracking, isFalse);
    });
  });

  group('Labels', () {
    test('every status says something to the customer', () {
      for (final status in BookingStatus.values) {
        expect(status.customerLabel.trim(), isNotEmpty, reason: '$status');
        expect(status.displayName, status.customerLabel);
      }
    });

    test('no label leaks a wire value', () {
      for (final status in BookingStatus.values) {
        expect(status.customerLabel, isNot(contains('_')), reason: '$status');
        expect(
          status.customerLabel,
          isNot(equals(status.customerLabel.toUpperCase())),
          reason: '$status reads like a database constant',
        );
      }
    });
  });
}
