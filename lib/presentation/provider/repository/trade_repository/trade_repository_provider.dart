import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/data/repository/trade_repository_impl.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/presentation/provider/database/database_provider.dart';

part 'trade_repository_provider.g.dart';

@riverpod
TradeRepository tradeRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TradeRepositoryImpl(db: db);
}
