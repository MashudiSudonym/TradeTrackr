/// String validation utility functions.
class StringUtils {
  StringUtils._();

  /// Check if string is null or empty.
  static bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  /// Check if string is NOT null or empty.
  static bool isNotEmpty(String? value) => value != null && value.isNotEmpty;

  /// Trim and check if string is empty.
  static bool isBlank(String? value) => value?.trim().isEmpty ?? true;

  /// Capitalize first letter of string.
  static String capitalize(String value) {
    if (isBlank(value)) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// Truncate string to max length with ellipsis.
  static String truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...';
  }

  /// Format number with thousand separators.
  static String formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  /// Format percentage.
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }
}
