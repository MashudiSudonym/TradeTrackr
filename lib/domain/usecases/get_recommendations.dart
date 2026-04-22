import '../entities/recommendation.dart';
import '../entities/trade_analytics.dart';
import '../entities/trade_filter.dart';
import '../enums/severity.dart';
import '../repositories/trade_query_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for generating trading recommendations.
///
/// Follows SRP - only handles generating recommendations from analytics.
class GetRecommendationsUseCase extends UseCase<List<Recommendation>, GetRecommendationsParams> {
  final TradeQueryRepository _repository;

  GetRecommendationsUseCase(this._repository);

  @override
  Future<Result<List<Recommendation>>> call(GetRecommendationsParams params) async {
    final analyticsResult = await _repository.getAnalytics(params.userId, params.filter);

    return analyticsResult.when(
      success: (analytics) {
        final recommendations = _generateRecommendations(analytics);
        return Result.success(recommendations);
      },
      failure: (error) => Result.failure(error),
    );
  }

  /// Generate recommendations from analytics data.
  List<Recommendation> _generateRecommendations(TradeAnalytics analytics) {
    final recommendations = <Recommendation>[];

    // Best performing symbol (minimum 5 trades)
    if (analytics.bestSymbol != null && analytics.totalTrades >= 5) {
      recommendations.add(Recommendation(
        title: 'Best Performing Symbol',
        description: '${analytics.bestSymbol} has the highest total net profit',
        severity: Severity.info,
      ));
    }

    // Consecutive loss alert
    if (analytics.consecutiveLosses >= 3) {
      recommendations.add(Recommendation(
        title: 'Consecutive Losses',
        description:
            'You are on a streak of ${analytics.consecutiveLosses} consecutive losses',
        severity: Severity.critical,
      ));
    }

    // Low win rate warning
    if (analytics.totalTrades >= 10 && analytics.winRate < 40) {
      recommendations.add(Recommendation(
        title: 'Low Win Rate',
        description:
            'Your win rate is ${analytics.formattedWinRate}. Consider reviewing your strategy.',
        severity: Severity.warning,
      ));
    }

    // Negative profit factor warning
    if (analytics.profitFactor < 1.0 && analytics.totalTrades >= 5) {
      recommendations.add(Recommendation(
        title: 'Negative Profit Factor',
        description:
            'Your profit factor is ${analytics.profitFactor.toStringAsFixed(2)}. You\'re losing more than winning.',
        severity: Severity.warning,
      ));
    }

    // Good performance
    if (analytics.totalTrades >= 10 &&
        analytics.winRate >= 60 &&
        analytics.profitFactor >= 2.0) {
      recommendations.add(Recommendation(
        title: 'Strong Performance',
        description:
            'Great job! Your win rate is ${analytics.formattedWinRate} with a ${analytics.profitFactor.toStringAsFixed(2)} profit factor.',
        severity: Severity.info,
      ));
    }

    return recommendations;
  }
}

/// Parameters for get recommendations use case.
class GetRecommendationsParams {
  final String userId;
  final TradeFilter filter;

  const GetRecommendationsParams({
    required this.userId,
    required this.filter,
  });
}
