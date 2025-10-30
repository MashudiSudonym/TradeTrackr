import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_params.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/save_preferences_use_case.dart';

@GenerateMocks([PreferencesRepository])
import 'save_preferences_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<void>>(Result.failed('dummy'));

  late MockPreferencesRepository mockPreferencesRepository;
  late SavePreferencesUseCase useCase;

  setUp(() {
    mockPreferencesRepository = MockPreferencesRepository();
    useCase = SavePreferencesUseCase(preferencesRepository: mockPreferencesRepository);
  });

  group('SavePreferencesUseCase', () {
    test('should return success when savePreferences succeeds', () async {
      // Arrange
      final params = SavePreferencesParams(is24HourFormat: true);
      when(mockPreferencesRepository.savePreferences(preferencesEntity: anyNamed('preferencesEntity')))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isSuccess, true);
      verify(mockPreferencesRepository.savePreferences(preferencesEntity: anyNamed('preferencesEntity')))
          .called(1);
    });

    test('should return failed when savePreferences fails', () async {
      // Arrange
      final params = SavePreferencesParams(is24HourFormat: false);
      when(mockPreferencesRepository.savePreferences(preferencesEntity: anyNamed('preferencesEntity')))
          .thenAnswer((_) async => Result.failed('Database error'));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isFailed, true);
      expect(result.errorMessage, 'Database error');
      verify(mockPreferencesRepository.savePreferences(preferencesEntity: anyNamed('preferencesEntity')))
          .called(1);
    });
  });
}