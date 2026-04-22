import '../repositories/auth_repository.dart';
import '../core/result.dart';
import '../core/usecase.dart';

/// Use case for signing out the current user.
///
/// Follows SRP - only handles sign out operation.
class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await _repository.signOut();
  }
}
