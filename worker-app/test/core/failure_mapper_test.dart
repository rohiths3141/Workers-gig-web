import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/errors/app_failure.dart';
import 'package:wervexa_worker/core/errors/failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

/// The mapper is a contract with migration 0013: every trusted operation there
/// raises a known prefix and SQLSTATE pair. These tests hold both sides to it,
/// and check that no database text ever reaches a worker's screen.
void main() {
  PostgrestException pg(String code, String message, {String? details}) =>
      PostgrestException(message: message, code: code, details: details);

  group('Postgres error codes', () {
    test('42501 becomes a permission failure', () {
      final failure = FailureMapper.from(
        pg('42501', 'FORBIDDEN: you are not approved to offer this service yet'),
      );

      expect(failure, isA<PermissionFailure>());
      expect(failure.message, 'You are not approved to offer this service yet.');
      // Not retryable: trying again changes nothing and wastes the worker's time.
      expect(failure.isRetryable, isFalse);
    });

    test('23505 becomes a conflict, so a lost race reads correctly', () {
      final failure =
          FailureMapper.from(pg('23505', 'CONFLICT: this job is no longer available'));

      expect(failure, isA<ConflictFailure>());
      expect(failure.message, 'This job is no longer available.');
    });

    test('P0002 becomes not found', () {
      final failure =
          FailureMapper.from(pg('P0002', 'NOT_FOUND: that job is not assigned to you'));

      expect(failure, isA<NotFoundFailure>());
      expect(failure.message, 'That job is not assigned to you.');
    });

    test('23514 becomes validation, passing the server wording through', () {
      final failure = FailureMapper.from(pg(
        '23514',
        'INVALID: upload at least one photo of the finished work before completing the job',
      ));

      expect(failure, isA<ValidationFailure>());
      expect(
        failure.message,
        'Upload at least one photo of the finished work before completing the job.',
      );
    });

    test('insufficient funds carries the real available balance', () {
      final failure = FailureMapper.from(pg(
        '23514',
        'INSUFFICIENT_FUNDS: requested 500000 but the wallet holds 125000',
      ));

      expect(failure, isA<InsufficientFundsFailure>());
      expect((failure as InsufficientFundsFailure).availableMinor, 125000);
    });

    test('eligibility reasons are lifted out of the exception detail', () {
      final failure = FailureMapper.from(pg(
        '42501',
        'FORBIDDEN: Complete identity verification.',
        details:
            '{"eligible":false,"reasons":[{"code":"KYC_REQUIRED","message":"Complete identity verification.","action":"verification/kyc"},{"code":"NO_ACTIVE_GIG","message":"Publish at least one service so customers can book you.","action":"gigs"}]}',
      ));

      expect(failure, isA<PermissionFailure>());
      final reasons = (failure as PermissionFailure).reasons;
      expect(reasons, hasLength(2));
      expect(reasons.first.code, 'KYC_REQUIRED');
      expect(reasons.first.action, 'verification/kyc');
      expect(reasons.last.code, 'NO_ACTIVE_GIG');
    });

    test('a malformed detail block does not mask the refusal', () {
      final failure = FailureMapper.from(
        pg('42501', 'FORBIDDEN: not allowed', details: 'not json at all'),
      );

      expect(failure, isA<PermissionFailure>());
      expect((failure as PermissionFailure).reasons, isEmpty);
    });
  });

  group('Nothing internal reaches the worker', () {
    test('an unrecognised database error does not leak its text', () {
      final failure = FailureMapper.from(pg(
        '42P01',
        'relation "public.worker_gigs" does not exist',
      ));

      expect(failure.message, isNot(contains('relation')));
      expect(failure.message, isNot(contains('public.')));
      // The detail survives for logs and crash reporting only.
      expect(failure.debugDetail, contains('relation'));
    });

    test('an internal server error shows a plain sentence', () {
      final failure = FailureMapper.from(pg(
        'XX000',
        'SQLSTATE[XX000]: internal error at character 42',
      ));

      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Something went wrong at our end. Please try again.');
      expect(failure.message, isNot(contains('SQLSTATE')));
    });

    test('a raw exception becomes an unexpected failure, not its toString', () {
      final failure = FailureMapper.from(StateError('Bad state: null check'));

      expect(failure, isA<UnexpectedFailure>());
      expect(failure.message, 'Something went wrong. Please try again.');
      expect(failure.message, isNot(contains('Bad state')));
    });
  });

  group('Transport failures', () {
    test('a socket error is a retryable network failure', () {
      final failure = FailureMapper.from(const SocketException('no route to host'));

      expect(failure, isA<NetworkFailure>());
      expect(failure.isRetryable, isTrue);
      expect(failure.message, contains('connection'));
    });
  });

  test('an AppFailure passes through unchanged', () {
    const original = ConflictFailure(message: 'Someone else took this job.');
    expect(identical(FailureMapper.from(original), original), isTrue);
  });
}
