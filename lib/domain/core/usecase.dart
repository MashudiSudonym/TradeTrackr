import 'result.dart';

/// Base class for all use cases.
///
/// Use cases encapsulate business logic and interact with repositories.
/// Each use case should have a single responsibility (SRP).
abstract class UseCase<T, P> {
  /// Executes the use case with the given [params].
  ///
  /// Returns a [Result] containing either the success value of type [T],
  /// or a failure with an error message.
  Future<Result<T>> call(P params);
}

/// Marker class for use cases that don't require parameters.
///
/// Use this as the type parameter when a use case has no parameters.
class NoParams {
  const NoParams();
}
