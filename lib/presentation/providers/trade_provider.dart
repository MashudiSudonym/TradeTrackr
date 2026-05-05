import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/trade_filter.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/usecases/add_trade.dart';
import '../../domain/usecases/update_trade.dart';
import '../../domain/usecases/delete_trade.dart';
import 'di_providers.dart';
import 'auth_provider.dart';

part 'trade_provider.g.dart';

/// Provides the list of closed positions from the local database.
@riverpod
class TradeList extends _$TradeList {
  @override
  Future<List<ClosedPosition>> build() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final repo = ref.watch(tradeQueryRepositoryProvider);
    final result = await repo.getClosedPositions(userId: userId);

    return result.getOrElse([]);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Get the current authenticated user ID.
  String? get _currentUserId {
    return ref.watch(supabaseAuthStateProvider)?.id;
  }
}

/// Provides a filtered list of closed positions based on the provided filter.
@riverpod
Future<List<ClosedPosition>> filteredTradeList(
  Ref ref, {
  required TradeFilter filter,
}) async {
  final userId = ref.watch(supabaseAuthStateProvider)?.id;
  if (userId == null) return [];

  final repo = ref.watch(tradeQueryRepositoryProvider);
  final result = await repo.getClosedPositions(
    userId: userId,
    startDate: filter.startDate,
    endDate: filter.endDate,
    symbols: filter.symbols,
    side: filter.side,
    reasons: filter.reasons,
  );

  return result.getOrElse([]);
}

/// Provides a single trade by ID.
@riverpod
Future<ClosedPosition?> tradeById(Ref ref, {required String id}) async {
  final userId = ref.watch(supabaseAuthStateProvider)?.id;
  if (userId == null) return null;

  final repo = ref.watch(tradeQueryRepositoryProvider);
  final result = await repo.getClosedPositionById(id, userId);

  return result.getOrElse(null);
}

/// Provides the list of open positions from the local database.
@riverpod
class OpenPositions extends _$OpenPositions {
  @override
  Future<List<OpenPosition>> build() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final repo = ref.watch(tradeQueryRepositoryProvider);
    final result = await repo.getOpenPositions(userId);

    return result.getOrElse([]);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Get the current authenticated user ID.
  String? get _currentUserId {
    return ref.watch(supabaseAuthStateProvider)?.id;
  }
}

/// Provides a single open position by ID.
@riverpod
Future<OpenPosition?> openPositionById(Ref ref, {required String id}) async {
  final userId = ref.watch(supabaseAuthStateProvider)?.id;
  if (userId == null) return null;

  final repo = ref.watch(tradeQueryRepositoryProvider);
  final result = await repo.getOpenPositionById(id, userId);

  return result.getOrElse(null);
}

/// Provider for adding a new closed position.
@riverpod
Future<void> Function(ClosedPosition) addClosedPosition(Ref ref) {
  return (position) async {
    final useCase = ref.read(addTradeUseCaseProvider);
    final result = await useCase(AddTradeParams(position: position));

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for updating an existing closed position.
@riverpod
Future<void> Function(ClosedPosition) updateClosedPosition(Ref ref) {
  return (position) async {
    final useCase = ref.read(updateTradeUseCaseProvider);
    final result = await useCase(UpdateTradeParams(position: position));

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for deleting a closed position.
@riverpod
Future<void> Function(String) deleteClosedPosition(Ref ref) {
  return (id) async {
    final useCase = ref.read(deleteTradeUseCaseProvider);
    final result = await useCase(DeleteTradeParams(id: id));

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for adding a new open position.
@riverpod
Future<void> Function(OpenPosition) addOpenPosition(Ref ref) {
  return (position) async {
    final repo = ref.read(tradeCommandRepositoryProvider);
    final result = await repo.addOpenPosition(position);

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for updating an existing open position.
@riverpod
Future<void> Function(OpenPosition) updateOpenPosition(Ref ref) {
  return (position) async {
    final repo = ref.read(tradeCommandRepositoryProvider);
    final result = await repo.updateOpenPosition(position);

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for closing an open position (converting to closed).
@riverpod
Future<void> Function({
  required String openPositionId,
  required DateTime closeTime,
  required double closePrice,
  required CloseReason reason,
}) closeOpenPosition(Ref ref) {
  return ({
    required openPositionId,
    required closeTime,
    required closePrice,
    required reason,
  }) async {
    final repo = ref.read(tradeCommandRepositoryProvider);
    final result = await repo.closePosition(
      openPositionId: openPositionId,
      closePrice: closePrice,
      closeTime: closeTime,
      reason: reason,
    );

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}

/// Provider for deleting an open position.
@riverpod
Future<void> Function(String) deleteOpenPosition(Ref ref) {
  return (id) async {
    final repo = ref.read(tradeCommandRepositoryProvider);
    final result = await repo.deleteOpenPosition(id);

    if (!result.isSuccess) {
      throw Exception(result.error);
    }
  };
}
