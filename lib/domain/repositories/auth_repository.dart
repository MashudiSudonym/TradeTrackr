import '../entities/user.dart';
import '../core/result.dart';

/// Authentication operations.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains authentication operations.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<Result<User>> signIn(String email, String password);

  /// Sign up with email, password, and display name.
  Future<Result<User>> signUp(String email, String password, {String? displayName});

  /// Sign out the current user.
  Future<Result<void>> signOut();

  /// Send password reset email.
  Future<Result<void>> resetPassword(String email);

  /// Stream of auth state changes.
  ///
  /// Emits the current user when signed in, or null when signed out.
  Stream<User?> get authStateChanges;

  /// Get the currently authenticated user.
  ///
  /// Returns null if no user is signed in.
  User? get currentUser;
}
