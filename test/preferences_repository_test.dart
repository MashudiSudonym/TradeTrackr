import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';
import 'package:trade_trackr/data/repository/preferences_repository_impl.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';

void main() {
  late AppDatabase db;
  late PreferencesRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = PreferencesRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('PreferencesRepositoryImpl', () {
    test('getPreferences should return success when preferences exist', () async {
      final prefCompanion = PreferencesTableCompanion(
        id: const Value('default'),
        is24HourFormat: const Value(true),
      );

      await db.into(db.preferencesTable).insert(prefCompanion);

      final result = await repository.getPreferences();

      expect(result.isSuccess, true);
      expect(result.resultValue!.is24HourFormat, true);
    });

    test('getPreferences should return default when preferences not exist', () async {
      final result = await repository.getPreferences();

      expect(result.isSuccess, true);
      expect(result.resultValue!.is24HourFormat, false);
    });

    test('savePreferences should return success when save succeeds', () async {
      final preferencesEntity = PreferencesEntity(is24HourFormat: true);

      final result = await repository.savePreferences(preferencesEntity: preferencesEntity);

      expect(result.isSuccess, true);

      // Verify it was saved
      final saved = await repository.getPreferences();
      expect(saved.resultValue!.is24HourFormat, true);
    });
  });
}