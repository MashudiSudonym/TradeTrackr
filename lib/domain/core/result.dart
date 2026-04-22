import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for operations that can fail.
///
/// Represents either a success with a value [T], or a failure with an error.
/// This is a type-safe alternative to throwing exceptions.
@freezed
class Result<T> with _$Result<T> {
  const Result._();

  /// Creates a successful result with the given [value].
  const factory Result.success(T value) = Success<T>;

  /// Creates a failed result with the given [error].
  const factory Result.failure(String error) = Failure<T>;

  /// Returns true if this result is a success.
  bool get isSuccess => maybeWhen(
        success: (_) => true,
        orElse: () => false,
      );

  /// Returns true if this result is a failure.
  bool get isFailure => !isSuccess;

  /// Returns the success value, or null if this is a failure.
  T? get value => maybeMap(
        success: (data) => data.value,
        orElse: () => null,
      );

  /// Returns the error message, or null if this is a success.
  String? get error => maybeMap(
        failure: (data) => data.error,
        orElse: () => null,
      );

  /// Maps the success value to a new type [R].
  Result<R> map<R>(R Function(T value) onSuccess) {
    return when(
      success: (value) => Result.success(onSuccess(value)),
      failure: (error) => Result.failure(error),
    );
  }

  /// Flat maps the success value to a new Result.
  Result<R> flatMap<R>(Result<R> Function(T value) onSuccess) {
    return when(
      success: (value) => onSuccess(value),
      failure: (error) => Result.failure(error),
    );
  }

  /// Returns the success value, or [orElse] if this is a failure.
  T getOrElse(T orElse) {
    return when(
      success: (value) => value,
      failure: (_) => orElse,
    );
  }

  /// Returns the success value, or throws with the error message.
  T getOrThrow([Object Function(String error)? errorMapper]) {
    return when(
      success: (value) => value,
      failure: (error) {
        throw errorMapper != null ? errorMapper(error) : Exception(error);
      },
    );
  }
}
