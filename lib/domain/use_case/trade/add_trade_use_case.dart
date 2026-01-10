import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';

class AddTradeUseCase implements UseCase<Result<void>, TradeEntity> {
  final TradeRepository _tradeRepository;

  AddTradeUseCase({required TradeRepository tradeRepository})
    : _tradeRepository = tradeRepository;

  @override
  Future<Result<void>> call(TradeEntity params) async {
    return _tradeRepository.insertTrade(params);
  }
}
