import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/repositories/trade_command_repository.dart';
import '../datasources/trade_local_data_source.dart';
import '../../domain/core/result.dart';

/// Implementation of TradeCommandRepository.
///
/// Uses TradeLocalDataSource for write operations.
class TradeCommandRepositoryImpl implements TradeCommandRepository {
  final TradeLocalDataSource _localDataSource;

  TradeCommandRepositoryImpl(this._localDataSource);

  @override
  Future<Result<ClosedPosition>> addClosedPosition(
    ClosedPosition position,
  ) async {
    try {
      // Convert entity to map (using DTO in production)
      final dataMap = {
        'id': position.id,
        'user_id': position.userId,
        'symbol': position.symbol,
        'open_time': position.openTime,
        'close_time': position.closeTime,
        'volume': position.volume,
        'side': position.side.name.toUpperCase(),
        'open_price': position.openPrice,
        'close_price': position.closePrice,
        'stop_loss': position.stopLoss,
        'take_profit': position.takeProfit,
        'swap': position.swap,
        'commission': position.commission,
        'profit': position.profit,
        'reason': position.reason.name.toUpperCase(),
        'created_at': position.createdAt,
        'updated_at': position.updatedAt,
        'is_synced': position.isSynced,
      };

      await _localDataSource.insertClosedPosition(dataMap);
      return Result.success(position);
    } catch (e) {
      return Result.failure('Failed to add position: $e');
    }
  }

