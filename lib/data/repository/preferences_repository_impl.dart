import 'package:drift/drift.dart';
import 'package:trade_trackr/core/constants/constants.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppDatabase _db;

  PreferencesRepositoryImpl({AppDatabase? db}) : _db = db ?? AppDatabase();

  @override
  Future<Result<PreferencesEntity>> getPreferences() async {
    try {
      final prefRow = await (_db.select(
        _db.preferencesTable,
      )..where((tbl) => tbl.id.equals('default'))).getSingleOrNull();

      if (prefRow != null) {
        Constants.logger.d('success');
        return Result.success(
          PreferencesEntity(is24HourFormat: prefRow.is24HourFormat),
        );
      } else {
        Constants.logger.e('Failed!');
        return Result.success(PreferencesEntity(is24HourFormat: false));
      }
    } catch (e) {
      Constants.logger.e('Failed to get preferences: $e');
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

      Constants.logger.d('success');
      return Result.success(null);
    } catch (e) {
      Constants.logger.e('Failed to save preferences: $e');
      return Result.failed(e.toString());
    }
  }
}
