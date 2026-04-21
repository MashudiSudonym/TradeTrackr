import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/onboarding_provider.dart';

/// A [ChangeNotifier] that notifies GoRouter when auth state changes.
///
/// This class bridges Riverpod's auth state with GoRouter's redirect system.
/// When auth state changes (login/logout), it notifies GoRouter to re-evaluate
/// the redirect logic.
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(this._ref) {
    // Listen to auth state changes
    _ref.listen(
      authStateProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  final Ref _ref;
}

/// A [ChangeNotifier] that notifies GoRouter when onboarding state changes.
class OnboardingRefreshNotifier extends ChangeNotifier {
  OnboardingRefreshNotifier(this._ref) {
    // Listen to onboarding state changes
    _ref.listen(
      hasCompletedOnboardingProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  final Ref _ref;
}
