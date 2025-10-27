import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Constants {
  // App Flavors
  static const String? appFlavor =
      String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
      ? String.fromEnvironment('FLUTTER_APP_FLAVOR')
      : null;
  static const dev = 'dev';
  static const prod = 'prod';

  // logger
  static final logger = Logger(level: _getLogLevel());

  static Level _getLogLevel() {
    // in test environment, only show warnings and errors
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return Level.warning;
    }

    // in debug mode, show all logs
    if (kDebugMode) {
      return Level.debug;
    }

    // in release mode, only show warnings and errors
    return Level.warning;
  }
}
