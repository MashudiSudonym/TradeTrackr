import '../entities/closed_position.dart';
import '../repositories/trade_command_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for updating an existing closed trade position.
///
/// Follows SRP - only handles updating a single closed position.
class UpdateTradeUseCase extends UseCase<ClosedPosition, UpdateTradeParams> {
  final TradeCommandRepository _repository;

  UpdateTradeUseCase(this._repository);

  @override
  Future<Result<ClosedPosition>> call(UpdateTradeParams params) async {
    // Business validation
    if (params.position.id.isEmpty) {
      return const Result.failure('Position ID is required');
    }
    if (params.position.closeTime.isBefore(params.position.openTime)) {
      return const Result.failure('Close time must be after open time');
    }
    if (params.position.volume <= 0) {
      return const Result.failure('Volume must be greater than 0');
    }
    if (params.position.symbol.isEmpty) {
      return const Result.failure('Symbol is required');
    }

    return await _repository.updateClosedPosition(params.position);
  }
}

/// Parameters for update trade use case.
class UpdateTradeParams {
  final ClosedPosition position;

  const UpdateTradeParams({
    required this.position,
  });
}
