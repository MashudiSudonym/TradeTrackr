import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/user_onboarding_use_case_provider.dart';

void main() {
  group('UserOnboardingUseCaseProvider', () {
    test('userOnboardingUseCaseProvider should return UserOnboardingUseCase instance', () {
      final container = ProviderContainer();

      final useCase = container.read(userOnboardingUseCaseProvider);

      expect(useCase, isA<UserOnboardingUseCase>());

      container.dispose();
    });
  });
}