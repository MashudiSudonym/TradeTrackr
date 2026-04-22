import '../entities/user.dart';
import '../repositories/user_profile_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for updating user profile.
///
/// Follows SRP - only handles profile update operation.
class UpdateProfileUseCase extends UseCase<User, UpdateProfileParams> {
  final UserProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Result<User>> call(UpdateProfileParams params) async {
    // Business validation
    if (params.displayName != null && params.displayName!.isEmpty) {
      return const Result.failure('Display name cannot be empty');
    }
    if (params.displayName != null && params.displayName!.length > 50) {
      return const Result.failure('Display name must be 50 characters or less');
    }

    return await _repository.updateProfile(displayName: params.displayName);
  }
}

/// Parameters for update profile use case.
class UpdateProfileParams {
  final String? displayName;

  const UpdateProfileParams({this.displayName});
}
