import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Date parsing utility functions.
class DateUtils {
  DateUtils._();

  /// Parse date from CSV format (dd/MM/yyyy HH:mm:ss).
  static DateTime? parseCsvDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormatCsv).parseStrict(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Format date for CSV export.
  static String formatCsvDate(DateTime date) {
    return DateFormat(AppConstants.dateFormatCsv).format(date);
  }

  /// Format date for display.
  static String formatDisplayDate(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplay).format(date);
  }

  /// Format date with time for display.
  static String formatDisplayDateTime(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplayWithTime).format(date);
  }

  /// Format date to ISO string.
  static String toIsoString(DateTime date) {
    return DateFormat(AppConstants.dateFormatIso).format(date);
  }

  /// Parse ISO string to date.
  static DateTime? parseIsoString(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Check if date is today.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get start of day.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
