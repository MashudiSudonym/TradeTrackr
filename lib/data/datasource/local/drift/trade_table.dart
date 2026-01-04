import 'package:drift/drift.dart';

class Trades extends Table {
  TextColumn get id => text()();
  TextColumn get symbol => text()();
  DateTimeColumn get openTime => dateTime()();
  DateTimeColumn get closeTime => dateTime()();
  RealColumn get volume => real()();
  TextColumn get side => text()(); // BUY/SELL
  TextColumn get tradeStatus => text()(); // Open/Close
  RealColumn get openPrice => real()();
  RealColumn get closePrice => real()();
  RealColumn get stopLoss => real()();
  RealColumn get takeProfit => real()();
  RealColumn get swap => real().withDefault(const Constant(0.0))();
  RealColumn get commission => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real()();
  RealColumn get profitPercent => real().nullable()();
  TextColumn get exitReason => text().nullable()();
  TextColumn get entryReason => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
