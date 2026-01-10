import 'package:trade_trackr/domain/repository/trade_repository.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/use_case.dart';

class DeleteTradeUseCase implements UseCase<Result<void>, String> {
  final TradeRepository _tradeRepository;

  DeleteTradeUseCase({required TradeRepository tradeRepository})
    : _tradeRepository = tradeRepository;

  @override
  Future<Result<void>> call(String params) async {
    return _tradeRepository.deleteTrade(params);
  }
}
