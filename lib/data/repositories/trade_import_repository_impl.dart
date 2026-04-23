import '../../domain/repositories/trade_import_repository.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/enums/finance_type.dart';
import '../../domain/core/result.dart';
import '../datasources/trade_local_data_source.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

/// Implementation of TradeImportRepository.
///
/// Handles CSV import operations for trade data.
/// CSV format: dd/MM/yyyy HH:mm:ss
class TradeImportRepositoryImpl implements TradeImportRepository {
  final TradeLocalDataSource _localDataSource;
  final Uuid _uuid = const Uuid();

  /// Date format for CSV parsing: dd/MM/yyyy HH:mm:ss
  static final _csvDateFormat = RegExp(r'^(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2}):(\d{2})$');

  TradeImportRepositoryImpl(this._localDataSource);

  @override
  Future<Result<ImportResult>> importFromCsv(String filePath) async {
    try {
      final file = File(filePath);
      final input = await file.readAsString();
      final fields = const CsvToListConverter(eol: '\n').convert(input);

      if (fields.isEmpty) {
        return const Result.failure('CSV file is empty');
      }

      // TODO: Detect file type and route to appropriate import
      return const Result.success(ImportResult(imported: 0));
    } catch (e) {
      return Result.failure('Failed to parse CSV: $e');
    }
  }

  @override
  Future<Result<ImportResult>> importClosedPositionsFromCsv(
    String filePath,
    String userId,
  ) async {
    try {
      final file = File(filePath);
      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return const Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final positions = <ClosedPosition>[];
      final positionsToInsert = <Map<String, dynamic>>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 14) {
          skipped++;
          continue;
        }

        try {
          final position = ClosedPosition(
            id: row[0]?.toString() ?? '',
            userId: userId,
            symbol: row[1]?.toString() ?? '',
            openTime: _parseDateTime(row[2]?.toString()),
            closeTime: _parseDateTime(row[5]?.toString()),
            volume: _parseDouble(row[3]),
            side: _parseSide(row[4]?.toString()),
            openPrice: _parseDouble(row[6]),
            closePrice: _parseDouble(row[7]),
            stopLoss: _parseNullableDouble(row[8]),
            takeProfit: _parseNullableDouble(row[9]),
            swap: _parseDouble(row[10]),
            commission: _parseDouble(row[11]),
            profit: _parseDouble(row[12]),
            reason: _parseCloseReason(row[13]?.toString()),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: false,
          );
          positions.add(position);
          positionsToInsert.add(_closedPositionToMap(position));
        } catch (e) {
          skipped++;
        }
      }

      // Persist to database
      if (positionsToInsert.isNotEmpty) {
        await _localDataSource.insertClosedPositionsBatch(positionsToInsert);
      }

