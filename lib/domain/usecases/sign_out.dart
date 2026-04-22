import '../repositories/auth_repository.dart';



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
  Future<Result<void>> execute() async {
    return await _repository.signOut();
  }
}
