import '../../domain/enums/close_reason.dart';
import '../../domain/enums/finance_type.dart';
import '../../domain/enums/severity.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/trade_analytics.dart';
import '../../domain/entities/user.dart';

/// Mock data for presentation layer development.
///
/// Values match the HTML reference files from Stitch.
class MockData {
  const MockData._();

  // ── User ─────────────────────────────────────────────────
  static final mockUser = User(
    id: 'user-001',
    email: 'alex.rivers@tradetrackr.com',
    displayName: 'Alex Rivers',
    createdAt: DateTime(2026, 1, 15),
    updatedAt: DateTime(2026, 4, 10),
  );

  // ── Closed Positions ─────────────────────────────────────
  static final mockClosedPositions = [
    ClosedPosition(
      id: 'tp-001',
      userId: 'user-001',
      symbol: 'BTCUSD',
      openTime: DateTime(2023, 10, 20, 8, 0),
      closeTime: DateTime(2023, 10, 24, 14, 20),
      volume: 0.5,
      side: TradeSide.buy,
      openPrice: 29500.00,
      closePrice: 31990.00,
      stopLoss: 28800.00,
      takeProfit: 32000.00,
      swap: -5.20,
      commission: -12.50,
      profit: 1245.00,
      reason: CloseReason.tp,
      createdAt: DateTime(2023, 10, 24, 14, 20),
      updatedAt: DateTime(2023, 10, 24, 14, 20),
    ),
    ClosedPosition(
      id: 'tp-002',
      userId: 'user-001',
      symbol: 'EURUSD',
      openTime: DateTime(2023, 10, 22, 7, 0),
      closeTime: DateTime(2023, 10, 23, 9, 15),
      volume: 5.0,
      side: TradeSide.sell,
      openPrice: 1.08450,
      closePrice: 1.07250,
      stopLoss: 1.09100,
      takeProfit: 1.07250,
      swap: -12.00,
      commission: -7.50,
      profit: 1420.50,
      reason: CloseReason.tp,
      createdAt: DateTime(2023, 10, 23, 9, 15),
      updatedAt: DateTime(2023, 10, 23, 9, 15),
    ),
    ClosedPosition(
      id: 'tp-003',
      userId: 'user-001',
      symbol: 'ETHUSD',
      openTime: DateTime(2023, 10, 21, 14, 0),
      closeTime: DateTime(2023, 10, 22, 18, 45),
      volume: 2.0,
      side: TradeSide.buy,
      openPrice: 1580.00,
      closePrice: 1645.00,
      stopLoss: 1550.00,
      takeProfit: 1660.00,
      swap: -3.00,
      commission: -8.00,
      profit: 890.00,
      reason: CloseReason.user,
      createdAt: DateTime(2023, 10, 22, 18, 45),
      updatedAt: DateTime(2023, 10, 22, 18, 45),
    ),
    ClosedPosition(
      id: 'tp-004',
      userId: 'user-001',
      symbol: 'NVDA',
      openTime: DateTime(2023, 10, 20, 9, 30),
      closeTime: DateTime(2023, 10, 22, 16, 5),
      volume: 100,
      side: TradeSide.buy,
      openPrice: 435.20,
      closePrice: 467.30,
      stopLoss: 425.00,
      takeProfit: 470.00,
      swap: 0,
      commission: -2.50,
      profit: 3210.15,
      reason: CloseReason.user,
      createdAt: DateTime(2023, 10, 22, 16, 5),
      updatedAt: DateTime(2023, 10, 22, 16, 5),
    ),
    ClosedPosition(
      id: 'tp-005',
      userId: 'user-001',
      symbol: 'AAPL',
      openTime: DateTime(2023, 10, 20, 10, 0),
      closeTime: DateTime(2023, 10, 21, 11, 30),
      volume: 50,
      side: TradeSide.sell,
      openPrice: 174.50,
      closePrice: 172.10,
      stopLoss: 178.00,
      takeProfit: 170.00,
      swap: 0,
      commission: -1.80,
      profit: 120.40,
      reason: CloseReason.user,
      createdAt: DateTime(2023, 10, 21, 11, 30),
      updatedAt: DateTime(2023, 10, 21, 11, 30),
    ),
    ClosedPosition(
      id: 'tp-006',
      userId: 'user-001',
      symbol: 'TSLA',
      openTime: DateTime(2023, 10, 19, 9, 45),
      closeTime: DateTime(2023, 10, 20, 9, 45),
      volume: 30,
      side: TradeSide.buy,
      openPrice: 245.80,
      closePrice: 175.80,
      stopLoss: 240.00,
      takeProfit: 260.00,
      swap: 0,
      commission: -1.50,
      profit: -2100.00,
      reason: CloseReason.sl,
      createdAt: DateTime(2023, 10, 20, 9, 45),
      updatedAt: DateTime(2023, 10, 20, 9, 45),
    ),
    ClosedPosition(
      id: 'tp-007',
      userId: 'user-001',
      symbol: 'NDX100',
      openTime: DateTime(2023, 10, 18, 10, 0),
      closeTime: DateTime(2023, 10, 19, 16, 0),
      volume: 1.0,
      side: TradeSide.buy,
      openPrice: 14820.00,
      closePrice: 15050.00,
      swap: -2.00,
      commission: -5.00,
      profit: 230.00,
      reason: CloseReason.user,
      createdAt: DateTime(2023, 10, 19, 16, 0),
      updatedAt: DateTime(2023, 10, 19, 16, 0),
    ),
    ClosedPosition(
      id: 'tp-008',
      userId: 'user-001',
      symbol: 'GBPUSD',
      openTime: DateTime(2023, 10, 17, 8, 0),
      closeTime: DateTime(2023, 10, 18, 14, 30),
      volume: 3.0,
      side: TradeSide.sell,
      openPrice: 1.21800,
      closePrice: 1.21500,
      stopLoss: 1.22300,
      takeProfit: 1.21000,
      swap: -4.50,
      commission: -6.00,
      profit: -450.20,
      reason: CloseReason.sl,
      createdAt: DateTime(2023, 10, 18, 14, 30),
      updatedAt: DateTime(2023, 10, 18, 14, 30),
    ),
  ];

