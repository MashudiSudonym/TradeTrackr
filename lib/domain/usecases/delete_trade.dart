import '../repositories/trade_command_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for deleting a closed trade position.
///
/// Follows SRP - only handles deleting a single closed position.
class DeleteTradeUseCase extends UseCase<void, DeleteTradeParams> {
  final TradeCommandRepository _repository;

  DeleteTradeUseCase(this._repository);

  @override
  Future<Result<void>> call(DeleteTradeParams params) async {
    // Business validation
    if (params.id.isEmpty) {
      return const Result.failure('Position ID is required');
    }

    return await _repository.deleteClosedPosition(params.id);
  }
}

/// Parameters for delete trade use case.
class DeleteTradeParams {
  final String id;

  const DeleteTradeParams({
    required this.id,
  });
}
