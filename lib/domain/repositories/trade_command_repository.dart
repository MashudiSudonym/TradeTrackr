import '../entities/closed_position.dart';
import '../entities/open_position.dart';
import '../entities/finance_record.dart';
import '../enums/close_reason.dart';
import '../core/result.dart';

/// Write operations for trade positions.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains command operations.
abstract class TradeCommandRepository {
  /// Add a new closed position.
  Future<Result<ClosedPosition>> addClosedPosition(
    ClosedPosition position,
  );

  /// Update an existing closed position.
  Future<Result<ClosedPosition>> updateClosedPosition(
    ClosedPosition position,
  );

  /// Delete a closed position by ID.
  Future<Result<void>> deleteClosedPosition(String id);

  /// Add a new open position.
  Future<Result<OpenPosition>> addOpenPosition(
    OpenPosition position,
  );

  /// Update an existing open position.
  Future<Result<OpenPosition>> updateOpenPosition(
    OpenPosition position,
  );

  /// Delete an open position by ID.
  Future<Result<void>> deleteOpenPosition(String id);

  /// Close an open position (converts it to a closed position).
  Future<Result<ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  });

  /// Add a new finance record.
  Future<Result<FinanceRecord>> addFinanceRecord(
    FinanceRecord record,
  );
}
