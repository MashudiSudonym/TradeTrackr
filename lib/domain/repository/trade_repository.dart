import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/result.dart';

abstract interface class TradeRepository {
  /// Get all trades.
  /// Optionally can be filtered by [startDate], [endDate], [symbol], or [status].
  Future<Result<List<TradeEntity>>> getTrades({
    DateTime? startDate,
    DateTime? endDate,
    String? symbol,
    String? status, // 'Open' or 'Close'
  });

  /// Get a single trade by its [id].
  Future<Result<TradeEntity>> getTradeById(String id);

  /// Insert a new trade.
  Future<Result<void>> insertTrade(TradeEntity trade);

  /// Update an existing trade.
  Future<Result<void>> updateTrade(TradeEntity trade);

  /// Delete a trade by its [id].
  Future<Result<void>> deleteTrade(String id);
}
