import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of AuthRepository.
///
/// Uses AuthRemoteDataSource for authentication operations.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await _remoteDataSource.signIn(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Sign in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    try {
      final user = await _remoteDataSource.signUp(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Sign up failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Sign out failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Password reset failed: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges();

  @override
  User? get currentUser => _remoteDataSource.currentUser;
}
