import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/trade_analytics.dart';
import '../../domain/entities/trade_filter.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/repositories/trade_query_repository.dart';
import '../../domain/core/result.dart';
import '../datasources/trade_local_data_source.dart';
import '../models/trade_position_dto.dart';

/// Implementation of TradeQueryRepository.
///
/// Uses TradeLocalDataSource for read operations.
class TradeQueryRepositoryImpl implements TradeQueryRepository {
  final TradeLocalDataSource _localDataSource;

  TradeQueryRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<ClosedPosition>>> getClosedPositions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  }) async {
    try {
      final dataMaps = await _localDataSource.queryClosedPositions(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        symbols: symbols,
        side: side?.name.toUpperCase(),
        reasons: reasons?.map((r) => r.name.toUpperCase()).toList(),
      );

      final dtos = dataMaps
          .map((map) => ClosedPositionDto.fromJson(map))
          .toList();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failure('Failed to get closed positions: $e');
    }
  }

  @override
  Future<Result<ClosedPosition?>> getClosedPositionById(
    String id,
    String userId,
  ) async {
    try {
      final dataMap = await _localDataSource.getClosedPositionById(id);
      if (dataMap == null) return const Result.success(null);

      final dto = ClosedPositionDto.fromJson(dataMap);
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure('Failed to get position: $e');
    }
  }

  @override
  Future<Result<List<OpenPosition>>> getOpenPositions(
    String userId,
  ) async {
    try {
      final dataMaps = await _localDataSource.getAllOpenPositions(userId);

      final dtos = dataMaps
          .map((map) => OpenPositionDto.fromJson(map))
          .toList();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failure('Failed to get open positions: $e');
    }
  }

  @override
  Future<Result<OpenPosition?>> getOpenPositionById(
    String id,
    String userId,
  ) async {
    try {
      final dataMap = await _localDataSource.getOpenPositionById(id);
      if (dataMap == null) return const Result.success(null);

      final dto = OpenPositionDto.fromJson(dataMap);
      return Result.success(dto.toEntity());
    } catch (e) {
      return Result.failure('Failed to get open position: $e');
    }
  }

  @override
  Future<Result<TradeAnalytics>> getAnalytics(
    String userId,
    TradeFilter filter,
  ) async {
    try {
      final dataMaps = await _localDataSource.queryClosedPositions(
        userId: userId,
        startDate: filter.startDate,
        endDate: filter.endDate,
        symbols: filter.symbols.isEmpty ? null : filter.symbols,
        side: filter.side?.name.toUpperCase(),
        reasons:
            filter.reasons.isEmpty ? null : filter.reasons.map((r) => r.name.toUpperCase()).toList(),
      );

      final dtos = dataMaps
          .map((map) => ClosedPositionDto.fromJson(map))
          .toList();
      final positions = dtos.map((dto) => dto.toEntity()).toList();

      // Compute analytics from positions
      final analytics = _computeAnalytics(positions);
      return Result.success(analytics);
    } catch (e) {
      return Result.failure('Failed to compute analytics: $e');
    }
  }

  TradeAnalytics _computeAnalytics(List<ClosedPosition> positions) {
    if (positions.isEmpty) {
      return TradeAnalytics.empty;
    }

    final totalProfit = positions.fold<double>(
      0.0,
      (sum, p) => sum + p.profit,
    );

    final winCount = positions.where((p) => p.profit > 0).length;
    final lossCount = positions.where((p) => p.profit < 0).length;
    final winRate = winCount / positions.length;

    final avgWin = positions
        .where((p) => p.profit > 0)
        .fold<double>(0.0, (sum, p) => sum + p.profit) /
        (winCount > 0 ? winCount : 1);

    final avgLoss = positions
        .where((p) => p.profit < 0)
        .fold<double>(0.0, (sum, p) => sum + p.profit.abs()) /
        (lossCount > 0 ? lossCount : 1);

    final profitFactor = avgLoss > 0 ? avgWin / avgLoss : 0.0;

    // Find best and worst symbols by total profit
    final symbolProfits = <String, double>{};
    for (final pos in positions) {
      symbolProfits[pos.symbol] = (symbolProfits[pos.symbol] ?? 0) + pos.profit;
    }
    final sortedSymbols = symbolProfits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final bestSymbol = sortedSymbols.isNotEmpty && sortedSymbols.first.value > 0
        ? sortedSymbols.first.key
        : null;
    final worstSymbol = sortedSymbols.isNotEmpty && sortedSymbols.last.value < 0
        ? sortedSymbols.last.key
        : null;

    // Calculate consecutive losses
    var consecutiveLosses = 0;
    var currentStreak = 0;
    for (final pos in positions) {
      if (pos.profit < 0) {
        currentStreak++;
        consecutiveLosses = consecutiveLosses > currentStreak
            ? consecutiveLosses
            : currentStreak;
      } else {
        currentStreak = 0;
      }
    }

    return TradeAnalytics(
      totalTrades: positions.length,
      openPositions: 0, // Computed separately
      winRate: winRate * 100, // Percentage
      totalProfitLoss: totalProfit,
      averageProfit: totalProfit / positions.length,
      profitFactor: profitFactor,
      largestWin: positions
          .map((p) => p.profit)
          .reduce((a, b) => a > b ? a : b),
      largestLoss: positions
          .map((p) => p.profit)
          .reduce((a, b) => a < b ? a : b),
      accountBalance: 0, // Computed from finance records
      totalDeposits: 0, // Computed from finance records
      totalWithdrawals: 0, // Computed from finance records
      bestSymbol: bestSymbol,
      worstSymbol: worstSymbol,
      consecutiveLosses: consecutiveLosses,
    );
  }
}
