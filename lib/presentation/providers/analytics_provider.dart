import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/trade_analytics.dart';
import '../mock/mock_data.dart';

part 'analytics_provider.g.dart';

/// Provides computed trade analytics from mock data.
///
/// TODO: Replace mock data with real repository when data layer is built.
@riverpod
class Analytics extends _$Analytics {
  @override
  Future<TradeAnalytics> build() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.mockAnalytics;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Formatted win rate derived from analytics.
@riverpod
String formattedWinRate(Ref ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '0.0%';
  return analytics.formattedWinRate;
}

/// Formatted total P/L derived from analytics.
@riverpod
String formattedTotalPnL(Ref ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '\$0.00';
  final pnl = analytics.totalProfitLoss;
  final prefix = pnl >= 0 ? '+\$' : '-\$';
  return '$prefix${pnl.abs().toStringAsFixed(2)}';
}

/// Formatted account balance derived from analytics.
@riverpod
String formattedBalance(Ref ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '\$0.00';
  return '\$${analytics.accountBalance.toStringAsFixed(2)}';
}
