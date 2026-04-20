import '../entities/user.dart';
import '../../core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

/// Authentication operations.
///
/// Part of the Repository Segregation Pattern (ISP).
/// This interface only contains authentication operations.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<Either<Failure, User>> signIn(String email, String password);

  /// Sign up with email and password.
  Future<Either<Failure, User>> signUp(String email, String password);

  /// Sign out the current user.
  Future<Either<Failure, void>> signOut();

  /// Send password reset email.
  Future<Either<Failure, void>> resetPassword(String email);

  /// Stream of auth state changes.
  ///
  /// Emits the current user when signed in, or null when signed out.
  Stream<User?> get authStateChanges;

  /// Get the currently authenticated user.
  ///
  /// Returns null if no user is signed in.
  User? get currentUser;
}
