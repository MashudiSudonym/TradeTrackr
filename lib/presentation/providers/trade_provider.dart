import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../mock/mock_data.dart';

part 'trade_provider.g.dart';

/// Provides the list of closed positions from mock data.
///
/// TODO: Replace with real repository when data layer is built.
@riverpod
class TradeList extends _$TradeList {
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
@riverpod
Future<ClosedPosition?> tradeById(Ref ref, {required String id}) async {
  final trades = ref.watch(tradeListProvider).value ?? [];
  return trades.where((t) => t.id == id).firstOrNull;
}

/// Provides the list of open positions from mock data.
@riverpod
class OpenPositions extends _$OpenPositions {
  @override
  Future<List<OpenPosition>> build() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.mockOpenPositions;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
