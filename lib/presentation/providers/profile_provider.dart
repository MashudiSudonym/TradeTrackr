import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../mock/mock_data.dart';

part 'profile_provider.g.dart';

/// Provides the current user profile from mock data.
///
/// TODO: Replace with real user profile repository.
@riverpod
class Profile extends _$Profile {
  @override
  Future<User> build() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.mockUser;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
