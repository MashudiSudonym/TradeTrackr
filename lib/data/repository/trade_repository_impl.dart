import 'package:drift/drift.dart';
import 'package:trade_trackr/constants.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/result.dart';

class TradeRepositoryImpl implements TradeRepository {
  final AppDatabase _db;

  TradeRepositoryImpl({required AppDatabase db}) : _db = db;

  @override
  Future<Result<List<TradeEntity>>> getTrades({
    DateTime? startDate,
    DateTime? endDate,
    String? symbol,
    String? status,
  }) async {
    try {
      final query = _db.select(_db.trades);

      if (startDate != null) {
        query.where((t) => t.openTime.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where((t) => t.openTime.isSmallerOrEqualValue(endDate));
      }
      if (symbol != null) {
        query.where((t) => t.symbol.equals(symbol));
      }
      if (status != null) {
        query.where((t) => t.tradeStatus.equals(status));
      }

      // Sort by openTime descending (newest first)
      query.orderBy([(t) => OrderingTerm.desc(t.openTime)]);

      final tradeRows = await query.get();

      final trades = tradeRows.map((row) {
        return TradeEntity(
          id: row.id,
          symbol: row.symbol,
          openTime: row.openTime,
          closeTime: row.closeTime,
          volume: row.volume,
          side: row.side,
          tradeStatus: row.tradeStatus,
          openPrice: row.openPrice,
          closePrice: row.closePrice,
          stopLoss: row.stopLoss,
          takeProfit: row.takeProfit,
          swap: row.swap,
          commission: row.commission,
          profit: row.profit,
          profitPercent: row.profitPercent,
          exitReason: row.exitReason,
          entryReason: row.entryReason,
          notes: row.notes,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        );
      }).toList();

      return Result.success(trades);
    } catch (e) {
      Constants.logger.e('Failed to get trades: $e');
      return Result.failed('Failed to get trades: $e');
    }
  }

  @override
  Future<Result<TradeEntity>> getTradeById(String id) async {
    try {
      final row = await (_db.select(
        _db.trades,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return Result.failed('Trade not found');
      }

      final trade = TradeEntity(
        id: row.id,
        symbol: row.symbol,
        openTime: row.openTime,
        closeTime: row.closeTime,
        volume: row.volume,
        side: row.side,
        tradeStatus: row.tradeStatus,
        openPrice: row.openPrice,
        closePrice: row.closePrice,
        stopLoss: row.stopLoss,
        takeProfit: row.takeProfit,
        swap: row.swap,
        commission: row.commission,
        profit: row.profit,
        profitPercent: row.profitPercent,
        exitReason: row.exitReason,
        entryReason: row.entryReason,
        notes: row.notes,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

      return Result.success(trade);
    } catch (e) {
      Constants.logger.e('Failed to get trade by id: $e');
      return Result.failed('Failed to get trade: $e');
    }
  }

  @override
  Future<Result<void>> insertTrade(TradeEntity trade) async {
    try {
      await _db
          .into(_db.trades)
          .insert(
            TradesCompanion(
              id: Value(trade.id),
              symbol: Value(trade.symbol),
              openTime: Value(trade.openTime),
              closeTime: Value(trade.closeTime),
              volume: Value(trade.volume),
              side: Value(trade.side),
              tradeStatus: Value(trade.tradeStatus),
              openPrice: Value(trade.openPrice),
              closePrice: Value(trade.closePrice),
              stopLoss: Value(trade.stopLoss),
              takeProfit: Value(trade.takeProfit),
              swap: Value(trade.swap),
              commission: Value(trade.commission),
              profit: Value(trade.profit),
              profitPercent: Value(trade.profitPercent),
              exitReason: Value(trade.exitReason),
              entryReason: Value(trade.entryReason),
              notes: Value(trade.notes),
              createdAt: Value(trade.createdAt),
              updatedAt: Value(trade.updatedAt),
            ),
          );
      return Result.success(null);
    } catch (e) {
      Constants.logger.e('Failed to insert trade: $e');
      return Result.failed('Failed to insert trade: $e');
    }
  }

  @override
  Future<Result<void>> updateTrade(TradeEntity trade) async {
    try {
      final updated = await _db
          .update(_db.trades)
          .replace(
            TradesCompanion(
              id: Value(trade.id),
              symbol: Value(trade.symbol),
              openTime: Value(trade.openTime),
              closeTime: Value(trade.closeTime),
              volume: Value(trade.volume),
              side: Value(trade.side),
              tradeStatus: Value(trade.tradeStatus),
              openPrice: Value(trade.openPrice),
              closePrice: Value(trade.closePrice),
              stopLoss: Value(trade.stopLoss),
              takeProfit: Value(trade.takeProfit),
              swap: Value(trade.swap),
              commission: Value(trade.commission),
              profit: Value(trade.profit),
              profitPercent: Value(trade.profitPercent),
              exitReason: Value(trade.exitReason),
              entryReason: Value(trade.entryReason),
              notes: Value(trade.notes),
              createdAt: Value(trade.createdAt),
              updatedAt: Value(DateTime.now()), // Always update updatedAt
            ),
          );

      if (updated) {
        return Result.success(null);
      } else {
        return Result.failed('Trade not found to update');
      }
    } catch (e) {
      Constants.logger.e('Failed to update trade: $e');
      return Result.failed('Failed to update trade: $e');
    }
  }

  @override
  Future<Result<void>> deleteTrade(String id) async {
    try {
      final deletedCount = await (_db.delete(
        _db.trades,
      )..where((t) => t.id.equals(id))).go();

      if (deletedCount > 0) {
        return Result.success(null);
      } else {
        return Result.failed('Trade not found to delete');
      }
    } catch (e) {
      Constants.logger.e('Failed to delete trade: $e');
      return Result.failed('Failed to delete trade: $e');
    }
  }
}
