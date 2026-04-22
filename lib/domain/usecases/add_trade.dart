import '../entities/closed_position.dart';
import '../repositories/trade_command_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for adding a new closed trade position.
///
/// Follows SRP - only handles adding a single closed position.
class AddTradeUseCase extends UseCase<ClosedPosition, AddTradeParams> {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  @override
  Future<Result<ClosedPosition>> call(AddTradeParams params) async {
    // Business validation
    if (params.position.closeTime.isBefore(params.position.openTime)) {
      return const Result.failure('Close time must be after open time');
    }
    if (params.position.volume <= 0) {
      return const Result.failure('Volume must be greater than 0');
    }
    if (params.position.symbol.isEmpty) {
      return const Result.failure('Symbol is required');
    }
    if (params.position.openPrice <= 0) {
      return const Result.failure('Open price must be greater than 0');
    }
    if (params.position.closePrice <= 0) {
      return const Result.failure('Close price must be greater than 0');
    }

    return await _repository.addClosedPosition(params.position);
  }
}

/// Parameters for add trade use case.
class AddTradeParams {
  final ClosedPosition position;

  const AddTradeParams({
    required this.position,
  });
}
