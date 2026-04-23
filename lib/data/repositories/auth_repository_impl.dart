import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/core/result.dart';

/// Implementation of AuthRepository.
///
/// Uses AuthRemoteDataSource for authentication operations.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<User>> signIn(String email, String password) async {
    try {
      final user = await _remoteDataSource.signIn(email, password);
      return Result.success(user);
    } catch (e) {
      return Result.failure('Sign in failed: $e');
    }
  }

  @override
  Future<Result<User>> signUp(String email, String password, {String? displayName}) async {
    try {
      final user = await _remoteDataSource.signUp(email, password, displayName: displayName);
      return Result.success(user);
    } catch (e) {
      return Result.failure('Sign up failed: $e');
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Sign out failed: $e');
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Password reset failed: $e');
    }
  }

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges();

  @override
  User? get currentUser => _remoteDataSource.currentUser;
}
