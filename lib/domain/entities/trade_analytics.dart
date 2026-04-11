/// Computed analytics from the user's trade history.
class TradeAnalytics {
  final int totalTrades;
  final int openPositions;
  final double winRate;
  final double totalProfitLoss;
  final double averageProfit;
  final double largestWin;
  final double largestLoss;
  final double profitFactor;
  final double? averageRiskRewardRatio;
  final Duration? averageHoldingDuration;
  final double accountBalance;
  final double totalDeposits;
  final double totalWithdrawals;
  final String? bestSymbol;
  final String? worstSymbol;
  final int consecutiveLosses;

  const TradeAnalytics({
    required this.totalTrades,
    required this.openPositions,
    required this.winRate,
    required this.totalProfitLoss,
    required this.averageProfit,
    required this.largestWin,
    required this.largestLoss,
    required this.profitFactor,
    this.averageRiskRewardRatio,
    this.averageHoldingDuration,
    required this.accountBalance,
    required this.totalDeposits,
    required this.totalWithdrawals,
    this.bestSymbol,
    this.worstSymbol,
    this.consecutiveLosses = 0,
  });

  static const empty = TradeAnalytics(
    totalTrades: 0,
    openPositions: 0,
    winRate: 0,
    totalProfitLoss: 0,
    averageProfit: 0,
    largestWin: 0,
    largestLoss: 0,
    profitFactor: 0,
    accountBalance: 0,
    totalDeposits: 0,
    totalWithdrawals: 0,
  );

  /// Formatted win rate string.
  String get formattedWinRate => '${winRate.toStringAsFixed(1)}%';

  /// Formatted total P/L string.
  String get formattedTotalPnL =>
      totalProfitLoss >= 0
          ? '+${totalProfitLoss.toStringAsFixed(2)}'
          : totalProfitLoss.toStringAsFixed(2);
}
