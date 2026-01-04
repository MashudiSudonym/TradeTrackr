import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/data/repository/preferences_repository_impl.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';
import 'package:trade_trackr/presentation/provider/database/database_provider.dart';

part 'preferences_repository_provider.g.dart';

@riverpod
PreferencesRepository preferencesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PreferencesRepositoryImpl(db: db);
}
