import '../entities/closed_position.dart';
import '../entities/open_position.dart';
import '../enums/close_reason.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Write operations for trade positions.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains command operations.
abstract class TradeCommandRepository {
  /// Add a new closed position.
  Future<Either<Failure, ClosedPosition>> addClosedPosition(
    ClosedPosition position,
  );

  /// Update an existing closed position.
  Future<Either<Failure, ClosedPosition>> updateClosedPosition(
    ClosedPosition position,
  );

  /// Delete a closed position by ID.
  Future<Either<Failure, void>> deleteClosedPosition(String id);

  /// Add a new open position.
  Future<Either<Failure, OpenPosition>> addOpenPosition(
    OpenPosition position,
  );

  /// Update an existing open position.
  Future<Either<Failure, OpenPosition>> updateOpenPosition(
    OpenPosition position,
  );

  /// Delete an open position by ID.
  Future<Either<Failure, void>> deleteOpenPosition(String id);

  /// Close an open position (converts it to a closed position).
  Future<Either<Failure, ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  });
}
