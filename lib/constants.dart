import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Constants {
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
