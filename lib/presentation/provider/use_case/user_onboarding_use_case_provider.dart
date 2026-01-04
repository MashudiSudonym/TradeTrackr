import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';
import 'package:trade_trackr/presentation/provider/repository/user_repository/user_repository_provider.dart';

part 'user_onboarding_use_case_provider.g.dart';

@riverpod
UserOnboardingUseCase userOnboardingUseCase(Ref ref) =>
    UserOnboardingUseCase(userRepository: ref.watch(userRepositoryProvider));
