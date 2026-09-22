import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/logging/app_logger.dart';

/// A crash report is not a place to accumulate identity documents, arrival
/// codes or customer addresses. The logger redacts by key, and these tests hold
/// the deny-list to its job.
void main() {
  group('Redaction', () {
    test('redacts identity and financial identifiers', () {
      final redacted = AppLogger.redact({
        'aadhaar': '1234 5678 9012',
        'pan': 'ABCDE1234F',
        'account_number': '12345678901234',
        'ifsc': 'HDFC0001234',
        'workerCode': 'WKR-25-A1B2C3',
      });

      expect(redacted['aadhaar'], '***');
      expect(redacted['pan'], '***');
      expect(redacted['account_number'], '***');
      expect(redacted['ifsc'], '***');
      // A worker code is not sensitive: support asks for it out loud.
      expect(redacted['workerCode'], 'WKR-25-A1B2C3');
    });

    test('redacts the arrival code and any OTP', () {
      final redacted = AppLogger.redact({
        'arrival_code': '482913',
        'otp': '123456',
        'verification_code': '999999',
      });

      expect(redacted.values, everyElement('***'));
    });

    test('redacts credentials and tokens', () {
      final redacted = AppLogger.redact({
        'id_token': 'eyJhbGciOi...',
        'access_token': 'abc',
        'authorization': 'Bearer xyz',
        'apikey': 'sb-key',
      });

      expect(redacted.values, everyElement('***'));
    });

    test('redacts personal and location data', () {
      final redacted = AppLogger.redact({
        'phone': '9876543210',
        'email': 'worker@example.com',
        'address_line': '12 Anna Nagar',
        'latitude': 13.0827,
        'longitude': 80.2707,
        'full_name': 'Arun Kumar',
      });

      expect(redacted.values, everyElement('***'));
    });

    test('redacts recursively, so a whole response body is safe to log', () {
      // This is the realistic mistake: someone logs an entire booking payload
      // while debugging, and it ships.
      final redacted = AppLogger.redact({
        'booking': {
          'booking_code': 'BK-250913-A1B2',
          'arrival_code': '482913',
          'customer': {
            'full_name': 'Meena R',
            'phone': '9876543210',
          },
        },
      });

      final booking = redacted['booking']! as Map<String, Object?>;
      expect(booking['booking_code'], 'BK-250913-A1B2');
      expect(booking['arrival_code'], '***');

      final customer = booking['customer']! as Map<String, Object?>;
      expect(customer['full_name'], '***');
      expect(customer['phone'], '***');
    });

    test('redacts inside lists', () {
      final redacted = AppLogger.redact({
        'jobs': [
          {'booking_code': 'BK-1', 'address_line': '12 Anna Nagar'},
          {'booking_code': 'BK-2', 'address_line': '9 T Nagar'},
        ],
      });

      final jobs = redacted['jobs']! as List;
      for (final job in jobs) {
        expect((job as Map)['address_line'], '***');
        expect(job['booking_code'], isNot('***'));
      }
    });

    test('matches keys case-insensitively', () {
      final redacted = AppLogger.redact({'Aadhaar': 'x', 'PHONE': 'y'});
      expect(redacted.values, everyElement('***'));
    });

    test('leaves operational fields readable', () {
      // Redacting everything would make logs useless. These are the fields an
      // engineer actually needs to diagnose a problem.
      final redacted = AppLogger.redact({
        'status': 'IN_PROGRESS',
        'booking_id': 'uuid-1234',
        'failure': 'ConflictFailure',
        'durationMs': 412,
      });

      expect(redacted['status'], 'IN_PROGRESS');
      expect(redacted['booking_id'], 'uuid-1234');
      expect(redacted['failure'], 'ConflictFailure');
      expect(redacted['durationMs'], 412);
    });
  });

  test('the deny-list covers every sensitive field this app handles', () {
    for (final key in [
      'aadhaar', 'pan', 'document_number', 'account_number', 'ifsc',
      'arrival_code', 'otp', 'phone', 'email', 'latitude', 'longitude',
      'address_line', 'id_token', 'apikey', 'full_name',
    ]) {
      expect(AppLogger.isSensitiveKey(key), isTrue, reason: key);
    }
  });
}
