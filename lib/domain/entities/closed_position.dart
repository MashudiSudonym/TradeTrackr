import '../enums/trade_side.dart';
import '../enums/close_reason.dart';

/// Represents a closed trade position with all entry/exit details.
///
/// This is a plain Dart class (not Freezed) in the domain layer.
/// Freezed DTOs belong in the data layer.
class ClosedPosition {
  final String id;
  final String userId;
  final String symbol;
  final DateTime openTime;
  final DateTime closeTime;
  final double volume;
  final TradeSide side;
  final double openPrice;
  final double closePrice;
  final double? stopLoss;
  final double? takeProfit;
  final double swap;
  final double commission;
  final double profit;
  final CloseReason reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const ClosedPosition({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.openTime,
    required this.closeTime,
    required this.volume,
    required this.side,
    required this.openPrice,
    required this.closePrice,
    this.stopLoss,
    this.takeProfit,
    this.swap = 0.0,
    this.commission = 0.0,
    required this.profit,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  /// Whether this trade resulted in a profit.
  bool get isWin => profit > 0;

  /// Duration the position was held.
  Duration get holdingDuration => closeTime.difference(openTime);

  /// Profit after deducting swap and commission.
  double get netProfit => profit - swap - commission;

  /// Price movement in pips.
  double get pips => switch (side) {
        TradeSide.buy => closePrice - openPrice,
        TradeSide.sell => openPrice - closePrice,
      };

  /// Risk-reward ratio if both SL and TP are set.
  double? get riskRewardRatio {
    if (stopLoss == null || takeProfit == null) return null;
    final risk = (openPrice - stopLoss!).abs();
    final reward = (takeProfit! - openPrice).abs();
    return risk == 0 ? null : reward / risk;
  }

  /// Formatted profit string with + or - prefix.
  String get formattedProfit =>
      profit >= 0 ? '+${profit.toStringAsFixed(2)}' : profit.toStringAsFixed(2);

  ClosedPosition copyWith({
    String? id,
    String? userId,
    String? symbol,
    DateTime? openTime,
    DateTime? closeTime,
    double? volume,
    TradeSide? side,
    double? openPrice,
    double? closePrice,
    double? stopLoss,
    double? takeProfit,
    double? swap,
    double? commission,
    double? profit,
    CloseReason? reason,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return ClosedPosition(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      volume: volume ?? this.volume,
      side: side ?? this.side,
      openPrice: openPrice ?? this.openPrice,
      closePrice: closePrice ?? this.closePrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      swap: swap ?? this.swap,
      commission: commission ?? this.commission,
      profit: profit ?? this.profit,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
