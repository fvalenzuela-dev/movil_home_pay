import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';
import 'package:movil_home_pay/features/cuentas/domain/repositories/cuenta_repository.dart';

class MockCuentaRepository extends Mock implements CuentaRepository {}

void main() {
  group('CuentaRepository interface', () {
    group('agregarCuentaIndividual', () {
      test('should be declared as abstract method returning Future<Cuenta>', () {
        // The interface contract: agregarCuentaIndividual must exist
        // and return Future<Cuenta> with the specified parameters
        final repository = MockCuentaRepository();

        // Verify the method exists on the interface by stubbing it
        when(() => repository.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenAnswer((_) async => Cuenta(
          id: 'cta_new',
          accountId: 'acc_123',
          nombre: 'Test Account',
          monto: 15000.0,
          montoPagado: 0.0,
          estado: 'pendiente',
          periodo: '202404',
        ));

        // Act
        final result = repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 15000.0,
          nombre: 'Test Account',
        );

        // Assert
        expect(result, isA<Future<Cuenta>>());
        verify(() => repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 15000.0,
          nombre: 'Test Account',
        )).called(1);
      });

      test('accepts optional nombre parameter', () async {
        final repository = MockCuentaRepository();

        when(() => repository.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenAnswer((_) async => Cuenta(
          id: 'cta_new',
          accountId: 'acc_123',
          nombre: 'Custom Name',
          monto: 15000.0,
          montoPagado: 0.0,
          estado: 'pendiente',
          periodo: '202404',
        ));

        // Act - call without nombre
        final result = repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 15000.0,
        );

        // Assert
        expect(await result, isA<Cuenta>());
      });

      test('returns Cuenta with pendiente status when account created', () async {
        final repository = MockCuentaRepository();
        final createdCuenta = Cuenta(
          id: 'cta_new',
          accountId: 'acc_123',
          nombre: 'Test Account',
          monto: 15000.0,
          montoPagado: 0.0,
          estado: 'pendiente',
          periodo: '202404',
        );

        when(() => repository.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenAnswer((_) async => createdCuenta);

        final result = await repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 15000.0,
        );

        expect(result.estado, equals('pendiente'));
        expect(result.id, isNotEmpty);
      });
    });
  });
}