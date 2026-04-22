import '../entities/closed_position.dart';
import '../repositories/trade_command_repository.dart';



/// Use case for updating an existing closed trade position.
///
/// Follows SRP - only handles updating a single closed position.
class UpdateTradeUseCase {
  final TradeCommandRepository _repository;

  UpdateTradeUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if input is invalid.
  /// Returns [Right] with the updated position on success.
  Future<Result<ClosedPosition>> execute(
    ClosedPosition position,
  ) async {
    // Business validation
    if (position.id.isEmpty) {
      return const Result.failure(''Position ID is required'));
    }
    if (position.closeTime.isBefore(position.openTime)) {
      return const Result.failure(''Close time must be after open time'));
    }
    if (position.volume <= 0) {
      return const Result.failure(''Volume must be greater than 0'));
    }
    if (position.symbol.isEmpty) {
      return const Result.failure(''Symbol is required'));
    }

    return await _repository.updateClosedPosition(position);
  }
}
