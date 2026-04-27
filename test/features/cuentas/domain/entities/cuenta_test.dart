import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';

void main() {
  group('Cuenta', () {
    test('isPaid returns true when estado is pagada', () {
      final cuenta = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 15000,
        estado: 'pagada',
        periodo: '202604',
      );

      expect(cuenta.isPaid, isTrue);
    });

    test('isPaid returns false when estado is pendiente', () {
      final cuenta = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 0,
        estado: 'pendiente',
        periodo: '202604',
      );

      expect(cuenta.isPaid, isFalse);
    });

    test('saldo calculates correct difference between monto and montoPagado', () {
      final cuenta = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 5000,
        estado: 'pendiente',
        periodo: '202604',
      );

      expect(cuenta.saldo, equals(10000));
    });

    test('props contains all fields for equality comparison', () {
      final cuenta1 = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 0,
        estado: 'pendiente',
        periodo: '202604',
      );

      final cuenta2 = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 0,
        estado: 'pendiente',
        periodo: '202604',
      );

      expect(cuenta1, equals(cuenta2));
    });

    test('different cuentas are not equal', () {
      final cuenta1 = Cuenta(
        id: '1',
        accountId: 'acc-1',
        nombre: 'Netflix',
        monto: 15000,
        montoPagado: 0,
        estado: 'pendiente',
        periodo: '202604',
      );

      final cuenta2 = Cuenta(
        id: '2',
        accountId: 'acc-1',
        nombre: 'Spotify',
        monto: 10000,
        montoPagado: 0,
        estado: 'pendiente',
        periodo: '202604',
      );

      expect(cuenta1, isNot(equals(cuenta2)));
    });
  });
}
