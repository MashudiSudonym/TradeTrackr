import 'package:trade_trackr/domain/entity/trade_entity.dart';
import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/domain/use_case/trade/get_trades_params.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';

class GetTradesUseCase
    implements UseCase<Result<List<TradeEntity>>, GetTradesParams> {
  final TradeRepository _tradeRepository;

  GetTradesUseCase({required TradeRepository tradeRepository})
    : _tradeRepository = tradeRepository;

  @override
  Future<Result<List<TradeEntity>>> call(GetTradesParams params) async {
    return _tradeRepository.getTrades(
      startDate: params.startDate,
      endDate: params.endDate,
      symbol: params.symbol,
      status: params.status,
    );
  }
}
