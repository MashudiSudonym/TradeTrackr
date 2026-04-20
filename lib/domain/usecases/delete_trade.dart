import '../repositories/trade_command_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for deleting a closed trade position.
///
/// Follows SRP - only handles deleting a single closed position.
class DeleteTradeUseCase {
  final TradeCommandRepository _repository;

  DeleteTradeUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if ID is invalid.
  /// Returns [Right] with void on success.
  Future<Either<Failure, void>> execute(String id) async {
    // Business validation
    if (id.isEmpty) {
      return const Left(ValidationFailure('Position ID is required'));
    }

    return await _repository.deleteClosedPosition(id);
  }
}
