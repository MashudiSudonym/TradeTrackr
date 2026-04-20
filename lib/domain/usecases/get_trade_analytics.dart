import '../entities/trade_analytics.dart';
import '../entities/trade_filter.dart';
import '../repositories/trade_query_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for computing trade analytics.
///
/// Follows SRP - only handles computing analytics from trade history.
class GetTradeAnalyticsUseCase {
  final TradeQueryRepository _repository;

  GetTradeAnalyticsUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with failure if computation fails.
  /// Returns [Right] with computed analytics on success.
  Future<Either<Failure, TradeAnalytics>> execute(
    TradeFilter filter,
  ) async {
    return await _repository.getAnalytics(filter);
  }
}