  @override
  Future<Result<ClosedPosition>> updateClosedPosition(
    ClosedPosition position,
  ) async {
    try {
      final dataMap = {
        'id': position.id,
        'user_id': position.userId,
        'symbol': position.symbol,
        'open_time': position.openTime,
        'close_time': position.closeTime,
        'volume': position.volume,
        'side': position.side.name.toUpperCase(),
        'open_price': position.openPrice,
        'close_price': position.closePrice,
        'stop_loss': position.stopLoss,
        'take_profit': position.takeProfit,
        'swap': position.swap,
        'commission': position.commission,
        'profit': position.profit,
        'reason': position.reason.name.toUpperCase(),
        'created_at': position.createdAt,
        'updated_at': DateTime.now(),
        'is_synced': false, // Mark for re-sync on update
      };

      await _localDataSource.updateClosedPosition(dataMap);
      return Result.success(position.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      return Result.failure('Failed to update position: $e');
    }
  }

  @override
  Future<Result<void>> deleteClosedPosition(String id) async {
    try {
      await _localDataSource.deleteClosedPosition(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to delete position: $e');
    }
  }

  @override
  Future<Result<OpenPosition>> addOpenPosition(
    OpenPosition position,
  ) async {
    try {
      final dataMap = {
        'id': position.id,
        'user_id': position.userId,
        'symbol': position.symbol,
        'open_time': position.openTime,
        'volume': position.volume,
        'side': position.side.name.toUpperCase(),
        'open_price': position.openPrice,
        'current_price': position.currentPrice,
        'stop_loss': position.stopLoss,
        'take_profit': position.takeProfit,
        'swap': position.swap,
        'commission': position.commission,
        'profit': position.profit,
        'created_at': position.createdAt,
        'updated_at': position.updatedAt,
        'is_synced': position.isSynced,
      };

      await _localDataSource.insertOpenPosition(dataMap);
      return Result.success(position);
    } catch (e) {
      return Result.failure('Failed to add open position: $e');
    }
  }

  @override
  Future<Result<OpenPosition>> updateOpenPosition(
    OpenPosition position,
  ) async {
    try {
      final dataMap = {
        'id': position.id,
        'user_id': position.userId,
        'symbol': position.symbol,
        'open_time': position.openTime,
        'volume': position.volume,
        'side': position.side.name.toUpperCase(),
        'open_price': position.openPrice,
        'current_price': position.currentPrice,
        'stop_loss': position.stopLoss,
        'take_profit': position.takeProfit,
        'swap': position.swap,
        'commission': position.commission,
        'profit': position.profit,
        'created_at': position.createdAt,
        'updated_at': DateTime.now(),
        'is_synced': false,
      };

      await _localDataSource.updateOpenPosition(dataMap);
      return Result.success(position.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      return Result.failure('Failed to update open position: $e');
    }
  }

  @override
  Future<Result<void>> deleteOpenPosition(String id) async {
    try {
      await _localDataSource.deleteOpenPosition(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to delete open position: $e');
    }
  }

  @override
  Future<Result<ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  }) async {
    try {
      // 1. Fetch open position
      final openDataMap = await _localDataSource.getOpenPositionById(openPositionId);
      if (openDataMap == null) {
        return const Result.failure('Open position not found');
      }

      // TODO: Convert map to OpenPosition entity via DTO
      // For now, create a mock entity
      final openPosition = OpenPosition(
        id: openDataMap['id'] as String,
        userId: openDataMap['user_id'] as String,
        symbol: openDataMap['symbol'] as String,
        openTime: openDataMap['open_time'] as DateTime,
        volume: (openDataMap['volume'] as num).toDouble(),
        side: openDataMap['side'] == 'BUY' ? TradeSide.buy : TradeSide.sell,
        openPrice: (openDataMap['open_price'] as num).toDouble(),
        currentPrice: openDataMap['current_price'] as double?,
        stopLoss: openDataMap['stop_loss'] as double?,
        takeProfit: openDataMap['take_profit'] as double?,
        swap: (openDataMap['swap'] as num?)?.toDouble() ?? 0.0,
        commission: (openDataMap['commission'] as num?)?.toDouble() ?? 0.0,
        profit: (openDataMap['profit'] as num).toDouble(),
        createdAt: openDataMap['created_at'] as DateTime,
        updatedAt: openDataMap['updated_at'] as DateTime,
        isSynced: openDataMap['is_synced'] as bool? ?? false,
      );

      // 2. Calculate profit
      final profit = openPosition.side.calculateProfit(
        openPosition.openPrice,
        closePrice,
        openPosition.volume,
      );

      // 3. Create closed position
      final closedPosition = ClosedPosition(
        id: openPosition.id,
        userId: openPosition.userId,
        symbol: openPosition.symbol,
        openTime: openPosition.openTime,
        closeTime: closeTime,
        volume: openPosition.volume,
        side: openPosition.side,
        openPrice: openPosition.openPrice,
        closePrice: closePrice,
        stopLoss: openPosition.stopLoss,
        takeProfit: openPosition.takeProfit,
        swap: openPosition.swap,
        commission: openPosition.commission,
        profit: profit,
        reason: reason,
        createdAt: openPosition.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      // 4. Delete open position and insert closed position
      await _localDataSource.deleteOpenPosition(openPositionId);
      final closedDataMap = {
        'id': closedPosition.id,
        'user_id': closedPosition.userId,
        'symbol': closedPosition.symbol,
        'open_time': closedPosition.openTime,
        'close_time': closedPosition.closeTime,
        'volume': closedPosition.volume,
        'side': closedPosition.side.name.toUpperCase(),
        'open_price': closedPosition.openPrice,
        'close_price': closedPosition.closePrice,
        'stop_loss': closedPosition.stopLoss,
        'take_profit': closedPosition.takeProfit,
        'swap': closedPosition.swap,
        'commission': closedPosition.commission,
        'profit': closedPosition.profit,
        'reason': closedPosition.reason.name.toUpperCase(),
        'created_at': closedPosition.createdAt,
        'updated_at': closedPosition.updatedAt,
        'is_synced': closedPosition.isSynced,
      };
      await _localDataSource.insertClosedPosition(closedDataMap);

      return Result.success(closedPosition);
    } catch (e) {
      return Result.failure('Failed to close position: $e');
    }
  }
}
