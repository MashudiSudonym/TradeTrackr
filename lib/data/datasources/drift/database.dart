import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

/// Closed positions table in Drift database.
///
/// Stores completed trade positions with entry and exit details.
@DataClassName('ClosedPositionData')
class ClosedPositions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get symbol => text()();
  DateTimeColumn get openTime => dateTime()();
  DateTimeColumn get closeTime => dateTime()();
  RealColumn get volume => real()();
  TextColumn get side => text()();
  RealColumn get openPrice => real()();
  RealColumn get closePrice => real()();
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();
  RealColumn get swap => real().withDefault(const Constant(0.0))();
  RealColumn get commission => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real()();
  TextColumn get reason => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Open positions table in Drift database.
///
/// Stores currently active trade positions.
@DataClassName('OpenPositionData')
class OpenPositions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get symbol => text()();
  DateTimeColumn get openTime => dateTime()();
  RealColumn get volume => real()();
  TextColumn get side => text()();
  RealColumn get openPrice => real()();
  RealColumn get currentPrice => real().nullable()();
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();
  RealColumn get swap => real().withDefault(const Constant(0.0))();
  RealColumn get commission => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Finance records table in Drift database.
///
/// Stores deposit and withdrawal transactions.
@DataClassName('FinanceRecordData')
class FinanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  DateTimeColumn get time => dateTime()();
  RealColumn get amount => real()();
  TextColumn get status => text()();
  TextColumn get paymentGateway => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// User profiles table in Drift database.
