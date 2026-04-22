import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as domain;
import '../../core/errors/failures.dart';
import 'user_remote_data_source.dart';

/// Concrete implementation of user remote data source using Supabase.
///
/// Handles user profile CRUD operations with Supabase.
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient _client;

  UserRemoteDataSourceImpl(this._client);

  @override
  Future<domain.User> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return domain.User(
        id: response['id'] as String,
        email: response['email'] as String? ?? '',
        displayName: response['display_name'] as String? ?? '',
        createdAt: DateTime.parse(response['created_at'] as String),
        updatedAt: DateTime.parse(response['updated_at'] as String),
      );
    } catch (e) {
      throw DatabaseFailure('Failed to get profile: $e');
    }
  }

  @override
  Future<domain.User> updateProfile({
    required String userId,
    String? displayName,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) {
        updates['display_name'] = displayName;
      }

      final response = await _client
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return domain.User(
        id: response['id'] as String,
        email: response['email'] as String? ?? '',
        displayName: response['display_name'] as String? ?? '',
        createdAt: DateTime.parse(response['created_at'] as String),
        updatedAt: DateTime.parse(response['updated_at'] as String),
      );
    } catch (e) {
      throw DatabaseFailure('Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Update password via Supabase Auth
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw AuthFailure('Failed to change password: ${e.message}');
    } catch (e) {
      throw AuthFailure('Failed to change password: $e');
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      // First delete user's data from profiles table
      await _client.from('profiles').delete().eq('id', userId);

      // Then delete the auth user (this will be done via client)
      // Note: The actual auth user deletion is handled separately
    } catch (e) {
      throw DatabaseFailure('Failed to delete account: $e');
    }
  }
}
