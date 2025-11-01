import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';
import 'package:trade_trackr/domain/use_case/user_profile/get_user_profile_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/get_user_profile_use_case_provider.dart';
import 'package:trade_trackr/presentation/provider/use_case/user_onboarding_use_case_provider.dart';

part 'user_setup.g.dart';

@Riverpod(keepAlive: true)
class UserSetup extends _$UserSetup {
  @override
  Future<UserEntity?> build() async {
    GetUserProfileUseCase getUserProfileUseCase = ref.read(
      getUserProfileUseCaseProvider,
    );

    var userResult = await getUserProfileUseCase(null);

    switch (userResult) {
      case Success(value: final user):
        return user;
      case Failed(message: _):
        return null;
    }
  }

  Future<void> saveUserOnBoardingSetup({
    required String firstName,
    required String lastName,
    String? email,
  }) async {
    state = const AsyncLoading();

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

    switch (result) {
      case Success(value: final user):
        state = AsyncData(user);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }
}
