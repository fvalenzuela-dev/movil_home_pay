import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/cuentas/data/datasources/cuenta_datasource.dart';
import 'package:movil_home_pay/features/cuentas/data/repositories/cuenta_repository_impl.dart';

import '../../../../fixtures/cuenta/cuenta_fixture.dart';

class MockCuentaDatasource extends Mock implements CuentaDatasource {}

void main() {
  late MockCuentaDatasource mockDatasource;
  late CuentaRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockCuentaDatasource();
    repository = CuentaRepositoryImpl(mockDatasource);
  });

  group('CuentaRepositoryImpl', () {
    group('getCuentasPorPeriodo', () {
      test('delegates to datasource with correct periodo', () async {
        final cuentas = [
          CuentaFixture.createValidCuenta(id: 'cta_1'),
          CuentaFixture.createValidCuenta(id: 'cta_2'),
        ];

        when(() => mockDatasource.getCuentasPorPeriodo('202404'))
            .thenAnswer((_) async => cuentas);

        final result = await repository.getCuentasPorPeriodo('202404');

        expect(result.length, equals(2));
        expect(result[0].id, equals('cta_1'));
        verify(() => mockDatasource.getCuentasPorPeriodo('202404')).called(1);
      });

      test('returns empty list when no cuentas', () async {
        when(() => mockDatasource.getCuentasPorPeriodo('202404'))
            .thenAnswer((_) async => []);

        final result = await repository.getCuentasPorPeriodo('202404');

        expect(result, isEmpty);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getCuentasPorPeriodo(any()))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.getCuentasPorPeriodo('202404'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getDetalleCuenta', () {
      test('delegates to datasource with correct accountId and cuentaId', () async {
        final cuenta = CuentaFixture.createValidCuenta(id: 'cta_detail');

        when(() => mockDatasource.getDetalle('acc_123', 'cta_detail'))
            .thenAnswer((_) async => cuenta);

        final result = await repository.getDetalleCuenta('acc_123', 'cta_detail');

        expect(result.id, equals('cta_detail'));
        verify(() => mockDatasource.getDetalle('acc_123', 'cta_detail')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getDetalle(any(), any()))
            .thenThrow(Exception('Not found'));

        expect(
          () => repository.getDetalleCuenta('acc_123', 'cta_invalid'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('registrarPago', () {
      test('delegates to datasource with correct parameters', () async {
        when(() => mockDatasource.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          15000.0,
        )).thenAnswer((_) async => true);

        final result = await repository.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          15000.0,
        );

        expect(result, isTrue);
        verify(() => mockDatasource.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          15000.0,
        )).called(1);
      });

      test('returns false when payment not successful', () async {
        when(() => mockDatasource.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          5000.0,
        )).thenAnswer((_) async => false);

        final result = await repository.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          5000.0,
        );

        expect(result, isFalse);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.registrarPago(any(), any(), any(), any()))
            .thenThrow(Exception('Payment failed'));

        expect(
          () => repository.registrarPago('cta_001', 'acc_123', 15000.0, 15000.0),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('agregarCuentaIndividual', () {
      test('delegates to datasource with correct parameters', () async {
        final cuenta = CuentaFixture.createValidCuenta(
          id: 'cta_new',
          accountId: 'acc_123',
          nombre: 'Netflix',
          monto: 14990.0,
          estado: 'pendiente',
        );

        when(() => mockDatasource.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenAnswer((_) async => cuenta);

        final result = await repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 14990.0,
          nombre: 'Netflix',
        );

        expect(result.id, equals('cta_new'));
        expect(result.estado, equals('pendiente'));
        verify(() => mockDatasource.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_123',
          monto: 14990.0,
          nombre: 'Netflix',
        )).called(1);
      });

      test('works without optional nombre', () async {
        final cuenta = CuentaFixture.createValidCuenta(
          id: 'cta_no_name',
          accountId: 'acc_456',
          nombre: 'acc_456',
        );

        when(() => mockDatasource.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenAnswer((_) async => cuenta);

        final result = await repository.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_456',
          monto: 5000.0,
        );

        expect(result.id, equals('cta_no_name'));
        verify(() => mockDatasource.agregarCuentaIndividual(
          periodo: '202404',
          accountId: 'acc_456',
          monto: 5000.0,
          nombre: null,
        )).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenThrow(Exception('Network error'));

        expect(
          () => repository.agregarCuentaIndividual(
            periodo: '202404',
            accountId: 'acc_123',
            monto: 10000.0,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('forwards DioException on duplicate account', () async {
        when(() => mockDatasource.agregarCuentaIndividual(
          periodo: any(named: 'periodo'),
          accountId: any(named: 'accountId'),
          monto: any(named: 'monto'),
          nombre: any(named: 'nombre'),
        )).thenThrow(Exception('Duplicate'));

        expect(
          () => repository.agregarCuentaIndividual(
            periodo: '202404',
            accountId: 'acc_duplicate',
            monto: 10000.0,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('abrirPeriodo', () {
      test('delegates to datasource and returns opened cuentas', () async {
        final cuentas = [
          CuentaFixture.createValidCuenta(id: 'cta_1'),
          CuentaFixture.createValidCuenta(id: 'cta_2'),
        ];

        when(() => mockDatasource.abrirPeriodo('202404'))
            .thenAnswer((_) async => cuentas);

        final result = await repository.abrirPeriodo('202404');

        expect(result, hasLength(2));
        verify(() => mockDatasource.abrirPeriodo('202404')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.abrirPeriodo(any()))
            .thenThrow(Exception('Server error'));

        expect(
          () => repository.abrirPeriodo('202404'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}