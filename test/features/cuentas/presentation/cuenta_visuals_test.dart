import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/core/theme/app_theme.dart';
import 'package:movil_home_pay/features/cuentas/presentation/cuenta_visuals.dart';

void main() {
  group('cuentaColorFor', () {
    test('returns the brand red for streaming/netflix', () {
      expect(cuentaColorFor('Netflix'), equals(const Color(0xFFEF4444)));
      expect(cuentaColorFor('streaming premium'), equals(const Color(0xFFEF4444)));
    });

    test('returns orange for electricidad/luz', () {
      expect(cuentaColorFor('Luz'), equals(const Color(0xFFF59E0B)));
    });

    test('returns indigo for internet/wifi', () {
      expect(cuentaColorFor('Internet hogar'), equals(const Color(0xFF6366F1)));
    });

    test('returns purple for telefono/movil', () {
      expect(cuentaColorFor('Telefono'), equals(const Color(0xFF8B5CF6)));
    });

    test('falls back to the primary seed for unknown names', () {
      expect(cuentaColorFor('Algo raro'), equals(AppTheme.primarySeed));
    });

    test('is case-insensitive', () {
      expect(cuentaColorFor('NETFLIX'), equals(cuentaColorFor('netflix')));
    });
  });

  group('cuentaIconFor', () {
    test('returns the subscriptions icon for streaming/netflix', () {
      expect(cuentaIconFor('Netflix'), equals(Icons.subscriptions));
    });

    test('returns bolt for electricidad/luz', () {
      expect(cuentaIconFor('Luz'), equals(Icons.bolt));
    });

    test('falls back to receipt_long for unknown names', () {
      expect(cuentaIconFor('Algo raro'), equals(Icons.receipt_long));
    });
  });
}
