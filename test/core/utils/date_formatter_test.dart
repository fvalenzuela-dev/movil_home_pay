import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/core/utils/date_formatter.dart';

void main() {
  group('formatYmd', () {
    test('formats a date using the yyyy-MM-dd pattern', () {
      expect(formatYmd(DateTime(2024, 4, 15)), equals('2024-04-15'));
    });

    test('zero-pads single-digit months and days', () {
      expect(formatYmd(DateTime(2024, 1, 5)), equals('2024-01-05'));
    });

    test('keeps the date part only, ignoring the time component', () {
      expect(
        formatYmd(DateTime(2026, 12, 31, 23, 59, 59)),
        equals('2026-12-31'),
      );
    });
  });
}
