export 'app_failure.dart';

import 'app_failure.dart';

/// Result<T> — a value or a failure, never both.
///
/// Mirrors the worker-app pattern exactly. Nothing in this codebase uses
/// exceptions to signal expected failures: database RPCs raise, the SDK throws,
/// the FailureMapper catches, and callers deal with Result<T>.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;

  @override
  String toString() => 'Err($failure)';
}

// ignore_for_file: avoid_returning_null_for_void
extension ResultX<T> on Result<T> {
  T? get valueOrNull => switch (this) {
        Ok(:final value) => value,
        Err() => null,
      };

  AppFailure? get failureOrNull => switch (this) {
        Ok() => null,
        Err(:final failure) => failure,
      };

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  R fold<R>(
    R Function(T value) onOk,
    R Function(AppFailure failure) onErr,
  ) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final failure) => onErr(failure),
      };
}
