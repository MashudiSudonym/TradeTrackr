import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/data/repository/user_repository_impl.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/presentation/provider/database/database_provider.dart';

part 'user_repository_provider.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserRepositoryImpl(db: db);
}
