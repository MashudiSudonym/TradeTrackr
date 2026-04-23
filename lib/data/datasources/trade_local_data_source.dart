/// Local data source interface for Drift (SQLite).
///
/// Abstracts the local database operations.
/// Implementations should use Drift ORM.
abstract class TradeLocalDataSource {
  // Closed positions
  Future<List<Map<String, dynamic>>> getAllClosedPositions(String userId);
  Future<Map<String, dynamic>?> getClosedPositionById(String id);
  Future<void> insertClosedPosition(Map<String, dynamic> data);
  Future<void> insertClosedPositionsBatch(List<Map<String, dynamic>> data);
  Future<void> updateClosedPosition(Map<String, dynamic> data);
  Future<void> deleteClosedPosition(String id);
  Future<List<Map<String, dynamic>>> getUnsyncedClosedPositions(String userId);
  Future<void> markAsSynced(String id, String table);

  // Open positions
  Future<List<Map<String, dynamic>>> getAllOpenPositions(String userId);
  Future<Map<String, dynamic>?> getOpenPositionById(String id);
  Future<void> insertOpenPosition(Map<String, dynamic> data);
  Future<void> insertOpenPositionsBatch(List<Map<String, dynamic>> data);
  Future<void> updateOpenPosition(Map<String, dynamic> data);
  Future<void> deleteOpenPosition(String id);
  Future<List<Map<String, dynamic>>> getUnsyncedOpenPositions(String userId);

  // Finance records
  Future<List<Map<String, dynamic>>> getAllFinanceRecords(String userId);
  Future<void> insertFinanceRecord(Map<String, dynamic> data);
  Future<void> insertFinanceRecordsBatch(List<Map<String, dynamic>> data);
  Future<List<Map<String, dynamic>>> getUnsyncedFinanceRecords(String userId);

  // Query with filters
  Future<List<Map<String, dynamic>>> queryClosedPositions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    String? side,
    List<String>? reasons,
  });

  // Merge operations for sync
  Future<void> mergeClosedPositions(List<Map<String, dynamic>> data);
  Future<void> mergeOpenPositions(List<Map<String, dynamic>> data);
  Future<void> mergeFinanceRecords(List<Map<String, dynamic>> data);
}
