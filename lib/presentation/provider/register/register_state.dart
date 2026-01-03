import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default(false) bool use24HourFormat,
    @Default(false) bool showErrors,
    @Default(AsyncValue.data(null)) AsyncValue<void> registrationStatus,
  }) = _RegisterState;

  const RegisterState._();

  bool get isEmailValid =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());

  bool get isFormValid =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty && isEmailValid;

  String? get firstNameError {
    if (!showErrors) return null;
    if (firstName.trim().isEmpty) return 'First name is required';
    return null;
  }

  String? get lastNameError {
    if (!showErrors) return null;
    if (lastName.trim().isEmpty) return 'Last name is required';
    return null;
  }

  String? get emailError {
    if (!showErrors) return null;
    final emailTrimmed = email.trim();
    if (emailTrimmed.isEmpty) return 'Email is required';
    if (!isEmailValid) return 'Invalid email format';
    return null;
  }
}
