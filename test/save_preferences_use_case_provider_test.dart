import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_use_case.dart';
import 'package:trade_trackr/presentation/provider/use_case/save_preferences_use_case_provider.dart';

void main() {
  group('SavePreferencesUseCaseProvider', () {
    test('savePreferencesUseCaseProvider should return SavePreferencesUseCase instance', () {
      final container = ProviderContainer();

      final useCase = container.read(savePreferencesUseCaseProvider);

      expect(useCase, isA<SavePreferencesUseCase>());

      container.dispose();
    });
  });
}