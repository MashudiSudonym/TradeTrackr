import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/presentation/provider/preferences/preferences_provider.dart';
import 'package:trade_trackr/presentation/provider/use_case/save_preferences_use_case_provider.dart';
import 'package:trade_trackr/presentation/provider/use_case/user_onboarding_use_case_provider.dart';
import 'package:trade_trackr/result.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<void> build() {
    // Initial state is null (idle)
    return null;
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    String? email,
    required bool is24HourFormat,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final userOnboardingUseCase = ref.read(userOnboardingUseCaseProvider);
      final savePreferencesUseCase = ref.read(savePreferencesUseCaseProvider);

      // Save User Data
      final userResult = await userOnboardingUseCase(
        UserOnboardingParams(
          firstName: firstName,
          lastName: lastName,
          email: email,
        ),
      );

      if (userResult is Failed) {
        throw Exception(userResult.errorMessage);
      }

      // Save Preferences
      final prefResult = await savePreferencesUseCase(
        SavePreferencesParams(
          is24HourFormat: is24HourFormat,
          isRegistered: true,
        ),
      );

      if (prefResult is Failed) {
        throw Exception(prefResult.errorMessage);
      }

      // Invalidate preferences so router can redirect
      ref.invalidate(preferencesProvider);
    });
  }
}
