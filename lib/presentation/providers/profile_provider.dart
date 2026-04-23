import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import 'di_providers.dart';
import 'auth_provider.dart';

part 'profile_provider.g.dart';

/// Provides the current user profile from Supabase.
///
/// This provider connects to the UserProfileRepository to fetch
/// real user data instead of mock data.
@riverpod
class Profile extends _$Profile {
  @override
  Future<User> build() async {
    // Get current user ID from auth state
    final userId = ref.watch(supabaseAuthStateProvider)?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final repo = ref.read(userProfileRepositoryProvider);

    // Set current user ID in repository (required by impl)
    (repo as dynamic).setCurrentUserId(userId);

    final result = await repo.getProfile();

    return result.getOrThrow();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Update user profile display name.
  Future<void> updateDisplayName(String displayName) async {
    final userId = ref.read(supabaseAuthStateProvider)?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final repo = ref.read(userProfileRepositoryProvider);
    (repo as dynamic).setCurrentUserId(userId);

    final result = await repo.updateProfile(displayName: displayName);

    if (result.isSuccess) {
      // Invalidate to trigger refresh
      ref.invalidateSelf();
    } else {
      throw Exception(result.error);
    }
  }
}
