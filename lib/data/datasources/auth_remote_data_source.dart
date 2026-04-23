import '../../domain/entities/user.dart';

/// Remote data source for Supabase Auth.
///
/// Abstracts authentication operations.
abstract class AuthRemoteDataSource {
  /// Sign in with email and password.
  Future<User> signIn(String email, String password);

  /// Sign up with email, password, and display name.
  Future<User> signUp(String email, String password, {String? displayName});

  /// Sign out the current user.
  Future<void> signOut();

  /// Send password reset email.
  Future<void> resetPassword(String email);

  /// Stream of auth state changes.
  Stream<User?> authStateChanges();

  /// Get the current authenticated user.
  User? get currentUser;
}
