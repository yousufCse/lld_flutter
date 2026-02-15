import 'package:intl/intl.dart';

/// Extension on DateTime for reusable date formatting across the application
extension DateTimeFormatter on DateTime {
  /// Format as 'YYYY-MM-DD' (ISO 8601 date only)
  /// Example: 2000-01-15
  String toDateString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Format as 'dd/MM/yyyy' (User-friendly date)
  /// Example: 15/01/2000
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Format as 'dd MMMM yyyy' (Long format)
  /// Example: 15 January 2000
  String toLongDate() {
    return DateFormat('dd MMMM yyyy').format(this);
  }

  /// Format as 'dd MMM yyyy' (Medium format)
  /// Example: 15 Jan 2000
  String toMediumDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  /// Format with time 'yyyy-MM-dd HH:mm:ss'
  /// Example: 2000-01-15 14:30:00
  String toDateTimeString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  /// Format time only 'HH:mm'
  /// Example: 14:30
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format with time 'dd/MM/yyyy HH:mm'
  /// Example: 15/01/2000 14:30
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Custom format - provide your own pattern
  /// Example: toCustomFormat('EEEE, MMMM d, y') → Friday, January 15, 2000
  String toCustomFormat(String pattern) {
    return DateFormat(pattern).format(this);
  }

  /// Calculate age from date of birth
  /// Useful for healthcare apps
  int getAge() {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Check if date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is in the past
  bool isPast() {
    return isBefore(DateTime.now());
  }

  /// Check if date is in the future
  bool isFuture() {
    return isAfter(DateTime.now());
  }

  /// Get days difference from today
  int daysFromNow() {
    final now = DateTime.now();
    final diff = difference(now);
    return diff.inDays;
  }
}
