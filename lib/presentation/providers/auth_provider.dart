import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../mock/mock_data.dart';

part 'auth_provider.g.dart';

/// Auth state notifier - manages user authentication state.
///
/// Provides login, logout, and register methods with mock auth.
/// TODO: Replace with real Supabase auth when backend is integrated.
@riverpod
class Auth extends _$Auth {
  @override
  User? build() {
    // Start unauthenticated - user must login first
    return null;
  }

  /// Login with email and password.
  ///
  /// Mock implementation - always succeeds with mock user.
  /// In production, this would call Supabase auth.
  Future<void> login(String email, String password) async {
    // Simulate network delay for UX
    await Future.delayed(const Duration(milliseconds: 500));

    // Set authenticated user
    state = MockData.mockUser;
  }

  /// Register with display name, email, and password.
  ///
  /// Mock implementation - always succeeds with mock user.
  /// In production, this would call Supabase auth.
  Future<void> register(String displayName, String email, String password) async {
    // Simulate network delay for UX
    await Future.delayed(const Duration(milliseconds: 500));

    // Set authenticated user
    state = MockData.mockUser;
  }

  /// Logout current user.
  ///
  /// Clears auth state and redirects to login.
  void logout() {
    state = null;
  }

  /// Reset password with email.
  ///
  /// Mock implementation - always succeeds.
  /// In production, this would call Supabase auth password reset.
  Future<void> resetPassword(String email) async {
    // Simulate network delay for UX
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock success - in production would send email via Supabase
    // No state change needed for password reset
  }
}

/// Provides the current authenticated user.
///
/// Null when unauthenticated, User object when logged in.
@riverpod
User? authState(Ref ref) {
  return ref.watch(authProvider);
}
