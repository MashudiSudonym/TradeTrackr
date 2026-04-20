import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for signing in a user.
///
/// Follows SRP - only handles sign in operation.
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with validation failure if input is invalid.
  /// Returns [Right] with signed-in user on success.
  Future<Either<Failure, User>> execute(String email, String password) async {
    // Business validation
    if (email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }
    if (!_isValidEmail(email)) {
      return const Left(ValidationFailure('Invalid email format'));
    }

    return await _repository.signIn(email, password);
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}
