import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_index_provider.g.dart';

@riverpod
class OnboardingIndex extends _$OnboardingIndex {
  @override
  int build() => 0;

  void updateIndex(int index) {
    state = index;
  }
}
