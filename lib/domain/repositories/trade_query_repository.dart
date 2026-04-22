import '../entities/closed_position.dart';
import '../entities/open_position.dart';
import '../entities/trade_analytics.dart';
import '../entities/trade_filter.dart';
import '../enums/trade_side.dart';
import '../enums/close_reason.dart';
import '../core/result.dart';

/// Read-only operations for trade positions.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains query operations.
abstract class TradeQueryRepository {
  /// Get all closed positions with optional filtering.
  Future<Result<List<ClosedPosition>>> getClosedPositions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  });

  /// Get a specific closed position by ID.
  Future<Result<ClosedPosition?>> getClosedPositionById(
    String id,
    String userId,
  );

  /// Get all open positions.
  Future<Result<List<OpenPosition>>> getOpenPositions(
    String userId,
  );

  /// Get a specific open position by ID.
  Future<Result<OpenPosition?>> getOpenPositionById(
    String id,
    String userId,
  );

  /// Get computed analytics for the specified filter.
  Future<Result<TradeAnalytics>> getAnalytics(
    String userId,
    TradeFilter filter,
  );
}
