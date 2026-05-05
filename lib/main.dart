import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'app/app.dart';
import 'core/constants/supabase_constants.dart';
import 'core/logger/app_logger.dart';
import 'core/sync/sync_callback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupGlobalErrorHandling();

  // Load environment variables from .env file
  await SupabaseConstants.load();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.projectUrl,
    anonKey: SupabaseConstants.anonKey,
    debug: kDebugMode,
  );

  // Initialize workmanager for background sync tasks
  await Workmanager().initialize(callbackDispatcher);

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
