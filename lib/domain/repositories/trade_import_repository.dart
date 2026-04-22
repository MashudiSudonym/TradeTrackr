import '../core/result.dart';

/// Bulk import operations for trade data.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains import operations.
abstract class TradeImportRepository {
  /// Import trades from a CSV file.
  ///
  /// Returns [ImportResult] with counts of imported, skipped, and error rows.
  Future<Result<ImportResult>> importFromCsv(String filePath);

  /// Import closed positions from CSV.
  Future<Result<ImportResult>> importClosedPositionsFromCsv(
    String filePath,
  );

  /// Import open positions from CSV.
  Future<Result<ImportResult>> importOpenPositionsFromCsv(
    String filePath,
  );

  /// Import finance records from CSV.
  Future<Result<ImportResult>> importFinanceRecordsFromCsv(
    String filePath,
  );
}

/// Result of a CSV import operation.
class ImportResult {
  final int imported;
  final int skipped;
  final int errors;
  final List<String> errorMessages;

  const ImportResult({
    required this.imported,
    this.skipped = 0,
    this.errors = 0,
    this.errorMessages = const [],
  });

  /// Whether the import had any errors.
  bool get hasErrors => errors > 0;

  /// Total number of rows processed.
  int get totalProcessed => imported + skipped + errors;

  @override
  String toString() =>
      'ImportResult(imported: $imported, skipped: $skipped, errors: $errors)';
}
