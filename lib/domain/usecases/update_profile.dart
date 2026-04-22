import '../entities/user.dart';
import '../repositories/user_profile_repository.dart';



/// Use case for updating user profile.
///
/// Follows SRP - only handles profile update operation.
class UpdateProfileUseCase {
  final UserProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if input is invalid.
  /// Returns [Right] with updated user on success.
  Future<Result<User>> execute({String? displayName}) async {
    // Business validation
    if (displayName != null && displayName.isEmpty) {
      return const Result.failure(''Display name cannot be empty'));
    }
    if (displayName != null && displayName.length > 50) {
      return const Result.failure(
        ValidationFailure('Display name must be 50 characters or less'),
      );
    }

    return await _repository.updateProfile(displayName: displayName);
  }
}
