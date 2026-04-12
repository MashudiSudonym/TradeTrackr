import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_provider.g.dart';

/// Key for storing onboarding completion in shared preferences.
const _kOnboardingCompletedKey = 'onboarding_completed';

/// Onboarding state notifier - manages onboarding completion status.
///
/// Uses shared_preferences to persist completion state across app launches.
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  bool build() {
    // Check shared preferences for completion status
    _loadCompletionStatus();
    return false;
  }

  /// Load completion status from shared preferences.
  Future<void> _loadCompletionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool(_kOnboardingCompletedKey) ?? false;
      state = completed;
    } catch (e) {
      // On error, default to not completed (show onboarding)
      state = false;
    }
  }

  /// Mark onboarding as completed.
  ///
  /// Saves to shared preferences so completion persists across app launches.
  Future<void> markCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboardingCompletedKey, true);
      state = true;
    } catch (e) {
      // On save error, still update state for current session
      state = true;
    }
  }

  /// Reset onboarding completion (for testing/debug).
  ///
  /// Clears saved state so onboarding will show again on next launch.
  Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kOnboardingCompletedKey);
      state = false;
    } catch (e) {
      // On error, still update state for current session
      state = false;
    }
  }
}

/// Provides the onboarding completion status.
///
/// Returns true if user has completed onboarding, false otherwise.
@riverpod
bool hasCompletedOnboarding(Ref ref) {
  return ref.watch(onboardingProvider);
}
