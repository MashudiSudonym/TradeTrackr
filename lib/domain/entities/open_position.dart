import '../enums/trade_side.dart';

/// Represents an open (active) trade position.
class OpenPosition {
  final String id;
  final String userId;
  final String symbol;
  final DateTime openTime;
  final double volume;
  final TradeSide side;
  final double openPrice;
  final double? currentPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double swap;
  final double commission;
  final double profit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const OpenPosition({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.openTime,
    required this.volume,
    required this.side,
    required this.openPrice,
    this.currentPrice,
    this.stopLoss,
    this.takeProfit,
    this.swap = 0.0,
    this.commission = 0.0,
    required this.profit,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  /// Floating P/L based on current price.
  double get floatingProfit {
    if (currentPrice == null) return 0.0;
    return side.calculateProfit(openPrice, currentPrice!, volume);
  }

  OpenPosition copyWith({
    String? id,
    String? userId,
    String? symbol,
    DateTime? openTime,
    double? volume,
    TradeSide? side,
    double? openPrice,
    double? currentPrice,
    double? stopLoss,
    double? takeProfit,
    double? swap,
    double? commission,
    double? profit,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return OpenPosition(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      openTime: openTime ?? this.openTime,
      volume: volume ?? this.volume,
      side: side ?? this.side,
      openPrice: openPrice ?? this.openPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      swap: swap ?? this.swap,
      commission: commission ?? this.commission,
      profit: profit ?? this.profit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
