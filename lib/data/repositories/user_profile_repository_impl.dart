import '../../domain/entities/user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/user_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of UserProfileRepository.
///
/// Uses UserRemoteDataSource for profile operations.
/// NOTE: userId is obtained from auth state - providers must inject it.
class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserRemoteDataSource _remoteDataSource;

  /// Current authenticated user ID.
  /// Set by the provider layer after authentication.
  String? _currentUserId;

  UserProfileRepositoryImpl(this._remoteDataSource);

  /// Set the current user ID (called by auth provider).
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      if (_currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }
      final user = await _remoteDataSource.getProfile(_currentUserId!);
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get profile: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({String? displayName}) async {
    try {
      if (_currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }
      final user = await _remoteDataSource.updateProfile(
        userId: _currentUserId!,
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
      if (_currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }
      await _remoteDataSource.changePassword(
        userId: _currentUserId!,
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
      if (_currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }
      await _remoteDataSource.deleteAccount(_currentUserId!);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to delete account: $e'));
    }
  }
}
