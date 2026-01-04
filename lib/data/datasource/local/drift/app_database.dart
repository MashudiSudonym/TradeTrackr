import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'user_table.dart';
import 'preferences_table.dart';
import 'trade_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [UserTable, PreferencesTable, Trades])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'trade_trackr_db',
      native: const DriftNativeOptions(),
    );
  }
}
