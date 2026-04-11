import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/close_reason.dart';
import '../../domain/enums/trade_side.dart';

part 'trade_form_state.freezed.dart';

@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState.initial({
    String? symbol,
    @Default(TradeSide.buy) TradeSide side,
    @Default(0.0) double volume,
    @Default(0.0) double openPrice,
    double? closePrice,
    double? stopLoss,
    double? takeProfit,
    double? swap,
    double? commission,
    DateTime? openTime,
    DateTime? closeTime,
    CloseReason? reason,
    @Default({}) Map<String, String> validationErrors,
  }) = TradeFormInitial;

  const factory TradeFormState.loading() = TradeFormLoading;

  const factory TradeFormState.success({
    required String symbol,
    required double profit,
  }) = TradeFormSuccess;

  const factory TradeFormState.error(String message) = TradeFormError;
}
