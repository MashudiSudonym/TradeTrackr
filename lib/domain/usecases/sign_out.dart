import '../repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for signing out the current user.
///
/// Follows SRP - only handles sign out operation.
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  /// Execute the use case.
  ///
  /// Returns [Left] with failure if sign out fails.
  /// Returns [Right] with void on success.
  Future<Either<Failure, void>> execute() async {
    return await _repository.signOut();
  }
}
