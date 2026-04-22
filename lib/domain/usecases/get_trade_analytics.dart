import '../entities/trade_analytics.dart';
import '../entities/trade_filter.dart';
import '../repositories/trade_query_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for computing trade analytics.
///
/// Follows SRP - only handles computing analytics from trade history.
class GetTradeAnalyticsUseCase extends UseCase<TradeAnalytics, GetAnalyticsParams> {
  final TradeQueryRepository _repository;

  GetTradeAnalyticsUseCase(this._repository);

  @override
  Future<Result<TradeAnalytics>> call(GetAnalyticsParams params) async {
    return await _repository.getAnalytics(params.userId, params.filter);
  }
}

/// Parameters for get analytics use case.
class GetAnalyticsParams {
  final String userId;
  final TradeFilter filter;

  const GetAnalyticsParams({
    required this.userId,
    required this.filter,
  });
}
