import 'package:supabase_flutter/supabase_flutter.dart';
import 'trade_remote_data_source.dart';

class TradeRemoteDataSourceImpl implements TradeRemoteDataSource {
  final SupabaseClient _client;

  static const _closedKeyMap = {
    'id': 'id',
    'userId': 'user_id',
    'symbol': 'symbol',
    'openTime': 'open_time',
    'closeTime': 'close_time',
    'volume': 'volume',
    'side': 'side',
    'openPrice': 'open_price',
    'closePrice': 'close_price',
    'stopLoss': 'stop_loss',
    'takeProfit': 'take_profit',
    'swap': 'swap',
    'commission': 'commission',
    'profit': 'profit',
    'reason': 'reason',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
    'isSynced': 'is_synced',
  };

  static const _openKeyMap = {
    'id': 'id',
    'userId': 'user_id',
    'symbol': 'symbol',
    'openTime': 'open_time',
    'volume': 'volume',
    'side': 'side',
    'openPrice': 'open_price',
    'currentPrice': 'current_price',
    'stopLoss': 'stop_loss',
    'takeProfit': 'take_profit',
    'swap': 'swap',
    'commission': 'commission',
    'profit': 'profit',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
    'isSynced': 'is_synced',
  };

  static const _financeKeyMap = {
    'id': 'id',
    'userId': 'user_id',
    'type': 'type',
    'time': 'time',
    'amount': 'amount',
    'status': 'status',
    'paymentGateway': 'payment_gateway',
    'details': 'details',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
    'isSynced': 'is_synced',
  };

  TradeRemoteDataSourceImpl(this._client);

  Map<String, dynamic> _toSnakeCase(
    Map<String, dynamic> data,
    Map<String, String> keyMap,
  ) {
    return data.map((key, value) {
      final snakeKey = keyMap[key] ?? key;
      return MapEntry(snakeKey, value);
    });
  }

  double _coerceDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return (value as num).toDouble();
  }

  double? _coerceDoubleOrNull(dynamic value) {
    if (value == null) return null;
    return _coerceDouble(value);
  }

  List<Map<String, dynamic>> _coerceNumericFields(
    List<Map<String, dynamic>> rows,
    List<String> fields,
  ) {
    return rows.map((row) {
      final coerced = Map<String, dynamic>.from(row);
      for (final field in fields) {
        if (coerced.containsKey(field) && coerced[field] != null) {
          final nullable = _coerceDoubleOrNull(coerced[field]);
          if (nullable != null) coerced[field] = nullable;
        }
      }
      return coerced;
    }).toList();
  }

  static const _closedNumericFields = [
    'volume',
    'open_price',
    'close_price',
    'swap',
    'commission',
    'profit',
  ];

  static const _openNumericFields = [
    'volume',
    'open_price',
    'current_price',
    'swap',
    'commission',
    'profit',
  ];

  static const _financeNumericFields = [
    'amount',
  ];

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
    return _coerceNumericFields(
      List<Map<String, dynamic>>.from(response),
      _closedNumericFields,
    );
  }

  @override
  Future<void> upsertClosedPosition(Map<String, dynamic> data) async {
    final snakeData = _toSnakeCase(data, _closedKeyMap);
    await _client.from('closed_positions').upsert(snakeData);
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
    return _coerceNumericFields(
      List<Map<String, dynamic>>.from(response),
      _openNumericFields,
    );
  }

  @override
  Future<void> upsertOpenPosition(Map<String, dynamic> data) async {
    final snakeData = _toSnakeCase(data, _openKeyMap);
    await _client.from('open_positions').upsert(snakeData);
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
    return _coerceNumericFields(
      List<Map<String, dynamic>>.from(response),
      _financeNumericFields,
    );
  }

  @override
  Future<void> upsertFinanceRecord(Map<String, dynamic> data) async {
    final snakeData = _toSnakeCase(data, _financeKeyMap);
    await _client.from('finance_records').upsert(snakeData);
  }

  @override
  Future<void> deleteFinanceRecord(String id) async {
    await _client.from('finance_records').delete().eq('id', id);
  }
}
