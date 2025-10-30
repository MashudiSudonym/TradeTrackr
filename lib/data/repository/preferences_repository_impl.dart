import 'package:drift/drift.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppDatabase _db;

  PreferencesRepositoryImpl(this._db);

  @override
  Future<Result<PreferencesEntity>> getPreferences() async {
    try {
      final prefRow = await (_db.select(
        _db.preferencesTable,
      )..where((tbl) => tbl.id.equals('default'))).getSingleOrNull();

      if (prefRow != null) {
        return Result.success(
          PreferencesEntity(is24HourFormat: prefRow.is24HourFormat),
        );
      } else {
        return Result.success(PreferencesEntity(is24HourFormat: false));
      }
    } catch (e) {
      return Result.failed(e.toString());
    }
  }

  @override
  Future<Result<void>> savePreferences({
    required PreferencesEntity preferencesEntity,
  }) async {
    try {
      await _db
          .into(_db.preferencesTable)
          .insertOnConflictUpdate(
            PreferencesTableCompanion(
              id: Value('default'),
              is24HourFormat: Value(preferencesEntity.is24HourFormat),
            ),
          );
      return Result.success(null);
    } catch (e) {
      return Result.failed(e.toString());
    }
  }
}
