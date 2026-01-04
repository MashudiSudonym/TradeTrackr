import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/presentation/provider/preferences/preferences_provider.dart';
import 'package:trade_trackr/presentation/provider/use_case/save_preferences_use_case_provider.dart';
import 'package:trade_trackr/presentation/provider/use_case/user_onboarding_use_case_provider.dart';
import 'package:trade_trackr/result.dart';
import 'register_state.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  RegisterState build() => const RegisterState();

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  void updateLastName(String value) {
    state = state.copyWith(lastName: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void set24HourFormat(bool value) {
    state = state.copyWith(use24HourFormat: value);
  }

  Future<void> register() async {
    state = state.copyWith(showErrors: true);

    if (!state.isFormValid) return;

    state = state.copyWith(registrationStatus: const AsyncLoading());

    final registrationResult = await AsyncValue.guard(() async {
      final userOnboardingUseCase = ref.read(userOnboardingUseCaseProvider);
      final savePreferencesUseCase = ref.read(savePreferencesUseCaseProvider);

      // Save User Data
      final userResult = await userOnboardingUseCase(
        UserOnboardingParams(
          firstName: state.firstName.trim(),
          lastName: state.lastName.trim(),
          email: state.email.trim(),
        ),
      );

      if (userResult is Failed) {
        throw Exception(userResult.errorMessage);
      }

      // Save Preferences
      final prefResult = await savePreferencesUseCase(
        SavePreferencesParams(
          is24HourFormat: state.use24HourFormat,
          isRegistered: true,
        ),
      );

      if (prefResult is Failed) {
        throw Exception(prefResult.errorMessage);
      }

      // Invalidate preferences so router can redirect
      ref.invalidate(preferencesProvider);
    });

    state = state.copyWith(registrationStatus: registrationResult);
  }
}