  // ── Open Positions ───────────────────────────────────────
  static final mockOpenPositions = [
    OpenPosition(
      id: 'op-001',
      userId: 'user-001',
      symbol: 'BTCUSD',
      openTime: DateTime(2026, 4, 10, 8, 0),
      volume: 0.3,
      side: TradeSide.buy,
      openPrice: 68500.00,
      currentPrice: 69200.00,
      stopLoss: 67500.00,
      takeProfit: 71000.00,
      swap: -1.20,
      commission: -5.00,
      profit: 210.00,
      createdAt: DateTime(2026, 4, 10, 8, 0),
      updatedAt: DateTime(2026, 4, 11, 10, 0),
    ),
    OpenPosition(
      id: 'op-002',
      userId: 'user-001',
      symbol: 'ETHUSD',
      openTime: DateTime(2026, 4, 9, 14, 0),
      volume: 1.5,
      side: TradeSide.sell,
      openPrice: 1620.00,
      currentPrice: 1590.00,
      stopLoss: 1660.00,
      takeProfit: 1550.00,
      swap: -0.80,
      commission: -4.00,
      profit: 45.00,
      createdAt: DateTime(2026, 4, 9, 14, 0),
      updatedAt: DateTime(2026, 4, 11, 10, 0),
    ),
  ];

  // ── Finance Records ──────────────────────────────────────
  static final mockFinanceRecords = [
    FinanceRecord(
      id: 'fin-001',
      userId: 'user-001',
      type: FinanceType.deposit,
      time: DateTime(2026, 1, 15, 10, 0),
      amount: 100000.00,
      status: 'Done',
      paymentGateway: 'Bank Transfer',
      details: 'Prop firm initial balance',
      createdAt: DateTime(2026, 1, 15, 10, 0),
      updatedAt: DateTime(2026, 1, 15, 10, 0),
    ),
    FinanceRecord(
      id: 'fin-002',
      userId: 'user-001',
      type: FinanceType.deposit,
      time: DateTime(2026, 3, 1, 9, 0),
      amount: 5000.00,
      status: 'Done',
      paymentGateway: 'Manual',
      details: 'Additional deposit',
      createdAt: DateTime(2026, 3, 1, 9, 0),
      updatedAt: DateTime(2026, 3, 1, 9, 0),
    ),
    FinanceRecord(
      id: 'fin-003',
      userId: 'user-001',
      type: FinanceType.withdrawal,
      time: DateTime(2026, 4, 5, 14, 0),
      amount: 2500.00,
      status: 'Done',
      paymentGateway: 'Bank Transfer',
      details: 'Profit withdrawal',
      createdAt: DateTime(2026, 4, 5, 14, 0),
      updatedAt: DateTime(2026, 4, 5, 14, 0),
    ),
  ];

  // ── Analytics ────────────────────────────────────────────
  static const mockAnalytics = TradeAnalytics(
    totalTrades: 154,
    openPositions: 2,
    winRate: 64.0,
    totalProfitLoss: 2100.00,
    averageProfit: 13.64,
    largestWin: 3210.15,
    largestLoss: -2100.00,
    profitFactor: 2.41,
    averageRiskRewardRatio: 1.8,
    accountBalance: 12450.00,
    totalDeposits: 105000.00,
    totalWithdrawals: 2500.00,
    bestSymbol: 'NDX100',
    worstSymbol: 'TSLA',
    consecutiveLosses: 0,
  );

  // ── Recommendations ──────────────────────────────────────
  static final mockRecommendations = [
    const Recommendation(
      title: 'Best Performing Symbol',
      description:
          'NDX100 has the highest total net profit with a 78% win rate across 45 trades.',
      severity: Severity.info,
    ),
    const Recommendation(
      title: 'Best Day to Trade',
      description:
          'Tuesday shows the highest average profit of +\$285 across your trading history.',
      severity: Severity.info,
    ),
    const Recommendation(
      title: 'Risk-Reward Alert',
      description:
          'Your average risk-reward ratio is 1.8:1 — keep maintaining this discipline.',
      severity: Severity.info,
    ),
    const Recommendation(
      title: 'Overtrading Alert',
      description:
          'You logged 12 trades on Oct 22. Consider reducing daily trade frequency.',
      severity: Severity.warning,
    ),
  ];
}
