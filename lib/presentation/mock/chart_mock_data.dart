/// Mock data for chart visualizations.
///
/// All values match the visual proportions shown in the Stitch reference designs.
class ChartMockData {
  const ChartMockData._();

  // ── Equity Curve ──────────────────────────────────────────
  static const equityCurvePoints = [
    _EquityPoint('Oct 01', 11200),
    _EquityPoint('Oct 03', 11150),
    _EquityPoint('Oct 05', 11400),
    _EquityPoint('Oct 07', 11650),
    _EquityPoint('Oct 09', 11500),
    _EquityPoint('Oct 11', 11800),
    _EquityPoint('Oct 13', 12100),
    _EquityPoint('Oct 15', 11900),
    _EquityPoint('Oct 17', 12200),
    _EquityPoint('Oct 19', 12350),
    _EquityPoint('Oct 21', 12100),
    _EquityPoint('Oct 23', 12450),
    _EquityPoint('Oct 25', 12300),
    _EquityPoint('Oct 27', 12600),
    _EquityPoint('Oct 29', 12500),
    _EquityPoint('Oct 31', 12450),
  ];

  // ── P/L Distribution ──────────────────────────────────────
  static const plDistribution = [
    _PLBucket('-500 to -200', -350, 3),
    _PLBucket('-200 to 0', -100, 8),
    _PLBucket('0 to 200', 100, 22),
    _PLBucket('200 to 500', 350, 18),
    _PLBucket('500 to 1000', 750, 12),
    _PLBucket('1000 to 3000', 2000, 6),
    _PLBucket('3000+', 4000, 2),
  ];

  // ── Win/Loss by Symbol ────────────────────────────────────
  static const symbolPerformance = [
    _SymbolPerf('BTCUSD', 18, 4, 1240.0),
    _SymbolPerf('EURUSD', 12, 6, -240.0),
    _SymbolPerf('ETHUSD', 14, 3, 890.0),
    _SymbolPerf('NVDA', 8, 2, 3210.0),
    _SymbolPerf('AAPL', 10, 5, 120.0),
    _SymbolPerf('TSLA', 5, 8, -2100.0),
    _SymbolPerf('NDX100', 15, 2, 230.0),
  ];

  // ── Win/Loss by Reason ────────────────────────────────────
  static const reasonDistribution = [
    _ReasonCount('TP', 45, 0xFF006f05),
    _ReasonCount('SL', 28, 0xFF9e422c),
    _ReasonCount('User', 18, 0xFFbe0038),
    _ReasonCount('Manual', 9, 0xFF605f5f),
  ];

  // ── Profit by Day of Week ─────────────────────────────────
  static const profitByDay = [
    _DayProfit('Mon', 180.0),
    _DayProfit('Tue', 285.0),
    _DayProfit('Wed', -60.0),
    _DayProfit('Thu', 210.0),
    _DayProfit('Fri', -120.0),
    _DayProfit('Sat', 50.0),
    _DayProfit('Sun', -30.0),
  ];

  // ── Profit by Session ─────────────────────────────────────
  static const profitBySession = [
    _SessionProfit('Asian\n(00-08)', -85.0),
    _SessionProfit('London\n(07-16)', 320.0),
    _SessionProfit('New York\n(12-21)', 210.0),
  ];
}

class _EquityPoint {
  final String date;
  final double value;
  const _EquityPoint(this.date, this.value);
}

class _PLBucket {
  final String label;
  final double midpoint;
  final int count;
  const _PLBucket(this.label, this.midpoint, this.count);
}

class _SymbolPerf {
  final String symbol;
  final int wins;
  final int losses;
  final double totalProfit;
  const _SymbolPerf(this.symbol, this.wins, this.losses, this.totalProfit);
}

class _ReasonCount {
  final String reason;
  final int count;
  final int color;
  const _ReasonCount(this.reason, this.count, this.color);
}

class _DayProfit {
  final String day;
  final double profit;
  const _DayProfit(this.day, this.profit);
}

class _SessionProfit {
  final String session;
  final double profit;
  const _SessionProfit(this.session, this.profit);
}
