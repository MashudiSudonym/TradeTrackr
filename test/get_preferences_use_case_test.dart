import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/preferences_entity.dart';
import 'package:trade_trackr/domain/repository/preferences_repository.dart';
import 'package:trade_trackr/domain/use_case/app_preferences/get_preferences_use_case.dart';

@GenerateMocks([PreferencesRepository])
import 'get_preferences_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<PreferencesEntity>>(Result.failed('dummy'));

  late MockPreferencesRepository mockPreferencesRepository;
  late GetPreferencesUseCase useCase;

  setUp(() {
    mockPreferencesRepository = MockPreferencesRepository();
    useCase = GetPreferencesUseCase(preferencesRepository: mockPreferencesRepository);
  });

  group('GetPreferencesUseCase', () {
    test('should return success when getPreferences succeeds', () async {
      // Arrange
      final expectedPreferences = PreferencesEntity(is24HourFormat: true);
      when(mockPreferencesRepository.getPreferences())
          .thenAnswer((_) async => Result.success(expectedPreferences));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isSuccess, true);
      expect(result.resultValue!.is24HourFormat, true);
      verify(mockPreferencesRepository.getPreferences()).called(1);
    });

    test('should return failed when getPreferences fails', () async {
      // Arrange
      when(mockPreferencesRepository.getPreferences())
          .thenAnswer((_) async => Result.failed('Database error'));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isFailed, true);
      expect(result.errorMessage, 'Database error');
      verify(mockPreferencesRepository.getPreferences()).called(1);
    });
  });
}