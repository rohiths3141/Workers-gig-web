import 'package:flutter_test/flutter_test.dart';
import 'package:wervexa_worker/core/errors/app_failure.dart';
import 'package:wervexa_worker/core/errors/result.dart';

/// Result exists so a caller cannot reach a value without handling failure.
/// That is the structural reason this app has no dummy-data fallback: there is
/// nowhere to quietly substitute one.
void main() {
  group('Ok and Err', () {
    test('an Ok carries its value', () {
      const result = Ok(42);
      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('an Err carries its failure and no value', () {
      const failure = ConflictFailure(message: 'Someone else took this job.');
      const result = Err<int>(failure);

      expect(result.isErr, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('fold forces both cases to be handled', () {
      const ok = Ok(10);
      const err = Err<int>(NetworkFailure());

      expect(ok.fold((v) => 'got $v', (f) => 'failed'), 'got 10');
      expect(err.fold((v) => 'got $v', (f) => 'failed'), 'failed');
    });

    test('map transforms a value and leaves a failure alone', () {
      expect(const Ok(5).map((v) => v * 2).valueOrNull, 10);

      const failure = NotFoundFailure(message: 'gone');
      final mapped = const Err<int>(failure).map((v) => v * 2);
      expect(mapped.failureOrNull, failure);
    });

    test('flatMap chains without unwrapping', () {
      Result<int> doubled(int v) => Ok(v * 2);
      Result<int> fails(int v) => const Err(NetworkFailure());

      expect(const Ok(5).flatMap(doubled).valueOrNull, 10);
      expect(const Ok(5).flatMap(fails).isErr, isTrue);
      expect(const Err<int>(NetworkFailure()).flatMap(doubled).isErr, isTrue);
    });

    test('unwrap throws on a failure rather than returning a default', () {
      expect(() => const Err<int>(NetworkFailure()).unwrap(), throwsA(isA<AppFailure>()));
    });
  });

  group('Retryability', () {
    test('transport failures are retryable', () {
      expect(const NetworkFailure().isRetryable, isTrue);
      expect(const TimeoutFailure().isRetryable, isTrue);
      expect(const ServerFailure().isRetryable, isTrue);
    });

    test('refusals are not — retrying changes nothing', () {
      expect(const PermissionFailure(message: 'no').isRetryable, isFalse);
      expect(const ConflictFailure(message: 'taken').isRetryable, isFalse);
      expect(const ValidationFailure(message: 'bad').isRetryable, isFalse);
      expect(const NotFoundFailure(message: 'gone').isRetryable, isFalse);
    });
  });
}
