import '../../domain/entities/user.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../../domain/core/result.dart';

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
  Future<Result<User>> getProfile() async {
    try {
      if (_currentUserId == null) {
        return const Result.failure('User not authenticated');
      }
      final user = await _remoteDataSource.getProfile(_currentUserId!);
      return Result.success(user);
    } catch (e) {
      return Result.failure('Failed to get profile: $e');
    }
  }

  @override
  Future<Result<User>> updateProfile({String? displayName}) async {
    try {
      if (_currentUserId == null) {
        return const Result.failure('User not authenticated');
      }
      final user = await _remoteDataSource.updateProfile(
        userId: _currentUserId!,
        displayName: displayName,
      );
      return Result.success(user);
    } catch (e) {
      return Result.failure('Failed to update profile: $e');
    }
  }

  @override
  Future<Result<void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_currentUserId == null) {
        return const Result.failure('User not authenticated');
      }
      await _remoteDataSource.changePassword(
        userId: _currentUserId!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to change password: $e');
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      if (_currentUserId == null) {
        return const Result.failure('User not authenticated');
      }
      await _remoteDataSource.deleteAccount(_currentUserId!);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to delete account: $e');
    }
  }
}
