import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/finance_record.dart';
import '../../domain/enums/finance_type.dart';

part 'finance_record_dto.freezed.dart';
part 'finance_record_dto.g.dart';

/// Freezed DTO for finance records.
///
/// Used for serialization to/from Drift and Supabase.
@freezed
abstract class FinanceRecordDto with _$FinanceRecordDto {
  const FinanceRecordDto._();

  const factory FinanceRecordDto({
    required String id,
    required String userId,
    required String type,
    required DateTime time,
    required double amount,
    required String status,
    required String paymentGateway,
    required String details,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _FinanceRecordDto;

  factory FinanceRecordDto.fromJson(Map<String, dynamic> json) =>
      _$FinanceRecordDtoFromJson(json);

  /// Convert to domain entity.
  FinanceRecord toEntity() {
    return FinanceRecord(
      id: id,
      userId: userId,
      type: type == 'Deposit' ? FinanceType.deposit : FinanceType.withdrawal,
      time: time,
      amount: amount,
      status: status,
      paymentGateway: paymentGateway,
      details: details,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  /// Convert from domain entity.
  factory FinanceRecordDto.fromEntity(FinanceRecord entity) {
    return FinanceRecordDto(
      id: entity.id,
      userId: entity.userId,
      type: entity.type.name,
      time: entity.time,
      amount: entity.amount,
      status: entity.status,
      paymentGateway: entity.paymentGateway,
      details: entity.details,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert to JSON map for Supabase.
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'type': type,
        'time': time.toIso8601String(),
        'amount': amount,
        'status': status,
        'payment_gateway': paymentGateway,
        'details': details,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_synced': isSynced,
      };
}
