import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/enums/close_reason.dart';

part 'trade_position_dto.freezed.dart';
part 'trade_position_dto.g.dart';

/// Freezed DTO for closed positions.
///
/// Used for serialization to/from Drift and Supabase.
@freezed
abstract class ClosedPositionDto with _$ClosedPositionDto {
  const ClosedPositionDto._();

  const factory ClosedPositionDto({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required DateTime closeTime,
    required double volume,
    required String side,
    required double openPrice,
    required double closePrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required String reason,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _ClosedPositionDto;

  factory ClosedPositionDto.fromJson(Map<String, dynamic> json) =>
      _$ClosedPositionDtoFromJson(json);

  /// Convert to domain entity.
  ClosedPosition toEntity() {
    return ClosedPosition(
      id: id,
      userId: userId,
      symbol: symbol,
      openTime: openTime,
      closeTime: closeTime,
      volume: volume,
      side: side == 'BUY' ? TradeSide.buy : TradeSide.sell,
      openPrice: openPrice,
      closePrice: closePrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      swap: swap,
      commission: commission,
      profit: profit,
      reason: CloseReason.values.firstWhere(
        (r) => r.name.toUpperCase() == reason,
        orElse: () => CloseReason.manual,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  /// Convert from domain entity.
  factory ClosedPositionDto.fromEntity(ClosedPosition entity) {
    return ClosedPositionDto(
      id: entity.id,
      userId: entity.userId,
      symbol: entity.symbol,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      volume: entity.volume,
      side: entity.side.name.toUpperCase(),
      openPrice: entity.openPrice,
      closePrice: entity.closePrice,
      stopLoss: entity.stopLoss,
      takeProfit: entity.takeProfit,
      swap: entity.swap,
      commission: entity.commission,
      profit: entity.profit,
      reason: entity.reason.name.toUpperCase(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert to JSON map for Supabase.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'symbol': symbol,
        'open_time': openTime.toIso8601String(),
        'close_time': closeTime.toIso8601String(),
        'volume': volume,
        'side': side,
        'open_price': openPrice,
        'close_price': closePrice,
        'stop_loss': stopLoss,
        'take_profit': takeProfit,
        'swap': swap,
        'commission': commission,
        'profit': profit,
        'reason': reason,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_synced': isSynced,
      };
}

/// Freezed DTO for open positions.
@freezed
abstract class OpenPositionDto with _$OpenPositionDto {
  const OpenPositionDto._();

  const factory OpenPositionDto({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required double volume,
    required String side,
    required double openPrice,
    double? currentPrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _OpenPositionDto;

  factory OpenPositionDto.fromJson(Map<String, dynamic> json) =>
      _$OpenPositionDtoFromJson(json);

  /// Convert to domain entity.
  OpenPosition toEntity() {
    return OpenPosition(
      id: id,
      userId: userId,
      symbol: symbol,
      openTime: openTime,
      volume: volume,
      side: side == 'BUY' ? TradeSide.buy : TradeSide.sell,
      openPrice: openPrice,
      currentPrice: currentPrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      swap: swap,
      commission: commission,
      profit: profit,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  /// Convert from domain entity.
  factory OpenPositionDto.fromEntity(OpenPosition entity) {
    return OpenPositionDto(
      id: entity.id,
      userId: entity.userId,
      symbol: entity.symbol,
      openTime: entity.openTime,
      volume: entity.volume,
      side: entity.side.name.toUpperCase(),
      openPrice: entity.openPrice,
      currentPrice: entity.currentPrice,
      stopLoss: entity.stopLoss,
      takeProfit: entity.takeProfit,
      swap: entity.swap,
      commission: entity.commission,
      profit: entity.profit,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert to JSON map for Supabase.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'symbol': symbol,
        'open_time': openTime.toIso8601String(),
        'volume': volume,
        'side': side,
        'open_price': openPrice,
        'current_price': currentPrice,
        'stop_loss': stopLoss,
        'take_profit': takeProfit,
        'swap': swap,
        'commission': commission,
        'profit': profit,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_synced': isSynced,
      };
}
