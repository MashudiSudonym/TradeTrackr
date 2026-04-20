import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Manages the app theme mode (light/dark/system).
///
/// Persisted choice stored locally (TODO: add shared_preferences persistence).
@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  ThemeMode build() => ThemeMode.system;

  void setTheme(ThemeMode mode) => state = mode;

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setLight() => state = ThemeMode.light;

  void setDark() => state = ThemeMode.dark;

  void setSystem() => state = ThemeMode.system;
}
