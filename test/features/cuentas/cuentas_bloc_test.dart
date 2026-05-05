import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';
import 'package:movil_home_pay/features/cuentas/domain/repositories/cuenta_repository.dart';
import 'package:movil_home_pay/features/cuentas/presentation/bloc/cuentas_bloc.dart';

class MockCuentaRepository extends Mock implements CuentaRepository {}

void main() {
  late MockCuentaRepository mockRepository;

  setUp(() {
    mockRepository = MockCuentaRepository();
  });

  final testCuenta = Cuenta(
    id: '1',
    accountId: 'acc-1',
    nombre: 'Netflix',
    monto: 15000,
    montoPagado: 0,
    estado: 'pendiente',
    periodo: '202604',
  );

  group('CuentasBloc', () {
    test('initial state is CuentasInitial', () {
      final bloc = CuentasBloc(mockRepository);
      expect(bloc.state, isA<CuentasInitial>());
      bloc.close();
    });

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, CuentasLoaded] when LoadCuentas succeeds',
      setUp: () {
        when(() => mockRepository.getCuentasPorPeriodo(any()))
            .thenAnswer((_) async => [testCuenta]);
      },
      build: () => CuentasBloc(mockRepository),
      act: (bloc) => bloc.add(const CuentasLoadRequested('202604')),
      expect: () => [
        isA<CuentasLoading>(),
        isA<CuentasLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.getCuentasPorPeriodo('202604')).called(1);
      },
    );

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, CuentasError] when LoadCuentas fails',
      setUp: () {
        when(() => mockRepository.getCuentasPorPeriodo(any()))
            .thenThrow(Exception('Network error'));
      },
      build: () => CuentasBloc(mockRepository),
      act: (bloc) => bloc.add(const CuentasLoadRequested('202604')),
      expect: () => [
        isA<CuentasLoading>(),
        isA<CuentasError>(),
      ],
    );

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, CuentaDetalleLoaded] when CuentaDetalleRequested succeeds',
      setUp: () {
        when(() => mockRepository.getDetalleCuenta(any(), any()))
            .thenAnswer((_) async => testCuenta);
      },
      build: () => CuentasBloc(mockRepository),
      seed: () => CuentasLoaded([testCuenta], '202604'),
      act: (bloc) => bloc.add(const CuentaDetalleRequested('1', 'acc-1', '202604')),
      expect: () => [
        isA<CuentasLoading>(),
        isA<CuentaDetalleLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.getDetalleCuenta('acc-1', '1')).called(1);
      },
    );

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, CuentasError] when CuentaDetalleRequested fails',
      setUp: () {
        when(() => mockRepository.getDetalleCuenta(any(), any()))
            .thenThrow(Exception('Not found'));
      },
      build: () => CuentasBloc(mockRepository),
      seed: () => CuentasLoaded([testCuenta], '202604'),
      act: (bloc) => bloc.add(const CuentaDetalleRequested('1', 'acc-1', '202604')),
      expect: () => [
        isA<CuentasLoading>(),
        isA<CuentasError>(),
      ],
    );

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, PagoSuccess] when PagoRegistrado succeeds',
      setUp: () {
        when(() => mockRepository.registrarPago(any(), any(), any(), any()))
            .thenAnswer((_) async => true);
      },
      build: () => CuentasBloc(mockRepository),
      act: (bloc) => bloc.add(PagoRegistrado(
        '1',
        'acc-1',
        15000,
        15000,
      )),
      expect: () => [
        isA<CuentasLoading>(),
        isA<PagoSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepository.registrarPago(
              '1',
              'acc-1',
              15000,
              15000,
            )).called(1);
      },
    );

    blocTest<CuentasBloc, CuentasState>(
      'emits [CuentasLoading, PagoFailure] when PagoRegistrado fails',
      setUp: () {
        when(() => mockRepository.registrarPago(any(), any(), any(), any()))
            .thenThrow(Exception('Payment failed'));
      },
      build: () => CuentasBloc(mockRepository),
      act: (bloc) => bloc.add(PagoRegistrado(
        '1',
        'acc-1',
        15000,
        15000,
      )),
      expect: () => [
        isA<CuentasLoading>(),
        isA<PagoFailure>(),
      ],
    );
  });
}
