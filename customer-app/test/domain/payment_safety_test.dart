import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/domain/entities/booking.dart';
import 'package:wervexa_customer/domain/entities/enums.dart';

/// When the app is allowed to ask someone for money.
///
/// Bookings are paid upfront, so REQUESTED covers two very different
/// situations: not paid for yet, and paid for and waiting to be matched. The
/// only thing separating them is the set of bookings known to be paid — and if
/// that set cannot be loaded, the honest answer is "we do not know", not
/// "nothing has been paid".
///
/// Getting this wrong does not show a wrong label. It takes the money twice.
void main() {
  Booking booking({
    String id = 'b1',
    BookingStatus status = BookingStatus.requested,
  }) =>
      Booking(
        id: id,
        bookingCode: 'BKG-1',
        customerId: 'c1',
        serviceId: 's1',
        serviceName: 'Electrical',
        status: status,
        problemDescription: 'Fan not working',
        addressLine: '1 Example Street',
        city: 'Erode',
        quotedAmountMinor: 49900,
        currency: 'INR',
        createdAt: DateTime(2026, 9, 20),
      );

  group('Asking for payment', () {
    test('a booking not in the paid set still needs paying', () {
      expect(booking().awaitingPayment(const {}), isTrue);
      expect(booking(id: 'b1').awaitingPayment(const {'b2'}), isTrue);
    });

    test('a booking in the paid set is never asked for again', () {
      expect(booking(id: 'b1').awaitingPayment(const {'b1'}), isFalse);
    });

    test('an unknown payment state never asks for money', () {
      // null is "the lookup failed or has not answered", which used to arrive
      // at the screen as an empty set and put a Pay now button on every
      // REQUESTED booking, paid or not.
      expect(booking().awaitingPayment(null), isFalse);
    });

    test('only a REQUESTED booking is ever asked to pay', () {
      // Everything past REQUESTED has been paid for already; the money moves
      // once, up front.
      for (final status in BookingStatus.values) {
        if (status == BookingStatus.requested) continue;
        expect(
          booking(status: status).awaitingPayment(const {}),
          isFalse,
          reason: '$status must never show a Pay button',
        );
      }
    });

    test('the paid set is consulted by booking id, not by position', () {
      final first = booking(id: 'aaa');
      final second = booking(id: 'bbb');
      const paid = {'aaa'};

      expect(first.awaitingPayment(paid), isFalse);
      expect(second.awaitingPayment(paid), isTrue);
    });
  });
}
