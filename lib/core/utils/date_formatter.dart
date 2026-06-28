// Date formatting helpers shared across the app.

/// Formats [date] using the standard `yyyy-MM-dd` pattern,
/// zero-padding month and day. The time component is ignored.
String formatYmd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
