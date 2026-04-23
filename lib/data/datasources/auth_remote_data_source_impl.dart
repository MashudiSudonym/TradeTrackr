import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as domain;
import '../../core/errors/failures.dart';
import 'auth_remote_data_source.dart';

/// Concrete implementation of auth data source using Supabase Auth.
///
/// Wraps Supabase Auth GoTrueClient and converts to domain entities.
/// Throws AuthFailure for auth-specific errors.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;
  GoTrueClient get _auth => _client.auth;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<domain.User> signIn(String email, String password) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthFailure('Sign in failed: No user returned');
      }

      final user = response.user!;
      return domain.User(
        id: user.id,
        email: user.email ?? email,
        displayName: user.userMetadata?['display_name'] as String? ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<domain.User> signUp(String email, String password, {String? displayName}) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      if (response.user == null) {
        throw const AuthFailure('Sign up failed: No user returned');
      }

      final user = response.user!;
      return domain.User(
        id: user.id,
        email: user.email ?? email,
        displayName: displayName ?? user.userMetadata?['display_name'] as String? ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Stream<domain.User?> authStateChanges() {
    return _auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;

      return domain.User(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String? ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  @override
  domain.User? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;

    return domain.User(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String? ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
