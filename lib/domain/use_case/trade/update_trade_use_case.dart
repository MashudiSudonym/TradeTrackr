import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';

class UpdateTradeUseCase implements UseCase<Result<void>, TradeEntity> {
  final TradeRepository _tradeRepository;

  UpdateTradeUseCase({required TradeRepository tradeRepository})
    : _tradeRepository = tradeRepository;

  @override
  Future<Result<void>> call(TradeEntity params) async {
    return _tradeRepository.updateTrade(params);
  }
}