      return Result.success(ImportResult(
        imported: positions.length,
        skipped: skipped,
      ));
    } catch (e) {
      return Result.failure('Failed to parse closed positions CSV: $e');
    }
  }

  @override
  Future<Result<ImportResult>> importOpenPositionsFromCsv(
    String filePath,
    String userId,
  ) async {
    try {
      final file = File(filePath);
      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return const Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final positions = <OpenPosition>[];
      final positionsToInsert = <Map<String, dynamic>>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 12) {
          skipped++;
          continue;
        }

        try {
          final position = OpenPosition(
            id: row[0]?.toString() ?? '',
            userId: userId,
            symbol: row[1]?.toString() ?? '',
            openTime: _parseDateTime(row[2]?.toString()),
            volume: _parseDouble(row[3]),
            side: _parseSide(row[4]?.toString()),
            openPrice: _parseDouble(row[5]),
            currentPrice: _parseNullableDouble(row[6]),
            stopLoss: _parseNullableDouble(row[7]),
            takeProfit: _parseNullableDouble(row[8]),
            swap: _parseDouble(row[9]),
            commission: _parseDouble(row[10]),
            profit: _parseDouble(row[11]),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: false,
          );
          positions.add(position);
          positionsToInsert.add(_openPositionToMap(position));
        } catch (e) {
          skipped++;
        }
      }

      // Persist to database
      if (positionsToInsert.isNotEmpty) {
        await _localDataSource.insertOpenPositionsBatch(positionsToInsert);
      }

      return Result.success(ImportResult(
        imported: positions.length,
        skipped: skipped,
      ));
    } catch (e) {
      return Result.failure('Failed to parse open positions CSV: $e');
    }
  }

  @override
  Future<Result<ImportResult>> importFinanceRecordsFromCsv(
    String filePath,
    String userId,
  ) async {
    try {
      final file = File(filePath);
      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return const Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final records = <FinanceRecord>[];
      final recordsToInsert = <Map<String, dynamic>>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 6) {
          skipped++;
          continue;
        }

        try {
          final record = FinanceRecord(
            id: _uuid.v4(), // Generate UUID for finance records
            userId: userId,
            type: _parseFinanceType(row[0]?.toString()),
            time: _parseDateTime(row[1]?.toString()),
            amount: _parseDouble(row[2]),
            status: row[3]?.toString() ?? 'Done',
            paymentGateway: row[4]?.toString() ?? 'Manual',
            details: row[5]?.toString() ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: false,
          );
          records.add(record);
          recordsToInsert.add(_financeRecordToMap(record));
        } catch (e) {
          skipped++;
        }
      }

      // Persist to database
      if (recordsToInsert.isNotEmpty) {
        await _localDataSource.insertFinanceRecordsBatch(recordsToInsert);
      }

      return Result.success(ImportResult(
        imported: records.length,
        skipped: skipped,
      ));
    } catch (e) {
      return Result.failure('Failed to parse finance records CSV: $e');
    }
  }

  // ========== Helper Methods ==========

  DateTime _parseDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return DateTime.now();
    }

    final match = _csvDateFormat.firstMatch(value);
    if (match != null) {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final second = int.parse(match.group(6)!);
      return DateTime.utc(year, month, day, hour, minute, second);
    }

    throw FormatException('Invalid date format: $value');
  }

  double _parseDouble(dynamic value) {
    if (value == null || value == '') return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double? _parseNullableDouble(dynamic value) {
    if (value == null || value == '') return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  TradeSide _parseSide(String? value) {
    if (value == null) return TradeSide.buy;
    final upper = value.toUpperCase();
    return upper == 'SELL' ? TradeSide.sell : TradeSide.buy;
  }

  CloseReason _parseCloseReason(String? value) {
    if (value == null) return CloseReason.manual;
    final upper = value.toUpperCase();
    switch (upper) {
      case 'TP':
        return CloseReason.tp;
      case 'SL':
        return CloseReason.sl;
      case 'USER':
        return CloseReason.user;
      default:
        return CloseReason.manual;
    }
  }

  FinanceType _parseFinanceType(String? value) {
    if (value == null) return FinanceType.deposit;
    final lower = value.toLowerCase();
    return lower == 'withdrawal' ? FinanceType.withdrawal : FinanceType.deposit;
  }

  // ========== Entity to Map Converters ==========

  /// Converts ClosedPosition entity to Map with snake_case keys for database.
  Map<String, dynamic> _closedPositionToMap(ClosedPosition position) {
    return {
      'id': position.id,
      'user_id': position.userId,
      'symbol': position.symbol,
      'open_time': position.openTime,
      'close_time': position.closeTime,
      'volume': position.volume,
      'side': position.side.name.toUpperCase(),
      'open_price': position.openPrice,
      'close_price': position.closePrice,
      'stop_loss': position.stopLoss,
      'take_profit': position.takeProfit,
      'swap': position.swap,
      'commission': position.commission,
      'profit': position.profit,
      'reason': position.reason.name.toUpperCase(),
      'created_at': position.createdAt,
      'updated_at': position.updatedAt,
      'is_synced': position.isSynced,
    };
  }

  /// Converts OpenPosition entity to Map with snake_case keys for database.
  Map<String, dynamic> _openPositionToMap(OpenPosition position) {
    return {
      'id': position.id,
      'user_id': position.userId,
      'symbol': position.symbol,
      'open_time': position.openTime,
      'volume': position.volume,
      'side': position.side.name.toUpperCase(),
      'open_price': position.openPrice,
      'current_price': position.currentPrice,
      'stop_loss': position.stopLoss,
      'take_profit': position.takeProfit,
      'swap': position.swap,
      'commission': position.commission,
      'profit': position.profit,
      'created_at': position.createdAt,
      'updated_at': position.updatedAt,
      'is_synced': position.isSynced,
    };
  }

  /// Converts FinanceRecord entity to Map with snake_case keys for database.
  Map<String, dynamic> _financeRecordToMap(FinanceRecord record) {
    return {
      'id': record.id,
      'user_id': record.userId,
      'type': record.type.name.toUpperCase(),
      'time': record.time,
      'amount': record.amount,
      'status': record.status,
      'payment_gateway': record.paymentGateway,
      'details': record.details,
      'created_at': record.createdAt,
      'updated_at': record.updatedAt,
      'is_synced': record.isSynced,
    };
  }
}
