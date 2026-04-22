import '../repositories/trade_import_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for importing trades from CSV.
///
/// Follows SRP - only handles CSV import operations.
class ImportTradesUseCase extends UseCase<ImportResult, ImportTradesParams> {
  final TradeImportRepository _repository;

  ImportTradesUseCase(this._repository);

  @override
  Future<Result<ImportResult>> call(ImportTradesParams params) async {
    // Business validation
    if (params.filePath.isEmpty) {
      return const Result.failure('File path cannot be empty');
    }

    return await _repository.importFromCsv(params.filePath);
  }
}

/// Parameters for import trades use case.
class ImportTradesParams {
  final String filePath;

  const ImportTradesParams({
    required this.filePath,
  });
}
