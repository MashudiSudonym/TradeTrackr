import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/user_onboarding_use_case_provider.dart';

part 'user_setup.g.dart';

@riverpod
Future<void> userSetup(
  Ref ref, {
  required String firstName,
  required String lastName,
  String? email,
}) async {
  UserOnboardingUseCase userOnboardingUseCase = ref.read(
    userOnboardingUseCaseProvider,
  );

  var result = await userOnboardingUseCase(
    UserOnboardingParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
    ),
  );

  return switch (result) {
    Success(value: final userData) => userData,
    Failed(message: _) => null,
  };
}
