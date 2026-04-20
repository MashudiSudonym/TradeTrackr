import '../repositories/trade_import_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for importing trades from CSV.
///
/// Follows SRP - only handles CSV import operations.
class ImportTradesUseCase {
  final TradeImportRepository _repository;

  ImportTradesUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if file path is invalid.
  /// Returns [Right] with import result on success.
  Future<Either<Failure, ImportResult>> execute(String filePath) async {
    // Business validation
    if (filePath.isEmpty) {
      return const Left(ValidationFailure('File path cannot be empty'));
    }

    return await _repository.importFromCsv(filePath);
  }
}
