import '../entities/closed_position.dart';
import '../repositories/trade_command_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for adding a new closed trade position.
///
/// Follows SRP - only handles adding a single closed position.
class AddTradeUseCase {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if input is invalid.
  /// Returns [Right] with the created position on success.
  Future<Either<Failure, ClosedPosition>> execute(
    ClosedPosition position,
  ) async {
    // Business validation
    if (position.closeTime.isBefore(position.openTime)) {
      return const Left(ValidationFailure('Close time must be after open time'));
    }
    if (position.volume <= 0) {
      return const Left(ValidationFailure('Volume must be greater than 0'));
    }
    if (position.symbol.isEmpty) {
      return const Left(ValidationFailure('Symbol is required'));
    }
    if (position.openPrice <= 0) {
      return const Left(ValidationFailure('Open price must be greater than 0'));
    }
    if (position.closePrice <= 0) {
      return const Left(ValidationFailure('Close price must be greater than 0'));
    }

    return await _repository.addClosedPosition(position);
  }
}