///
/// Stores user profile information synchronized with Supabase auth.
@DataClassName('ProfileData')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Main Drift database class for TradeTrackr.
///
/// Uses drift_flutter for platform-agnostic SQLite storage.
/// Follows offline-first pattern where this is the primary data source.
@DriftDatabase(tables: [ClosedPositions, OpenPositions, FinanceRecords, Profiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tradetrackr');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations
      },
    );
  }

  // ============================================
  // Closed Positions Queries
  // ============================================

  /// Get all closed positions for a user, ordered by close time descending.
  Future<List<ClosedPositionData>> getAllClosedPositionsByUser(String userId) {
    return (select(closedPositions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.closeTime)]))
        .get();
  }

  /// Get unsynced closed positions for a user.
  Future<List<ClosedPositionData>> getUnsyncedClosedPositions(String userId) {
    return (select(closedPositions)
          ..where((t) => t.userId.equals(userId) & t.isSynced.equals(false)))
        .get();
  }

  /// Get closed position by ID.
  Future<ClosedPositionData?> getClosedPositionById(String id) {
    return (select(closedPositions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Query closed positions with filters.
  Future<List<ClosedPositionData>> queryClosedPositions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    String? side,
    List<String>? reasons,
  }) {
    var query = select(closedPositions)
      ..where((t) => t.userId.equals(userId));

    if (startDate != null) {
      query = query..where((t) => t.openTime.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.closeTime.isSmallerOrEqualValue(endDate));
    }
    if (symbols != null && symbols.isNotEmpty) {
      query = query..where((t) => t.symbol.isIn(symbols));
    }
    if (side != null) {
      query = query..where((t) => t.side.equals(side));
    }
    if (reasons != null && reasons.isNotEmpty) {
      query = query..where((t) => t.reason.isIn(reasons));
    }

    return query.get();
  }

  // ============================================
  // Open Positions Queries
  // ============================================

  /// Get all open positions for a user, ordered by open time descending.
  Future<List<OpenPositionData>> getAllOpenPositionsByUser(String userId) {
    return (select(openPositions)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.openTime)]))
        .get();
  }

  /// Get unsynced open positions for a user.
  Future<List<OpenPositionData>> getUnsyncedOpenPositions(String userId) {
    return (select(openPositions)
          ..where((t) => t.userId.equals(userId) & t.isSynced.equals(false)))
        .get();
  }

  /// Get open position by ID.
  Future<OpenPositionData?> getOpenPositionById(String id) {
    return (select(openPositions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // ============================================
  // Finance Records Queries
  // ============================================

  /// Get all finance records for a user, ordered by time descending.
  Future<List<FinanceRecordData>> getAllFinanceRecordsByUser(String userId) {
    return (select(financeRecords)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.time)]))
        .get();
  }

  /// Get unsynced finance records for a user.
  Future<List<FinanceRecordData>> getUnsyncedFinanceRecords(String userId) {
    return (select(financeRecords)
          ..where((t) => t.userId.equals(userId) & t.isSynced.equals(false)))
        .get();
  }

  // ============================================
  // Profiles Queries
  // ============================================

  /// Get profile by user ID.
  Future<ProfileData?> getProfileById(String id) {
    return (select(profiles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // ============================================
  // Merge Operations (for sync)
  // ============================================

  /// Merge remote closed positions into local database (upsert).
  Future<void> mergeClosedPositions(List<Map<String, dynamic>> data) async {
    return transaction(() async {
      for (final row in data) {
        final companion = ClosedPositionsCompanion(
          id: Value(row['id'] as String),
          userId: Value(row['user_id'] as String),
          symbol: Value(row['symbol'] as String),
          openTime: Value(DateTime.parse(row['open_time'] as String)),
          closeTime: Value(DateTime.parse(row['close_time'] as String)),
          volume: Value(row['volume'] as double),
          side: Value(row['side'] as String),
          openPrice: Value(row['open_price'] as double),
          closePrice: Value(row['close_price'] as double),
          stopLoss: Value(row['stop_loss'] as double?),
          takeProfit: Value(row['take_profit'] as double?),
          swap: Value(row['swap'] as double? ?? 0.0),
          commission: Value(row['commission'] as double? ?? 0.0),
          profit: Value(row['profit'] as double),
          reason: Value(row['reason'] as String),
          createdAt: Value(DateTime.parse(row['created_at'] as String)),
          updatedAt: Value(DateTime.parse(row['updated_at'] as String)),
          isSynced: Value(row['is_synced'] as bool? ?? true),
        );
        await into(closedPositions).insertOnConflictUpdate(companion);
      }
    });
  }

  /// Merge remote open positions into local database (upsert).
  Future<void> mergeOpenPositions(List<Map<String, dynamic>> data) async {
    return transaction(() async {
      for (final row in data) {
        final companion = OpenPositionsCompanion(
          id: Value(row['id'] as String),
          userId: Value(row['user_id'] as String),
          symbol: Value(row['symbol'] as String),
          openTime: Value(DateTime.parse(row['open_time'] as String)),
          volume: Value(row['volume'] as double),
          side: Value(row['side'] as String),
          openPrice: Value(row['open_price'] as double),
          currentPrice: Value(row['current_price'] as double?),
          stopLoss: Value(row['stop_loss'] as double?),
          takeProfit: Value(row['take_profit'] as double?),
          swap: Value(row['swap'] as double? ?? 0.0),
          commission: Value(row['commission'] as double? ?? 0.0),
          profit: Value(row['profit'] as double),
          createdAt: Value(DateTime.parse(row['created_at'] as String)),
          updatedAt: Value(DateTime.parse(row['updated_at'] as String)),
          isSynced: Value(row['is_synced'] as bool? ?? true),
        );
        await into(openPositions).insertOnConflictUpdate(companion);
      }
    });
  }

  /// Merge remote finance records into local database (upsert).
  Future<void> mergeFinanceRecords(List<Map<String, dynamic>> data) async {
    return transaction(() async {
      for (final row in data) {
        final companion = FinanceRecordsCompanion(
          id: Value(row['id'] as String),
          userId: Value(row['user_id'] as String),
          type: Value(row['type'] as String),
          time: Value(DateTime.parse(row['time'] as String)),
          amount: Value(row['amount'] as double),
          status: Value(row['status'] as String),
          paymentGateway: Value(row['payment_gateway'] as String),
          details: Value(row['details'] as String?),
          createdAt: Value(DateTime.parse(row['created_at'] as String)),
          updatedAt: Value(DateTime.parse(row['updated_at'] as String)),
          isSynced: Value(row['is_synced'] as bool? ?? true),
        );
        await into(financeRecords).insertOnConflictUpdate(companion);
      }
    });
  }
}

/// Riverpod provider for AppDatabase singleton.
///
/// Uses drift_flutter for cross-platform database storage.
/// KeepAlive: true because database must persist across app lifecycle.
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
