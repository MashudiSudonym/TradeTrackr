import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_trackr/result.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';

@GenerateMocks([UserRepository])
import 'user_onboarding_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<void>>(Result.failed('dummy'));

  late MockUserRepository mockUserRepository;
  late UserOnboardingUseCase useCase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = UserOnboardingUseCase(userRepository: mockUserRepository);
  });

  group('UserOnboardingUseCase', () {
    test('should return success when saveUser succeeds', () async {
      // Arrange
      final params = UserOnboardingParams(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
      );
      when(
        mockUserRepository.saveUser(userEntity: anyNamed('userEntity')),
      ).thenAnswer((_) async => Result.success(null));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isSuccess, true);
      verify(
        mockUserRepository.saveUser(userEntity: anyNamed('userEntity')),
      ).called(1);
    });

    test('should return failed when saveUser fails', () async {
      // Arrange
      final params = UserOnboardingParams(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
      );
      when(
        mockUserRepository.saveUser(userEntity: anyNamed('userEntity')),
      ).thenAnswer((_) async => Result.failed('Database error'));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isFailed, true);
      expect(result.errorMessage, 'Database error');
      verify(
        mockUserRepository.saveUser(userEntity: anyNamed('userEntity')),
      ).called(1);
    });
  });
}
