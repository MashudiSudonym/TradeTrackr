import '../repositories/trade_export_repository.dart';



/// Use case for exporting trades to CSV.
///
/// Follows SRP - only handles CSV export operations.
class ExportTradesUseCase {
  final TradeExportRepository _repository;

  ExportTradesUseCase(this._repository);

  /// Execute the use case for exporting closed positions.
  ///
  /// Returns [Left] with failure if export fails.
  /// Returns [Right] with CSV content on success.
  Future<Result<String>> executeClosedPositions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  }) async {
    return await _repository.exportClosedPositionsToCsv(
      startDate: startDate,
      endDate: endDate,
      symbols: symbols,
    );
  }

  /// Execute the use case for exporting open positions.
  ///
  /// Returns [Left] with failure if export fails.
  /// Returns [Right] with CSV content on success.
  Future<Result<String>> executeOpenPositions() async {
    return await _repository.exportOpenPositionsToCsv();
  }

  /// Execute the use case for exporting finance records.
  ///
  /// Returns [Left] with failure if export fails.
  /// Returns [Right] with CSV content on success.
  Future<Result<String>> executeFinanceRecords() async {
    return await _repository.exportFinanceRecordsToCsv();
  }
}
