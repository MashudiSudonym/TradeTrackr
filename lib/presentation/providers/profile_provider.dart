import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../mock/mock_data.dart';

/// Provides the current user profile from mock data.
///
/// TODO: Replace with real user profile repository.
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, User>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.mockUser;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
