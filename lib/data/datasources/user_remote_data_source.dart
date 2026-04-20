import '../../domain/entities/user.dart';

/// Remote data source for user profile in Supabase.
///
/// Abstracts user profile operations.
abstract class UserRemoteDataSource {
  /// Get user profile by ID.
  Future<User> getProfile(String userId);

  /// Update user profile.
  Future<User> updateProfile({
    required String userId,
    String? displayName,
  });

  /// Change user password.
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account.
  Future<void> deleteAccount(String userId);
}
