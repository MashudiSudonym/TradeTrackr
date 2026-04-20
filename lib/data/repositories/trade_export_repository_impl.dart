import '../../domain/repositories/trade_export_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:csv/csv.dart';

/// Implementation of TradeExportRepository.
///
/// Handles CSV export operations for trade data.
class TradeExportRepositoryImpl implements TradeExportRepository {
  @override
  Future<Either<Failure, String>> exportClosedPositionsToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  }) async {
    try {
      // TODO: Query actual data from data source
      // For now, return empty CSV with header
      const header = [
        'ID',
        'Symbol',
        'Open Time',
        'Volume',
        'Side',
        'Close Time',
        'Open Price',
        'Close Price',
        'Stop Loss',
        'Take Profit',
        'Swap',
        'Commission',
        'Profit',
        'Reason'
      ];

      final csv = const ListToCsvConverter().convert([header]);
      return Right(csv);
    } catch (e) {
      return Left(DatabaseFailure('Failed to export closed positions: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportOpenPositionsToCsv() async {
    try {
      // TODO: Query actual data from data source
      const header = [
        'ID',
        'Symbol',
        'Open Time',
        'Volume',
        'Side',
        'Open Price',
        'Current Price',
        'Stop Loss',
        'Take Profit',
        'Swap',
        'Commission',
        'Profit'
      ];

      final csv = const ListToCsvConverter().convert([header]);
      return Right(csv);
    } catch (e) {
      return Left(DatabaseFailure('Failed to export open positions: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportFinanceRecordsToCsv() async {
    try {
      // TODO: Query actual data from data source
      const header = [
        'Type',
        'Time',
        'Amount',
        'Status',
        'Payment gateway',
        'Details'
      ];

      final csv = const ListToCsvConverter().convert([header]);
      return Right(csv);
    } catch (e) {
      return Left(DatabaseFailure('Failed to export finance records: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> exportAllToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  }) async {
    try {
      final closedResult = await exportClosedPositionsToCsv(
        startDate: startDate,
        endDate: endDate,
        symbols: symbols,
      );

      final openResult = await exportOpenPositionsToCsv();

      final financeResult = await exportFinanceRecordsToCsv();

      return closedResult.fold(
        (failure) => Left(failure),
        (closedCsv) {
          return openResult.fold(
            (failure) => Left(failure),
            (openCsv) {
              return financeResult.fold(
                (failure) => Left(failure),
                (financeCsv) {
                  return Right({
                    'closed_positions': closedCsv,
                    'open_positions': openCsv,
                    'finance_records': financeCsv,
                  });
                },
              );
            },
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to export all data: $e'));
    }
  }
}
