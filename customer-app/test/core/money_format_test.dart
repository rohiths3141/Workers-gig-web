import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_customer/core/utils/money_format.dart';
import 'package:wervexa_customer/domain/entities/enums.dart';
import 'package:wervexa_customer/domain/entities/material_request.dart';

/// Amounts are integer paise everywhere and are divided in exactly one place.
///
/// The screens used to each do their own `minor / 100`, and not all the same
/// way: some rounded with `toStringAsFixed(0)`, some truncated with `toInt()`.
/// The same booking could therefore read ₹500 on the list and ₹499 on its own
/// detail screen.
void main() {
  group('Rupees', () {
    test('a whole-rupee amount has no decimal part', () {
      expect(formatRupees(49900), '₹499');
      expect(formatRupees(100), '₹1');
      expect(formatRupees(0), '₹0');
    });

    test('paise are shown when there are any, and never rounded away', () {
      // toStringAsFixed(0) turned this into "₹500" — a price nobody was
      // charged.
      expect(formatRupees(49950), '₹499.50');
      expect(formatRupees(49999), '₹499.99');
      expect(formatRupees(1), '₹0.01');
    });

    test('paise below ten keep their leading zero', () {
      expect(formatRupees(10005), '₹100.05');
    });

    test('a negative amount keeps its sign outside the symbol', () {
      expect(formatRupees(-5000), '-₹50');
      expect(formatRupees(-4950), '-₹49.50');
    });

    test('large amounts are exact', () {
      // A double would start losing precision long before this.
      expect(formatRupees(123456789), '₹1234567.89');
    });

    test('a missing amount is not zero', () {
      // "no final price yet" and "the final price is nothing" are different
      // statements to make to someone about their bill.
      expect(formatRupeesOr(null, 'Not settled yet'), 'Not settled yet');
      expect(formatRupeesOr(0, 'Not settled yet'), '₹0');
    });
  });

  group('Material lines', () {
    MaterialRequest material({
      double quantity = 1,
      String unit = 'unit',
      int? estimated = 25000,
      int? actual,
    }) =>
        MaterialRequest(
          id: 'm1',
          bookingId: 'b1',
          name: 'Copper wire',
          description: '',
          status: MaterialStatus.customerReview,
          quantity: quantity,
          unit: unit,
          estimatedCostMinor: estimated,
          actualCostMinor: actual,
          createdAt: DateTime(2026),
        );

    test('the cost is the line total, not a price per unit', () {
      // The worker types one amount for the whole line and states the quantity
      // beside it. Multiplying the two would bill the customer five times over
      // for five metres of cable.
      expect(material(quantity: 5, unit: 'metre').costLabel, '₹250');
    });

    test('the real quantity is shown, not a hardcoded one', () {
      expect(material(quantity: 5, unit: 'metre').quantityLabel, '5 metre');
      expect(material(quantity: 2.5, unit: 'kg').quantityLabel, '2.50 kg');
      expect(material().quantityLabel, '1 unit');
    });

    test('the settled cost replaces the estimate once there is one', () {
      final settled = material(estimated: 25000, actual: 27500);
      expect(settled.costLabel, '₹275');
      expect(settled.isEstimate, isFalse);
      expect(material().isEstimate, isTrue);
    });

    test('a material with no cost yet reads as zero, not as a crash', () {
      expect(material(estimated: null).costMinor, 0);
    });
  });
}
