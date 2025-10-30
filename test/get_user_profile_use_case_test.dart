import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trade_trackr/core/utils/result.dart';
import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/domain/repository/user_repository.dart';
import 'package:trade_trackr/domain/use_case/user_profile/get_user_profile_use_case.dart';

@GenerateMocks([UserRepository])
import 'get_user_profile_use_case_test.mocks.dart';

void main() {
  provideDummy<Result<UserEntity>>(Result.failed('dummy'));

  late MockUserRepository mockUserRepository;
  late GetUserProfileUseCase useCase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUserProfileUseCase(userRepository: mockUserRepository);
  });

  group('GetUserProfileUseCase', () {
    test('should return success when getUser succeeds', () async {
      // Arrange
      final expectedUser = UserEntity(
        id: 'user-123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => Result.success(expectedUser));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isSuccess, true);
      expect(result.resultValue!.id, 'user-123');
      expect(result.resultValue!.firstName, 'John');
      expect(result.resultValue!.lastName, 'Doe');
      expect(result.resultValue!.email, 'john.doe@example.com');
      expect(result.resultValue!.createdAt, DateTime(2023, 1, 1));
      expect(result.resultValue!.updatedAt, DateTime(2023, 1, 2));
      verify(mockUserRepository.getUser()).called(1);
    });

    test('should return failed when getUser fails', () async {
      // Arrange
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => Result.failed('User not found'));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isFailed, true);
      expect(result.errorMessage, 'User not found');
      verify(mockUserRepository.getUser()).called(1);
    });
  });
}