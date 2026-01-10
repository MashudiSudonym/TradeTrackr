import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';

class GetTradeUseCase implements UseCase<Result<TradeEntity>, String> {
  final TradeRepository _tradeRepository;

  GetTradeUseCase({required TradeRepository tradeRepository})
    : _tradeRepository = tradeRepository;

  @override
  Future<Result<TradeEntity>> call(String params) async {
    return _tradeRepository.getTradeById(params);
  }
}
