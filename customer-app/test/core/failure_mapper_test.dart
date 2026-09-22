import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException;
import 'package:wervexa_customer/core/errors/app_failure.dart';
import 'package:wervexa_customer/core/errors/failure_mapper.dart';

/// What the customer is told when something goes wrong.
///
/// Every screen shows `failure.message`, so this mapper is the entire
/// vocabulary of the app's bad news. Two things matter: the customer is never
/// shown a SQLSTATE or a stack trace, and a problem that is really about the
/// phone (a wrong clock, a session that has not finished setting up) is never
/// reported as something the customer did wrong.
void main() {
  PostgrestException pg(String code, {String message = 'boom', String? details}) =>
      PostgrestException(message: message, code: code, details: details);

  group('Database refusals become something a person can act on', () {
    test('a permission refusal says so without mentioning a policy', () {
      final failure = FailureMapper.from(
        pg('42501', message: 'FORBIDDEN: you cannot cancel a job in progress'),
      );

      expect(failure, isA<PermissionFailure>());
      expect(failure.message, 'You cannot cancel a job in progress.');
      expect(failure.message, isNot(contains('FORBIDDEN')));
    });

    test('a missing row is not distinguishable from one you may not see', () {
      expect(FailureMapper.from(pg('PGRST116')), isA<NotFoundFailure>());
      expect(FailureMapper.from(pg('P0002')), isA<NotFoundFailure>());
    });

    test('losing a race reads as a conflict, not as a server error', () {
      final failure = FailureMapper.from(
        pg('23505', message: 'CONFLICT: that slot has just been taken'),
      );
      expect(failure, isA<ConflictFailure>());
      expect(failure.message, 'That slot has just been taken.');
    });

    test('a validation refusal keeps the server wording', () {
      // The database is a better place to phrase "that date is in the past"
      // than the client is, so the text is passed through rather than replaced.
      final failure = FailureMapper.from(
        pg('23514', message: 'INVALID: choose a date in the future'),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Choose a date in the future.');
    });

    test('a timeout is a timeout, not an unexplained failure', () {
      expect(FailureMapper.from(pg('57014')), isA<TimeoutFailure>());
      expect(FailureMapper.from(pg('PGRST002')), isA<TimeoutFailure>());
    });
  });

  group('Problems that are not the customer\'s fault', () {
    test('a token rejected for clock skew never becomes a sign-out', () {
      // PGRST303 is "JWT issued at future" — the phone's clock is wrong, not
      // the session. Signing someone out over it would lock them out of their
      // own account until they noticed their clock.
      final failure = FailureMapper.from(pg('PGRST303'));

      expect(failure, isA<ClockSkewFailure>());
      expect(failure.isRetryable, isTrue);
      expect(
        failure,
        isNot(isA<AuthFailure>()),
        reason: 'A wrong clock must not be treated as a bad session',
      );
    });

    test('a request that reached the server unauthenticated says to wait', () {
      // Right after sign-up the Firebase token can still be missing the
      // Supabase role claim, so PostgREST runs the request as `anon` and
      // answers 401 with the Postgres 42501 buried in the body. That is a
      // moment to wait out, not "something went wrong at our end".
      final failure = FailureMapper.from(
        pg('401', message: 'permission denied for table bookings (42501)'),
      );

      expect(failure, isA<PermissionFailure>());
      expect(failure.message, contains('not fully set up yet'));
    });
  });

  group('Nothing internal reaches the screen', () {
    test('no message leaks a SQLSTATE, a table name or a raw prefix', () {
      final failures = [
        FailureMapper.from(pg('42501', message: 'FORBIDDEN: nope')),
        FailureMapper.from(pg('23505', message: 'CONFLICT: nope')),
        FailureMapper.from(pg('PGRST303')),
        FailureMapper.from(pg('23503')),
        FailureMapper.from(const SocketException('failed host lookup')),
        FailureMapper.from(TimeoutException('too slow')),
        FailureMapper.from(StateError('unexpected')),
      ];

      for (final failure in failures) {
        for (final leak in [
          'PGRST',
          'SQLSTATE',
          'FORBIDDEN:',
          'CONFLICT:',
          'INVALID:',
          'Exception',
          '#0',
        ]) {
          expect(failure.message, isNot(contains(leak)),
              reason: '${failure.runtimeType} leaked "$leak"');
        }
        expect(failure.message.trim(), isNotEmpty);
      }
    });

    test('every message is a finished sentence', () {
      final failure =
          FailureMapper.from(pg('23514', message: 'INVALID: pick a time'));
      expect(failure.message, startsWith('P'));
      expect(failure.message, endsWith('.'));
    });
  });

  group('Connectivity', () {
    test('no network is reported as no network', () {
      final failure = FailureMapper.from(const SocketException('no route'));
      expect(failure, isA<NetworkFailure>());
      expect(failure.isRetryable, isTrue);
    });

    test('a slow server is retryable', () {
      expect(FailureMapper.from(TimeoutException('slow')), isA<TimeoutFailure>());
    });
  });

  group('Sessions', () {
    test('a real auth failure does ask for a fresh sign-in', () {
      final failure = FailureMapper.from(AuthException('bad jwt'));
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).requiresReauthentication, isTrue);
    });
  });

  group('Anything unrecognised', () {
    test('still produces a usable message rather than a crash', () {
      final failure = FailureMapper.from(Object());
      expect(failure, isA<UnexpectedFailure>());
      expect(failure.message.trim(), isNotEmpty);
    });

    test('an AppFailure passes through unchanged', () {
      const original = NetworkFailure();
      expect(identical(FailureMapper.from(original), original), isTrue);
    });
  });
}
