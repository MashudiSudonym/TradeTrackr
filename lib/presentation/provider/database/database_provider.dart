import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/data/datasource/local/drift/app_database.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
