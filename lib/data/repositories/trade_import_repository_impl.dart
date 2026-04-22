import '../../domain/repositories/trade_import_repository.dart';
import '../../domain/entities/closed_position.dart';
import '../../domain/entities/open_position.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/enums/trade_side.dart';
import '../../domain/enums/close_reason.dart';
import '../../domain/enums/finance_type.dart';
import '../../domain/core/result.dart';
import 'package:csv/csv.dart';
import 'dart:io';

/// Implementation of TradeImportRepository.
///
/// Handles CSV import operations for trade data.
/// CSV format: dd/MM/yyyy HH:mm:ss
class TradeImportRepositoryImpl implements TradeImportRepository {
  /// Date format for CSV parsing: dd/MM/yyyy HH:mm:ss
  static final _csvDateFormat = RegExp(r'^(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2}):(\d{2})$');

  @override
  Future<Result<ImportResult>> importFromCsv(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Result.failure('File not found: $filePath');
      }

      final input = await file.readAsString();
      final fields = const CsvToListConverter(eol: '\n').convert(input);

      if (fields.isEmpty) {
        return Result.failure('CSV file is empty');
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
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Result.failure('File not found: $filePath');
      }

      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final positions = <ClosedPosition>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 14) {
          skipped++;
          continue;
        }

        try {
          final position = ClosedPosition(
            id: row[0]?.toString() ?? '',
            userId: '', // Will be set by use case
            symbol: row[1]?.toString() ?? '',
            openTime: _parseDateTime(row[2]?.toString()),
            closeTime: _parseDateTime(row[6]?.toString()),
            volume: _parseDouble(row[3]),
            side: _parseSide(row[4]?.toString()),
            openPrice: _parseDouble(row[7]),
            closePrice: _parseDouble(row[8]),
            stopLoss: _parseNullableDouble(row[9]),
            takeProfit: _parseNullableDouble(row[10]),
            swap: _parseDouble(row[11]),
            commission: _parseDouble(row[12]),
            profit: _parseDouble(row[13]),
            reason: _parseCloseReason(row[14]?.toString()),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: false,
          );
          positions.add(position);
        } catch (e) {
          skipped++;
        }
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
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Result.failure('File not found: $filePath');
      }

      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final positions = <OpenPosition>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 12) {
          skipped++;
          continue;
        }

        try {
          final position = OpenPosition(
            id: row[0]?.toString() ?? '',
            userId: '', // Will be set by use case
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
        } catch (e) {
          skipped++;
        }
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
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Result.failure('File not found: $filePath');
      }

      final input = await file.readAsString();
      final rows = const CsvToListConverter().convert(input);

      if (rows.isEmpty) {
        return Result.failure('CSV file is empty');
      }

      // Skip header row and total row
      final dataRows = rows.skip(1).where((row) {
        if (row.isEmpty || row[0] == null) return false;
        final firstCell = row[0].toString().toLowerCase();
        return firstCell != 'total';
      }).toList();

      final records = <FinanceRecord>[];
      var skipped = 0;

      for (final row in dataRows) {
        if (row.length < 6) {
          skipped++;
          continue;
        }

        try {
          final record = FinanceRecord(
            id: '', // Will be generated
            userId: '', // Will be set by use case
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
        } catch (e) {
          skipped++;
        }
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
}
