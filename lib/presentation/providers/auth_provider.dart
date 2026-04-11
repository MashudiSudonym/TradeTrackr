import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../mock/mock_data.dart';

/// Provides authentication state.
///
/// Currently always returns authenticated with mock user.
/// TODO: Replace with real Supabase auth when backend is integrated.
final authStateProvider = StreamProvider<User?>((ref) {
  // Always authenticated during presentation-first development
  return Stream.value(MockData.mockUser);
});
