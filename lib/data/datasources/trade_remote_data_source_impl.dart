import 'package:supabase_flutter/supabase_flutter.dart';
import 'trade_remote_data_source.dart';

/// Concrete implementation of remote data source using Supabase.
///
/// Handles all Supabase PostgreSQL operations for sync.
/// Throws exceptions to be caught by repository layer.
class TradeRemoteDataSourceImpl implements TradeRemoteDataSource {
  final SupabaseClient _client;

  TradeRemoteDataSourceImpl(this._client);

  // ============================================
  // Closed Positions
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getClosedPositions(String userId) async {
    final response = await _client
        .from('closed_positions')
        .select()
        .eq('user_id', userId)
        .order('close_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> upsertClosedPosition(Map<String, dynamic> data) async {
    await _client.from('closed_positions').upsert(data);
  }

  @override
  Future<void> deleteClosedPosition(String id) async {
    await _client.from('closed_positions').delete().eq('id', id);
  }

  // ============================================
  // Open Positions
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getOpenPositions(String userId) async {
    final response = await _client
        .from('open_positions')
        .select()
        .eq('user_id', userId)
        .order('open_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> upsertOpenPosition(Map<String, dynamic> data) async {
    await _client.from('open_positions').upsert(data);
  }

  @override
  Future<void> deleteOpenPosition(String id) async {
    await _client.from('open_positions').delete().eq('id', id);
  }

  // ============================================
  // Finance Records
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getFinanceRecords(String userId) async {
    final response = await _client
        .from('finance_records')
        .select()
        .eq('user_id', userId)
        .order('time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<void> upsertFinanceRecord(Map<String, dynamic> data) async {
    await _client.from('finance_records').upsert(data);
  }

  @override
  Future<void> deleteFinanceRecord(String id) async {
    await _client.from('finance_records').delete().eq('id', id);
  }
}
