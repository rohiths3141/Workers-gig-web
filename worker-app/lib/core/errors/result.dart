import 'app_failure.dart';

/// The outcome of an operation that is expected to be able to fail.
///
/// Repositories return `Result<T>` rather than throwing, so a caller cannot
/// silently ignore failure: to reach the value you must deal with the other
/// case. This is what stops the old application's habit of catching an error
/// and substituting sample data.
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(AppFailure failure) = Err<T>;

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  /// The value, or null when this is a failure.
  T? get valueOrNull => switch (this) { Ok<T>(:final value) => value, Err<T>() => null };

  /// The failure, or null when this succeeded.
  AppFailure? get failureOrNull =>
      switch (this) { Ok<T>() => null, Err<T>(:final failure) => failure };

  R fold<R>(R Function(T value) onOk, R Function(AppFailure failure) onErr) =>
      switch (this) {
        Ok<T>(:final value) => onOk(value),
        Err<T>(:final failure) => onErr(failure),
      };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok<T>(:final value) => Ok<R>(transform(value)),
        Err<T>(:final failure) => Err<R>(failure),
      };

  Future<Result<R>> mapAsync<R>(Future<R> Function(T value) transform) async =>
      switch (this) {
        Ok<T>(:final value) => Ok<R>(await transform(value)),
        Err<T>(:final failure) => Err<R>(failure),
      };

  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        Ok<T>(:final value) => transform(value),
        Err<T>(:final failure) => Err<R>(failure),
      };

  /// Unwrap, or throw. Only for tests and for code paths that have already
  /// checked [isOk].
  T unwrap() => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>(:final failure) => throw failure,
      };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok<T>, value);

  @override
  String toString() => 'Ok($value)';
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;

  @override
  bool operator ==(Object other) => other is Err<T> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Err<T>, failure);

  @override
  String toString() => 'Err($failure)';
}
