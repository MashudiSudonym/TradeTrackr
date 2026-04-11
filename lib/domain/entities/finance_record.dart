import '../enums/finance_type.dart';

/// Represents a deposit or withdrawal transaction.
class FinanceRecord {
  final String id;
  final String userId;
  final FinanceType type;
  final DateTime time;
  final double amount;
  final String status;
  final String paymentGateway;
  final String details;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const FinanceRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.time,
    required this.amount,
    required this.status,
    required this.paymentGateway,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  /// Signed amount: positive for deposits, negative for withdrawals.
  double get signedAmount => type.isDeposit ? amount : -amount;
}
