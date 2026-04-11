import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/logger/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _setupGlobalErrorHandling();
  // TODO: Initialize Supabase when backend is integrated
  runApp(
    const ProviderScope(
      child: TradeTrackrApp(),
    ),
  );
}

/// Routes unhandled framework and async errors to [appLogger]
/// so technical details stay in the developer console, not the UI.
void _setupGlobalErrorHandling() {
  // Chain with any existing handler for forward compatibility.
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    appLogger.e(
      'Flutter framework error',
      error: details.exceptionAsString(),
      stackTrace: details.stack,
    );
    previousOnError?.call(details);
  };

  // Catch async errors that escape the Flutter zone.
  PlatformDispatcher.instance.onError = (error, stack) {
    appLogger.e('Unhandled async error', error: error, stackTrace: stack);
    return true;
  };
}
