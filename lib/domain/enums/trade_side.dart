/// Trade direction enum with side-aware profit calculation.
///
/// Follows Open/Closed Principle — each variant encapsulates its own
/// profit calculation. Adding a new side only requires a new enum value.
enum TradeSide {
  buy(name: 'BUY'),
  sell(name: 'SELL');

  final String name;

  const TradeSide({required this.name});

  /// Calculate profit for this trade side.
  ///
  /// BUY:  (exitPrice - openPrice) * volume
  /// SELL: (openPrice - exitPrice) * volume
  double calculateProfit(double openPrice, double exitPrice, double volume) {
    return switch (this) {
      TradeSide.buy => (exitPrice - openPrice) * volume,
      TradeSide.sell => (openPrice - exitPrice) * volume,
    };
  }
}
