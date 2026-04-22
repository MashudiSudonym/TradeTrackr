import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for signing up a new user.
///
/// Follows SRP - only handles sign up operation.
class SignUpUseCase extends UseCase<User, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Result<User>> call(SignUpParams params) async {
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
    if (params.password.length < 6) {
      return const Result.failure('Password must be at least 6 characters');
    }

    return await _repository.signUp(params.email, params.password);
  }

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }
}

/// Parameters for sign up use case.
class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({
    required this.email,
    required this.password,
  });
}
