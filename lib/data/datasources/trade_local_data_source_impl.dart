import 'package:drift/drift.dart';
import 'drift/database.dart';
import 'trade_local_data_source.dart';

/// Concrete implementation of local data source using Drift.
///
/// Follows offline-first pattern: all writes go here first.
/// Uses DTOs for serialization between domain entities and Drift rows.
class TradeLocalDataSourceImpl implements TradeLocalDataSource {
  final AppDatabase _db;

  TradeLocalDataSourceImpl(this._db);

  // ============================================
  // Closed Positions
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getAllClosedPositions(String userId) async {
    final results = await _db.getAllClosedPositionsByUser(userId);
    return results.map((row) => _mapClosedPositionToMap(row)).toList();
  }

  @override
  Future<Map<String, dynamic>?> getClosedPositionById(String id) async {
    final result = await _db.getClosedPositionById(id);
    return result != null ? _mapClosedPositionToMap(result) : null;
  }

  @override
  Future<void> insertClosedPosition(Map<String, dynamic> data) async {
    final companion = _mapToClosedPositionCompanion(data);
    await _db.into(_db.closedPositions).insert(companion);
  }

  @override
  Future<void> insertClosedPositionsBatch(List<Map<String, dynamic>> data) async {
    await _db.batch((batch) {
      for (final item in data) {
        final companion = _mapToClosedPositionCompanion(item);
        batch.insert(_db.closedPositions, companion);
      }
    });
  }

  @override
  Future<void> updateClosedPosition(Map<String, dynamic> data) async {
    final companion = _mapToClosedPositionCompanion(data);
    await _db.update(_db.closedPositions).replace(companion);
  }

