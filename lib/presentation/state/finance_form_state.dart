import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/finance_record.dart';
import '../../domain/enums/finance_type.dart';

part 'finance_form_state.freezed.dart';

@freezed
abstract class FinanceFormState with _$FinanceFormState {
  const factory FinanceFormState.initial({
    @Default(FinanceType.deposit) FinanceType type,
    DateTime? time,
    @Default(0.0) double amount,
    @Default('Done') String status,
    @Default('Manual') String paymentGateway,
    String? details,
    @Default({}) Map<String, String> validationErrors,
  }) = FinanceFormInitial;

  const factory FinanceFormState.loading() = FinanceFormLoading;

  const factory FinanceFormState.success({
    required FinanceRecord record,
  }) = FinanceFormSuccess;

  const factory FinanceFormState.error(String message) = FinanceFormError;
}
