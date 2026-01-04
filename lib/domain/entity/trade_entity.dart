import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_entity.freezed.dart';
part 'trade_entity.g.dart';

@freezed
abstract class TradeEntity with _$TradeEntity {
  const factory TradeEntity({
    required String id,
    required String symbol,
    required DateTime openTime,
    required DateTime closeTime,
    required double volume,
    required String side, // BUY/SELL
    required String tradeStatus, // Open/Close
    required double openPrice,
    required double closePrice,
    required double stopLoss,
    required double takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    double? profitPercent,
    String? exitReason,
    String? entryReason,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TradeEntity;

  factory TradeEntity.fromJson(Map<String, dynamic> json) =>
      _$TradeEntityFromJson(json);
}
