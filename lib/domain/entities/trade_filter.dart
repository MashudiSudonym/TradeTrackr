import '../enums/trade_side.dart';
import '../enums/close_reason.dart';

/// Filter criteria for querying trade positions.
class TradeFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> symbols;
  final TradeSide? side;
  final List<CloseReason> reasons;

  const TradeFilter({
    this.startDate,
    this.endDate,
    this.symbols = const [],
    this.side,
    this.reasons = const [],
  });

  static const empty = TradeFilter();

  TradeFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  }) {
    return TradeFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      symbols: symbols ?? this.symbols,
      side: side ?? this.side,
      reasons: reasons ?? this.reasons,
    );
  }

  /// Whether any filter is active.
  bool get isActive =>
      startDate != null ||
      endDate != null ||
      symbols.isNotEmpty ||
      side != null ||
      reasons.isNotEmpty;
}
