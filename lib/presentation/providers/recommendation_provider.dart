import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/recommendation.dart';
import '../mock/mock_data.dart';

part 'recommendation_provider.g.dart';

/// Provides trading recommendations from mock data.
///
/// TODO: Replace with real recommendation engine when domain layer is built.
@riverpod
class Recommendations extends _$Recommendations {
  @override
  Future<List<Recommendation>> build() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return MockData.mockRecommendations;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
