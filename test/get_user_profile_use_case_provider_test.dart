import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/use_case/user_profile/get_user_profile_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/get_user_profile_use_case_provider.dart';

void main() {
  group('GetUserProfileUseCaseProvider', () {
    test('getUserProfileUseCaseProvider should return GetUserProfileUseCase instance', () {
      final container = ProviderContainer();

      final useCase = container.read(getUserProfileUseCaseProvider);

      expect(useCase, isA<GetUserProfileUseCase>());

      container.dispose();
    });
  });
}