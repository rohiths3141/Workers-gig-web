import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/data/repositories/firebase_auth_repository.dart';

/// Phone is the only credential on this platform, so getting the number right
/// is the whole of sign-in. A typo refused here costs nothing; one accepted
/// costs the worker an OTP sent to somebody else's phone.
void main() {
  String? normalise(String input) =>
      FirebaseAuthRepository.normalisePhone(input);

  group('Indian mobile numbers', () {
    test('accepts a plain ten digit number', () {
      expect(normalise('9876543210'), '+919876543210');
    });

    test('strips a leading zero', () {
      expect(normalise('09876543210'), '+919876543210');
    });

    test('accepts the country code with or without a plus', () {
      expect(normalise('919876543210'), '+919876543210');
      expect(normalise('+919876543210'), '+919876543210');
    });

    test('ignores the spaces, dashes and brackets people actually type', () {
      expect(normalise('+91 98765 43210'), '+919876543210');
      expect(normalise('98765-43210'), '+919876543210');
      expect(normalise('(98765) 43210'), '+919876543210');
    });

    test('accepts every valid Indian mobile prefix', () {
      for (final prefix in ['6', '7', '8', '9']) {
        expect(normalise('${prefix}876543210'), '+91${prefix}876543210');
      }
    });
  });

  group('Refusals', () {
    test('refuses a landline prefix', () {
      // Indian mobile numbers start 6-9. A number starting 2 is a landline and
      // will never receive an SMS.
      expect(normalise('2876543210'), isNull);
      expect(normalise('5876543210'), isNull);
    });

    test('refuses a number that is too short or too long', () {
      expect(normalise('98765'), isNull);
      expect(normalise('98765432100'), isNull);
    });

    test('refuses empty and non-numeric input', () {
      expect(normalise(''), isNull);
      expect(normalise('   '), isNull);
      expect(normalise('not a number'), isNull);
    });

    test('refuses an international number that is implausibly short or long', () {
      expect(normalise('+1234'), isNull);
      expect(normalise('+1234567890123456'), isNull);
    });
  });

  group('International numbers', () {
    test('respects an explicit country code rather than forcing +91', () {
      expect(normalise('+14155552671'), '+14155552671');
      expect(normalise('+442071838750'), '+442071838750');
    });
  });
}
