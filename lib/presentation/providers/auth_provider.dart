import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as domain;
import 'di_providers.dart';

part 'auth_provider.g.dart';

/// Auth state notifier - manages user authentication state.
///
/// Provides login, logout, and register methods using Supabase auth.
/// keepAlive: true because auth state is global app state that must
/// survive navigation transitions and page disposals.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  domain.User? build() {
    // Initialize with current Supabase auth state
    final authState = ref.watch(supabaseAuthStateProvider);
    return authState;
  }

  /// Login with email and password.
  Future<void> login(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signIn(email, password);

    if (result.isSuccess) {
      state = result.value;
    } else {
      throw Exception(result.error);
    }
  }

  /// Register with display name, email, and password.
  Future<void> register(String displayName, String email, String password) async {
    final repo = ref.read(authRepositoryProvider);

    // Pass display name in user metadata for automatic profile creation
    final result = await repo.signUp(email, password);

    if (result.isSuccess) {
      state = result.value;
    } else {
      throw Exception(result.error);
    }
  }

  /// Logout current user.
  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.signOut();

    if (result.isSuccess) {
      state = null;
    } else {
      throw Exception(result.error);
    }
  }

  /// Reset password with email.
  Future<void> resetPassword(String email) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.resetPassword(email);

    if (result.isFailure) {
      throw Exception(result.error);
    }
    // Email sent successfully - no state change needed
  }
}

/// Watches Supabase auth state changes and converts to domain User.
///
/// This provider bridges Supabase auth events with our domain layer.
@Riverpod(keepAlive: true)
domain.User? supabaseAuthState(Ref ref) {
  final client = Supabase.instance.client;
  final currentUser = client.auth.currentUser;

  if (currentUser == null) return null;

  return domain.User(
    id: currentUser.id,
    email: currentUser.email ?? '',
    displayName: currentUser.userMetadata?['display_name'] as String? ?? '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// Provides the current authenticated user.
///
/// Null when unauthenticated, User object when logged in.
/// keepAlive: true to match authProvider and prevent disposal.
@Riverpod(keepAlive: true)
domain.User? authState(Ref ref) {
  return ref.watch(authProvider);
}
