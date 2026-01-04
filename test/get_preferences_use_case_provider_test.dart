import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/get_preferences_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/get_preferences_use_case_provider.dart';

void main() {
  group('GetPreferencesUseCaseProvider', () {
    test('getPreferencesUseCaseProvider should return GetPreferencesUseCase instance', () {
      final container = ProviderContainer();

      final useCase = container.read(getPreferencesUseCaseProvider);

      expect(useCase, isA<GetPreferencesUseCase>());

      container.dispose();
    });
  });
}