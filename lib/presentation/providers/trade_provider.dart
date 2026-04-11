import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../mock/mock_data.dart';

/// Provides the list of closed positions from mock data.
///
/// TODO: Replace with real repository when data layer is built.
final tradeListProvider =
    AsyncNotifierProvider<TradeListNotifier, List<ClosedPosition>>(
  TradeListNotifier.new,
);

class TradeListNotifier extends AsyncNotifier<List<ClosedPosition>> {
  @override
  Future<List<ClosedPosition>> build() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.mockClosedPositions;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provides a single trade by ID.
final tradeByIdProvider =
    FutureProvider.family<ClosedPosition?, String>((ref, id) async {
  final trades = ref.watch(tradeListProvider).value ?? [];
  return trades.where((t) => t.id == id).firstOrNull;
});

/// Provides the list of open positions from mock data.
final openPositionsProvider =
    AsyncNotifierProvider<OpenPositionsNotifier, List<OpenPosition>>(
  OpenPositionsNotifier.new,
);

class OpenPositionsNotifier extends AsyncNotifier<List<OpenPosition>> {
  @override
  Future<List<OpenPosition>> build() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.mockOpenPositions;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
