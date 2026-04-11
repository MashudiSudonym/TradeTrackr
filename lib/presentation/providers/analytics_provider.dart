import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/trade_analytics.dart';
import '../mock/mock_data.dart';

/// Provides computed trade analytics from mock data.
///
/// TODO: Replace mock data with real repository when data layer is built.
final analyticsProvider =
    AsyncNotifierProvider<AnalyticsNotifier, TradeAnalytics>(
  AnalyticsNotifier.new,
);

class AnalyticsNotifier extends AsyncNotifier<TradeAnalytics> {
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
final formattedWinRateProvider = Provider<String>((ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '0.0%';
  return analytics.formattedWinRate;
});

/// Formatted total P/L derived from analytics.
final formattedTotalPnLProvider = Provider<String>((ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '\$0.00';
  final pnl = analytics.totalProfitLoss;
  final prefix = pnl >= 0 ? '+\$' : '-\$';
  return '$prefix${pnl.abs().toStringAsFixed(2)}';
});

/// Formatted account balance derived from analytics.
final formattedBalanceProvider = Provider<String>((ref) {
  final analytics = ref.watch(analyticsProvider).value;
  if (analytics == null) return '\$0.00';
  return '\$${analytics.accountBalance.toStringAsFixed(2)}';
});