  @override
  Future<void> deleteClosedPosition(String id) async {
    await (_db.delete(_db.closedPositions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedClosedPositions(String userId) async {
    final results = await _db.getUnsyncedClosedPositions(userId);
    return results.map((row) => _mapClosedPositionToMap(row)).toList();
  }

  // ============================================
  // Open Positions
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getAllOpenPositions(String userId) async {
    final results = await _db.getAllOpenPositionsByUser(userId);
    return results.map((row) => _mapOpenPositionToMap(row)).toList();
  }

  @override
  Future<Map<String, dynamic>?> getOpenPositionById(String id) async {
    final result = await _db.getOpenPositionById(id);
    return result != null ? _mapOpenPositionToMap(result) : null;
  }

  @override
  Future<void> insertOpenPosition(Map<String, dynamic> data) async {
    final companion = _mapToOpenPositionCompanion(data);
    await _db.into(_db.openPositions).insert(companion);
  }

  @override
  Future<void> insertOpenPositionsBatch(List<Map<String, dynamic>> data) async {
    await _db.batch((batch) {
      for (final item in data) {
        final companion = _mapToOpenPositionCompanion(item);
        batch.insert(_db.openPositions, companion);
      }
    });
  }

  @override
  Future<void> updateOpenPosition(Map<String, dynamic> data) async {
    final companion = _mapToOpenPositionCompanion(data);
    await _db.update(_db.openPositions).replace(companion);
  }

  @override
  Future<void> deleteOpenPosition(String id) async {
    await (_db.delete(_db.openPositions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedOpenPositions(String userId) async {
    final results = await _db.getUnsyncedOpenPositions(userId);
    return results.map((row) => _mapOpenPositionToMap(row)).toList();
  }

  // ============================================
  // Finance Records
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> getAllFinanceRecords(String userId) async {
    final results = await _db.getAllFinanceRecordsByUser(userId);
    return results.map((row) => _mapFinanceRecordToMap(row)).toList();
  }

  @override
  Future<void> insertFinanceRecord(Map<String, dynamic> data) async {
    final companion = _mapToFinanceRecordCompanion(data);
    await _db.into(_db.financeRecords).insert(companion);
  }

  @override
  Future<void> insertFinanceRecordsBatch(List<Map<String, dynamic>> data) async {
    await _db.batch((batch) {
      for (final item in data) {
        final companion = _mapToFinanceRecordCompanion(item);
        batch.insert(_db.financeRecords, companion);
      }
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getUnsyncedFinanceRecords(String userId) async {
    final results = await _db.getUnsyncedFinanceRecords(userId);
    return results.map((row) => _mapFinanceRecordToMap(row)).toList();
  }

  // ============================================
  // Query with Filters
  // ============================================

  @override
  Future<List<Map<String, dynamic>>> queryClosedPositions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    String? side,
    List<String>? reasons,
  }) async {
    final results = await _db.queryClosedPositions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      symbols: symbols,
      side: side,
      reasons: reasons,
    );
    return results.map((row) => _mapClosedPositionToMap(row)).toList();
  }

  // ============================================
  // Merge Operations (for sync)
  // ============================================

  @override
  Future<void> mergeClosedPositions(List<Map<String, dynamic>> data) async {
    await _db.mergeClosedPositions(data);
  }

  @override
  Future<void> mergeOpenPositions(List<Map<String, dynamic>> data) async {
    await _db.mergeOpenPositions(data);
  }

  @override
  Future<void> mergeFinanceRecords(List<Map<String, dynamic>> data) async {
    await _db.mergeFinanceRecords(data);
  }

  @override
  Future<void> markAsSynced(String id, String table) async {
    switch (table) {
      case 'closed_positions':
        await (_db.update(_db.closedPositions)
              ..where((t) => t.id.equals(id)))
            .write(const ClosedPositionsCompanion(isSynced: Value(true)));
        break;
      case 'open_positions':
        await (_db.update(_db.openPositions)
              ..where((t) => t.id.equals(id)))
            .write(const OpenPositionsCompanion(isSynced: Value(true)));
        break;
      case 'finance_records':
        await (_db.update(_db.financeRecords)
              ..where((t) => t.id.equals(id)))
            .write(const FinanceRecordsCompanion(isSynced: Value(true)));
        break;
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  Map<String, dynamic> _mapClosedPositionToMap(ClosedPositionData row) {
    return {
      'id': row.id,
      'user_id': row.userId,
      'symbol': row.symbol,
      'open_time': row.openTime.toIso8601String(),
      'close_time': row.closeTime.toIso8601String(),
      'volume': row.volume,
      'side': row.side,
      'open_price': row.openPrice,
      'close_price': row.closePrice,
      'stop_loss': row.stopLoss,
      'take_profit': row.takeProfit,
      'swap': row.swap,
      'commission': row.commission,
      'profit': row.profit,
      'reason': row.reason,
      'created_at': row.createdAt.toIso8601String(),
      'updated_at': row.updatedAt.toIso8601String(),
      'is_synced': row.isSynced,
    };
  }

  ClosedPositionsCompanion _mapToClosedPositionCompanion(
    Map<String, dynamic> data,
  ) {
    return ClosedPositionsCompanion(
      id: Value(data['id'] as String),
      userId: Value(data['user_id'] as String),
      symbol: Value(data['symbol'] as String),
      openTime: data['open_time'] is DateTime
          ? Value(data['open_time'] as DateTime)
          : Value(DateTime.parse(data['open_time'] as String)),
      closeTime: data['close_time'] is DateTime
          ? Value(data['close_time'] as DateTime)
          : Value(DateTime.parse(data['close_time'] as String)),
      volume: Value(data['volume'] as double),
      side: Value(data['side'] as String),
      openPrice: Value(data['open_price'] as double),
      closePrice: Value(data['close_price'] as double),
      stopLoss: data['stop_loss'] == null
          ? const Value.absent()
          : Value(data['stop_loss'] as double),
      takeProfit: data['take_profit'] == null
          ? const Value.absent()
          : Value(data['take_profit'] as double),
      swap: Value(data['swap'] as double? ?? 0.0),
      commission: Value(data['commission'] as double? ?? 0.0),
      profit: Value(data['profit'] as double),
      reason: Value(data['reason'] as String),
      createdAt: data['created_at'] is DateTime
          ? Value(data['created_at'] as DateTime)
          : Value(DateTime.parse(data['created_at'] as String)),
      updatedAt: data['updated_at'] is DateTime
          ? Value(data['updated_at'] as DateTime)
          : Value(DateTime.parse(data['updated_at'] as String)),
      isSynced: Value(data['is_synced'] as bool? ?? false),
    );
  }

  Map<String, dynamic> _mapOpenPositionToMap(OpenPositionData row) {
    return {
      'id': row.id,
      'user_id': row.userId,
      'symbol': row.symbol,
      'open_time': row.openTime.toIso8601String(),
      'volume': row.volume,
      'side': row.side,
      'open_price': row.openPrice,
      'current_price': row.currentPrice,
      'stop_loss': row.stopLoss,
      'take_profit': row.takeProfit,
      'swap': row.swap,
      'commission': row.commission,
      'profit': row.profit,
      'created_at': row.createdAt.toIso8601String(),
      'updated_at': row.updatedAt.toIso8601String(),
      'is_synced': row.isSynced,
    };
  }

  OpenPositionsCompanion _mapToOpenPositionCompanion(
    Map<String, dynamic> data,
  ) {
    return OpenPositionsCompanion(
      id: Value(data['id'] as String),
      userId: Value(data['user_id'] as String),
      symbol: Value(data['symbol'] as String),
      openTime: data['open_time'] is DateTime
          ? Value(data['open_time'] as DateTime)
          : Value(DateTime.parse(data['open_time'] as String)),
      volume: Value(data['volume'] as double),
      side: Value(data['side'] as String),
      openPrice: Value(data['open_price'] as double),
      currentPrice: Value(data['current_price'] as double?),
      stopLoss: data['stop_loss'] == null
          ? const Value.absent()
          : Value(data['stop_loss'] as double),
      takeProfit: data['take_profit'] == null
          ? const Value.absent()
          : Value(data['take_profit'] as double),
      swap: Value(data['swap'] as double? ?? 0.0),
      commission: Value(data['commission'] as double? ?? 0.0),
      profit: Value(data['profit'] as double),
      createdAt: data['created_at'] is DateTime
          ? Value(data['created_at'] as DateTime)
          : Value(DateTime.parse(data['created_at'] as String)),
      updatedAt: data['updated_at'] is DateTime
          ? Value(data['updated_at'] as DateTime)
          : Value(DateTime.parse(data['updated_at'] as String)),
      isSynced: Value(data['is_synced'] as bool? ?? false),
    );
  }

  Map<String, dynamic> _mapFinanceRecordToMap(FinanceRecordData row) {
    return {
      'id': row.id,
      'user_id': row.userId,
      'type': row.type,
      'time': row.time.toIso8601String(),
      'amount': row.amount,
      'status': row.status,
      'payment_gateway': row.paymentGateway,
      'details': row.details,
      'created_at': row.createdAt.toIso8601String(),
      'updated_at': row.updatedAt.toIso8601String(),
      'is_synced': row.isSynced,
    };
  }

  FinanceRecordsCompanion _mapToFinanceRecordCompanion(
    Map<String, dynamic> data,
  ) {
    return FinanceRecordsCompanion(
      id: Value(data['id'] as String),
      userId: Value(data['user_id'] as String),
      type: Value(data['type'] as String),
      time: data['time'] is DateTime
          ? Value(data['time'] as DateTime)
          : Value(DateTime.parse(data['time'] as String)),
      amount: Value(data['amount'] as double),
      status: Value(data['status'] as String),
      paymentGateway: Value(data['payment_gateway'] as String),
      details: Value(data['details'] as String?),
      createdAt: data['created_at'] is DateTime
          ? Value(data['created_at'] as DateTime)
          : Value(DateTime.parse(data['created_at'] as String)),
      updatedAt: data['updated_at'] is DateTime
          ? Value(data['updated_at'] as DateTime)
          : Value(DateTime.parse(data['updated_at'] as String)),
      isSynced: Value(data['is_synced'] as bool? ?? false),
    );
  }
}
