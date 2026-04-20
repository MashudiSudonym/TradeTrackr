import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/trade_analytics.dart';
import '../../domain/entities/trade_filter.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/repositories/trade_query_repository.dart';
import '../datasources/trade_local_data_source.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of TradeQueryRepository.
///
/// Uses TradeLocalDataSource for read operations.
class TradeQueryRepositoryImpl implements TradeQueryRepository {
  final TradeLocalDataSource _localDataSource;

  TradeQueryRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<ClosedPosition>>> getClosedPositions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  }) async {
    try {
      await _localDataSource.queryClosedPositions(
        userId: '', // TODO: Get from auth state
        startDate: startDate,
        endDate: endDate,
        symbols: symbols,
        side: side?.name.toUpperCase(),
        reasons: reasons?.map((r) => r.name.toUpperCase()).toList(),
      );

      // Convert maps to DTOs then to entities
      // For now, return empty list - will implement full conversion with DTOs
      return const Right([]);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get closed positions: $e'));
    }
  }

  @override
  Future<Either<Failure, ClosedPosition?>> getClosedPositionById(String id) async {
    try {
      final dataMap = await _localDataSource.getClosedPositionById(id);
      if (dataMap == null) return const Right(null);

      // TODO: Convert map to DTO then to entity
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get position: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OpenPosition>>> getOpenPositions() async {
    try {
      await _localDataSource.getAllOpenPositions(
        '', // TODO: Get from auth state
      );

      // TODO: Convert maps to entities
      return const Right([]);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get open positions: $e'));
    }
  }

  @override
  Future<Either<Failure, OpenPosition?>> getOpenPositionById(String id) async {
    try {
      final dataMap = await _localDataSource.getOpenPositionById(id);
      if (dataMap == null) return const Right(null);

      // TODO: Convert map to entity
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get open position: $e'));
    }
  }

  @override
  Future<Either<Failure, TradeAnalytics>> getAnalytics(
    TradeFilter filter,
  ) async {
    try {
      await _localDataSource.queryClosedPositions(
        userId: '', // TODO: Get from auth state
        startDate: filter.startDate,
        endDate: filter.endDate,
        symbols: filter.symbols.isEmpty ? null : filter.symbols,
        side: filter.side?.name.toUpperCase(),
        reasons:
            filter.reasons.isEmpty ? null : filter.reasons.map((r) => r.name.toUpperCase()).toList(),
      );

      // TODO: Convert maps to entities and compute analytics
      return const Right(TradeAnalytics.empty);
    } catch (e) {
      return Left(DatabaseFailure('Failed to compute analytics: $e'));
    }
  }
}
