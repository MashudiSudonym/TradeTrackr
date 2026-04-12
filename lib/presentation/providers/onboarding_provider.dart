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
      if (ref.mounted) {
        state = completed;
      }
    } catch (e) {
      // On error, default to not completed (show onboarding)
      if (ref.mounted) {
        state = false;
      }
    }
  }

  /// Mark onboarding as completed.
  ///
  /// Saves to shared preferences so completion persists across app launches.
  Future<void> markCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOnboardingCompletedKey, true);
      if (ref.mounted) {
        state = true;
      }
    } catch (e) {
      // On save error, still update state for current session
      if (ref.mounted) {
        state = true;
      }
    }
  }

  /// Reset onboarding completion (for testing/debug).
  ///
  /// Clears saved state so onboarding will show again on next launch.
  Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kOnboardingCompletedKey);
      if (ref.mounted) {
        state = false;
      }
    } catch (e) {
      // On error, still update state for current session
      if (ref.mounted) {
        state = false;
      }
    }
  }
}

/// Provides the onboarding completion status.
///
/// Returns true if user has completed onboarding, false otherwise.
/// keepAlive: true to match onboardingProvider and prevent disposal.
@Riverpod(keepAlive: true)
bool hasCompletedOnboarding(Ref ref) {
  return ref.watch(onboardingProvider);
}
