import 'package:drift/drift.dart';

class PreferencesTable extends Table {
  TextColumn get id => text().withLength(min: 1, max: 32)();
  BoolColumn get is24HourFormat => boolean().withDefault(Constant(false))();
  BoolColumn get isRegistered => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
