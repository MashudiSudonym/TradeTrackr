import '../core/result.dart';

/// Export operations for trade data.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains export operations.
abstract class TradeExportRepository {
  /// Export closed positions to CSV.
  Future<Result<String>> exportClosedPositionsToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  });

  /// Export open positions to CSV.
  Future<Result<String>> exportOpenPositionsToCsv();

  /// Export finance records to CSV.
  Future<Result<String>> exportFinanceRecordsToCsv();

  /// Export all trade data to separate CSV files.
  ///
  /// Returns a map of file type to CSV content.
  Future<Result<Map<String, String>>> exportAllToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  });
}
