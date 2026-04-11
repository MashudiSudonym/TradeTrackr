import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../errors/failures.dart';

/// Pre-configured Logger instance for the entire application.
///
/// Uses [PrettyPrinter] in debug mode and is automatically silent
/// in release/profile builds via the default [DevelopmentFilter].
final appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

/// Minimum log level — set to [Level.debug] for full development verbosity.
/// In release builds, [DevelopmentFilter] suppresses all output regardless.
void setLogLevel(Level level) => Logger.level = level;

/// Riverpod provider for injecting [Logger] into presentation-layer providers.
final appLoggerProvider = Provider<Logger>((ref) => appLogger);

/// Extension on [Logger] that maps [Failure] subtypes to appropriate log levels.
///
/// Usage:
/// ```dart
/// catch (e, stackTrace) {
///   final failure = DatabaseFailure(e.toString());
///   appLogger.logFailure('addClosedPosition', failure,
///       error: e, stackTrace: stackTrace);
///   return Left(failure);
/// }
/// ```
extension LoggerFailureExtension on Logger {
  void logFailure(
    String context,
    Failure failure, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final message = '[$context] ${failure.runtimeType}: ${failure.message}';

    switch (failure) {
      case DatabaseFailure():
      case AuthFailure():
        e(message, error: error, stackTrace: stackTrace);
      case NetworkFailure():
      case SyncFailure():
      case ValidationFailure():
      case CsvParseFailure():
        w(message, error: error, stackTrace: stackTrace);
    }
  }
}
