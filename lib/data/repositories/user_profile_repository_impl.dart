import '../../domain/entities/user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/user_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of UserProfileRepository.
///
/// Uses UserRemoteDataSource for profile operations.
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      // TODO: Get user ID from auth state
      final userId = 'current-user-id';
      final user = await _remoteDataSource.getProfile(userId);
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get profile: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({String? displayName}) async {
    try {
      // TODO: Get user ID from auth state
      final userId = 'current-user-id';
      final user = await _remoteDataSource.updateProfile(
        userId: userId,
        displayName: displayName,
      );
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // TODO: Get user ID from auth state
      final userId = 'current-user-id';
      await _remoteDataSource.changePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to change password: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      // TODO: Get user ID from auth state
      final userId = 'current-user-id';
      await _remoteDataSource.deleteAccount(userId);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to delete account: $e'));
    }
  }
}
