import '../entities/user.dart';
import '../core/result.dart';

/// User profile management operations.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains profile management operations.
abstract class UserProfileRepository {
  /// Get the current user's profile.
  Future<Result<User>> getProfile();

  /// Update the user's profile.
  ///
  /// [displayName] is optional - only provided fields will be updated.
  Future<Result<User>> updateProfile({String? displayName});

  /// Change the user's password.
  ///
  /// Requires [currentPassword] for verification.
  Future<Result<void>> changePassword(
    String currentPassword,
    String newPassword,
  );

  /// Delete the user's account and all associated data.
  ///
  /// This is a destructive operation that cannot be undone.
  Future<Result<void>> deleteAccount();
}
