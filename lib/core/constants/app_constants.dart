/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'TradeTrackr';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastSyncTime = 'last_sync_time';

  // Pagination
  static const int defaultPageSize = 20;

  // Date formats
  static const String dateFormatDisplay = 'dd/MM/yyyy';
  static const String dateFormatDisplayWithTime = 'dd/MM/yyyy HH:mm';
  static const String dateFormatCsv = 'dd/MM/yyyy HH:mm:ss';
  static const String dateFormatIso = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  // Number formats
  static const int decimalPrecision = 2;
  static const int pipPrecision = 1;

  // Sync intervals
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration syncTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxDisplayNameLength = 50;
  static const int maxSymbolLength = 20;
  static const double minVolume = 0.01;
  static const double minPrice = 0.0001;

  // CSV
  static const String csvDelimiter = ',';
  static const int maxCsvFileSize = 10 * 1024 * 1024; // 10MB

  // API
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}
