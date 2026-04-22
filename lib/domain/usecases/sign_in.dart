import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for signing in a user.
///
/// Follows SRP - only handles sign in operation.
class SignInUseCase extends UseCase<User, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Result<User>> call(SignInParams params) async {
    // Business validation
    if (params.email.isEmpty) {
      return const Result.failure('Email is required');
    }
    if (params.password.isEmpty) {
      return const Result.failure('Password is required');
    }
    if (!_isValidEmail(params.email)) {
      return const Result.failure('Invalid email format');
    }

    return await _repository.signIn(params.email, params.password);
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}

/// Parameters for sign in use case.
class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });
}
