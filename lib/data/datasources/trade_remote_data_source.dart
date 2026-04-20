/// Remote data source interface for Supabase.
///
/// Abstracts the remote database operations.
/// Implementations should use Supabase client.
abstract class TradeRemoteDataSource {
  // Closed positions
  Future<List<Map<String, dynamic>>> getClosedPositions(String userId);
  Future<void> upsertClosedPosition(Map<String, dynamic> data);
  Future<void> deleteClosedPosition(String id);

  // Open positions
  Future<List<Map<String, dynamic>>> getOpenPositions(String userId);
  Future<void> upsertOpenPosition(Map<String, dynamic> data);
  Future<void> deleteOpenPosition(String id);

  // Finance records
  Future<List<Map<String, dynamic>>> getFinanceRecords(String userId);
  Future<void> upsertFinanceRecord(Map<String, dynamic> data);
  Future<void> deleteFinanceRecord(String id);
}
