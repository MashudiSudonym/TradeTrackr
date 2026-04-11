import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/recommendation.dart';
import '../mock/mock_data.dart';

/// Provides trading recommendations from mock data.
///
/// TODO: Replace with real recommendation engine when domain layer is built.
final recommendationProvider =
    AsyncNotifierProvider<RecommendationNotifier, List<Recommendation>>(
  RecommendationNotifier.new,
);

class RecommendationNotifier extends AsyncNotifier<List<Recommendation>> {
  @override
  Future<List<Recommendation>> build() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.mockRecommendations;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
