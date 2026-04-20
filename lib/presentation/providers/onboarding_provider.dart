import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_provider.g.dart';

/// Key for storing onboarding completion in shared preferences.
const _kOnboardingCompletedKey = 'onboarding_completed';

/// Onboarding state notifier - manages onboarding completion status.
///
/// Uses shared_preferences to persist completion state across app launches.
/// keepAlive: true because onboarding state is global app state that
/// persists across app launches and must survive navigation transitions.
@Riverpod(keepAlive: true)
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Future<bool> build() async {
    // Check shared preferences for completion status
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kOnboardingCompletedKey) ?? false;
    } catch (e) {
      // On error, default to not completed (show onboarding)
      return false;
    }
  }

  /// Mark onboarding as completed.
  ///
  /// Saves to shared preferences so completion persists across app launches.
  Future<void> markCompleted() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboardingCompletedKey, true);
      return true;
    });
  }

  /// Reset onboarding completion (for testing/debug).
  ///
  /// Clears saved state so onboarding will show again on next launch.
  Future<void> reset() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kOnboardingCompletedKey);
      return false;
    });
  }
}

/// Provides the onboarding completion status.
///
/// Returns true if user has completed onboarding, false otherwise.
/// keepAlive: true to match onboardingProvider and prevent disposal.
@Riverpod(keepAlive: true)
bool hasCompletedOnboarding(Ref ref) {
  final asyncValue = ref.watch(onboardingProvider);
  return asyncValue.value ?? false;
}
