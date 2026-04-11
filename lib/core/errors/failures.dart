/// Base failure class for the Either pattern.
///
/// All repository methods return `Either<Failure, T>` to provide
/// type-safe error handling without exceptions.
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Database operation failure (Drift/SQLite errors).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Input validation failure.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Network/connectivity failure.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Sync operation failure (Supabase push/pull errors).
class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

/// CSV parse/import failure.
class CsvParseFailure extends Failure {
  const CsvParseFailure(super.message);
}

/// Authentication failure (Supabase Auth errors).
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
