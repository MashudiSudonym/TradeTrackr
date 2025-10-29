import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_params.dart';
import 'package:trade_trackr/domain/use_case/user_onboarding/user_onboarding_use_case.dart';

@GenerateMocks([UserRepository])
import 'user_onboarding_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<UserEntity>>(Result.failed('dummy'));

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
      final expectedUser = UserEntity(
        id: 'generated-id',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );
      when(mockUserRepository.saveUser(userEntity: anyNamed('userEntity')))
          .thenAnswer((_) async => Result.success(expectedUser));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isSuccess, true);
      expect(result.resultValue!.firstName, 'John');
      expect(result.resultValue!.lastName, 'Doe');
      expect(result.resultValue!.email, 'john.doe@example.com');
      expect(result.resultValue!.id, isNotEmpty);
      expect(result.resultValue!.createdAt, isNotNull);
      expect(result.resultValue!.updatedAt, isNotNull);
      verify(mockUserRepository.saveUser(userEntity: anyNamed('userEntity')))
          .called(1);
    });

    test('should return failed when saveUser fails', () async {
      // Arrange
      final params = UserOnboardingParams(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
      );
      when(mockUserRepository.saveUser(userEntity: anyNamed('userEntity')))
          .thenAnswer((_) async => Result.failed('Database error'));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isFailed, true);
      expect(result.errorMessage, 'Database error');
      verify(mockUserRepository.saveUser(userEntity: anyNamed('userEntity')))
          .called(1);
    });
  });
}