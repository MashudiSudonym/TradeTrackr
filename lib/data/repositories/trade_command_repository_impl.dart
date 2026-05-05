import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/repositories/trade_command_repository.dart';
import '../datasources/trade_local_data_source.dart';
import '../../domain/core/result.dart';
import '../models/trade_position_dto.dart';
import '../models/finance_record_dto.dart';

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
      final dto = ClosedPositionDto.fromEntity(position);
      final dataMap = _dtoMapForDrift(
        dto.toJson(),
        openTime: position.openTime,
        closeTime: position.closeTime,
        createdAt: position.createdAt,
        updatedAt: position.updatedAt,
      );

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
      final now = DateTime.now();
      final dto = ClosedPositionDto.fromEntity(position.copyWith(
        updatedAt: now,
        isSynced: false,
      ));
      final dataMap = _dtoMapForDrift(
        dto.toJson(),
        openTime: position.openTime,
        closeTime: position.closeTime,
        createdAt: position.createdAt,
        updatedAt: now,
      );
      dataMap['is_synced'] = false;

      await _localDataSource.updateClosedPosition(dataMap);
      return Result.success(position.copyWith(updatedAt: now));
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
      final dto = OpenPositionDto.fromEntity(position);
      final dataMap = _dtoMapForDrift(
        dto.toJson(),
        openTime: position.openTime,
        createdAt: position.createdAt,
        updatedAt: position.updatedAt,
      );

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
      final now = DateTime.now();
      final dto = OpenPositionDto.fromEntity(position.copyWith(
        updatedAt: now,
        isSynced: false,
      ));
      final dataMap = _dtoMapForDrift(
        dto.toJson(),
        openTime: position.openTime,
        createdAt: position.createdAt,
        updatedAt: now,
      );
      dataMap['is_synced'] = false;

      await _localDataSource.updateOpenPosition(dataMap);
      return Result.success(position.copyWith(updatedAt: now));
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

      final openDto = OpenPositionDto.fromJson(openDataMap);
      final openPosition = openDto.toEntity();

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
      final closedDto = ClosedPositionDto.fromEntity(closedPosition);
      final closedDataMap = _dtoMapForDrift(
        closedDto.toJson(),
        openTime: closedPosition.openTime,
        closeTime: closedPosition.closeTime,
        createdAt: closedPosition.createdAt,
        updatedAt: closedPosition.updatedAt,
      );
      await _localDataSource.insertClosedPosition(closedDataMap);

      return Result.success(closedPosition);
    } catch (e) {
      return Result.failure('Failed to close position: $e');
    }
  }

  @override
  Future<Result<FinanceRecord>> addFinanceRecord(
    FinanceRecord record,
  ) async {
    try {
      final dto = FinanceRecordDto.fromEntity(record);
      final dataMap = _dtoMapForDrift(
        dto.toJson(),
        time: record.time,
        createdAt: record.createdAt,
        updatedAt: record.updatedAt,
      );

      await _localDataSource.insertFinanceRecord(dataMap);
      return Result.success(record);
    } catch (e) {
      return Result.failure('Failed to add finance record: $e');
    }
  }

  /// Converts DTO JSON map DateTime string fields to DateTime objects
  /// for Drift compatibility. DTO toJson() produces ISO8601 strings,
  /// but Drift expects DateTime objects in the map.
  Map<String, dynamic> _dtoMapForDrift(
    Map<String, dynamic> dtoMap, {
    DateTime? openTime,
    DateTime? closeTime,
    DateTime? time,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final driftMap = Map<String, dynamic>.from(dtoMap);
    if (openTime != null) driftMap['open_time'] = openTime;
    if (closeTime != null) driftMap['close_time'] = closeTime;
    if (time != null) driftMap['time'] = time;
    if (createdAt != null) driftMap['created_at'] = createdAt;
    if (updatedAt != null) driftMap['updated_at'] = updatedAt;
    return driftMap;
  }
}
