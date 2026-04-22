import '../repositories/trade_export_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for exporting trades to CSV.
///
/// Follows SRP - only handles CSV export operations.
class ExportTradesUseCase extends UseCase<String, ExportTradesParams> {
  final TradeExportRepository _repository;

  ExportTradesUseCase(this._repository);

  @override
  Future<Result<String>> call(ExportTradesParams params) async {
    return await _repository.exportClosedPositionsToCsv(
      startDate: params.startDate,
      endDate: params.endDate,
      symbols: params.symbols,
    );
  }

  /// Export open positions to CSV.
  Future<Result<String>> exportOpenPositions() async {
    return await _repository.exportOpenPositionsToCsv();
  }

  /// Export finance records to CSV.
  Future<Result<String>> exportFinanceRecords() async {
    return await _repository.exportFinanceRecordsToCsv();
  }
}

/// Parameters for export trades use case.
class ExportTradesParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? symbols;

  const ExportTradesParams({
    this.startDate,
    this.endDate,
    this.symbols,
  });
}
