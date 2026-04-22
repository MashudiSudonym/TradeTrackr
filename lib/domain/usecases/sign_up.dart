import '../entities/user.dart';
import '../repositories/auth_repository.dart';



/// Use case for signing up a new user.
///
/// Follows SRP - only handles sign up operation.
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if input is invalid.
  /// Returns [Right] with signed-up user on success.
  Future<Result<User>> execute(
    String email,
    String password,
  ) async {
    // Business validation
    if (email.isEmpty) {
      return const Result.failure(''Email is required'));
    }
    if (password.isEmpty) {
      return const Result.failure(''Password is required'));
    }
    if (!_isValidEmail(email)) {
      return const Result.failure(''Invalid email format'));
    }
    if (password.length < 6) {
      return const Result.failure(
        ValidationFailure('Password must be at least 6 characters'),
      );
    }

    return await _repository.signUp(email, password);
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}
