import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/money/money.dart';

/// Money is the one place in this app where a rounding error becomes a real
/// person being paid the wrong amount, so these tests are deliberately fussy.
void main() {
  group('Money parsing', () {
    test('parses whole rupees', () {
      expect(Money.tryParseMajor('499')!.minor, 49900);
    });

    test('parses paise exactly', () {
      expect(Money.tryParseMajor('499.50')!.minor, 49950);
      expect(Money.tryParseMajor('0.01')!.minor, 1);
      expect(Money.tryParseMajor('0.99')!.minor, 99);
    });

    test('parses a single decimal place as tenths, not hundredths', () {
      // "1.5" is one rupee fifty, not one rupee five paise.
      expect(Money.tryParseMajor('1.5')!.minor, 150);
    });

    test('does not lose a paisa to floating point', () {
      // 0.29 * 100 is 28.999999999999996 as a double. Parsing through the
      // string avoids that entirely, which is the whole reason this is here.
      expect(Money.tryParseMajor('0.29')!.minor, 29);
      expect(Money.tryParseMajor('1.15')!.minor, 115);
      expect(Money.tryParseMajor('8.70')!.minor, 870);
    });

    test('tolerates the symbols and separators a worker actually types', () {
      expect(Money.tryParseMajor(' ₹1,499 ')!.minor, 149900);
    });

    test('refuses text that is not an amount', () {
      expect(Money.tryParseMajor(''), isNull);
      expect(Money.tryParseMajor('abc'), isNull);
      expect(Money.tryParseMajor('-100'), isNull);
      expect(Money.tryParseMajor('1.234'), isNull);
      expect(Money.tryParseMajor('1.2.3'), isNull);
    });
  });

  group('Money arithmetic', () {
    test('adds and subtracts in minor units', () {
      expect((const Money(49900) + const Money(8500)).minor, 58400);
      expect((const Money(49900) - const Money(7485)).minor, 42415);
    });

    test('compares correctly', () {
      expect(const Money(50000) > const Money(49999), isTrue);
      expect(const Money(50000) >= const Money(50000), isTrue);
      expect(const Money(1) < const Money(2), isTrue);
    });

    test('a hundred additions of one paisa is exactly one rupee', () {
      var total = const Money.zero();
      for (var i = 0; i < 100; i++) {
        total = total + const Money(1);
      }
      expect(total.minor, 100);
    });
  });

  group('Money formatting', () {
    test('hides paise when they are zero', () {
      expect(const Money(49900).format(), '₹499');
    });

    test('shows paise when they are not', () {
      expect(const Money(49950).format(), '₹499.50');
      expect(const Money(49905).format(), '₹499.05');
    });

    test('groups in the Indian system', () {
      // 1,49,900 paise is ₹1,499 — and a lakh groups as 1,00,000 not 100,000.
      expect(const Money(10000000).format(), '₹1,00,000');
    });

    test('shows a sign only when asked', () {
      expect(const Money(49900).format(showSign: true), '+₹499');
      expect(const Money(-8500).format(), '-₹85');
    });

    test('compacts large amounts', () {
      expect(const Money(1250000).formatCompact(), '₹12.5k');
      expect(const Money(15000000).formatCompact(), '₹1.5L');
    });
  });
}
