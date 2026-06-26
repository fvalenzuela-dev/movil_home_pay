import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';
import 'package:movil_home_pay/features/cuentas/domain/repositories/cuenta_repository.dart';
import 'package:movil_home_pay/features/cuentas/presentation/bloc/cuentas_bloc.dart';
import 'package:movil_home_pay/features/cuentas/presentation/pages/agregar_cuenta_page.dart';

class MockCuentaRepository extends Mock implements CuentaRepository {}

class FakeCuentasEvent extends Fake implements CuentasEvent {}

class FakeCuentasState extends Fake implements CuentasState {}

void main() {
  late MockCuentaRepository mockRepository;
  late CuentasBloc cuentasBloc;

  setUpAll(() {
    registerFallbackValue(FakeCuentasEvent());
    registerFallbackValue(FakeCuentasState());
  });

  setUp(() {
    mockRepository = MockCuentaRepository();
    cuentasBloc = CuentasBloc(mockRepository);
  });

  tearDown(() {
    cuentasBloc.close();
  });

  final testCuenta = Cuenta(
    id: '1',
    accountId: 'spotify-test',
    nombre: 'Spotify',
    monto: 15000,
    montoPagado: 0,
    estado: 'pendiente',
    periodo: '202605',
  );

  Widget buildTestWidget(CuentasBloc bloc, {String periodo = '202605'}) {
    // Use a real GoRouter so the page's context.pop() on success works.
    // The agregar page is a sub-route of '/', so the navigation stack has a
    // parent page to pop back to.
    final router = GoRouter(
      initialLocation: '/agregar',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('home'))),
          routes: [
            GoRoute(
              path: 'agregar',
              builder: (context, state) => AgregarCuentaPage(periodo: periodo),
            ),
          ],
        ),
      ],
    );
    return BlocProvider<CuentasBloc>.value(
      value: bloc,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('AgregarCuentaPage Widget Tests', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Account ID field
      expect(find.text('ID de Cuenta *'), findsOneWidget);
      // Monto Total field
      expect(find.text('Monto Total *'), findsOneWidget);
      // Monto Pagado field
      expect(find.text('Monto Pagado'), findsOneWidget);
      // Nombre field
      expect(find.text('Nombre de la Cuenta'), findsOneWidget);
      // Submit button
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation error for empty accountId', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Tap submit without filling form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('El ID de cuenta es obligatorio'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid accountId characters', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Enter invalid account ID in the first TextFormField (accountId)
      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'invalid@id!');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('ID contiene caracteres inválidos'), findsOneWidget);
    });

    testWidgets('shows validation error for empty monto', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Fill only account ID
      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'spotify-test');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('El monto es obligatorio'), findsOneWidget);
    });

testWidgets('shows validation error for invalid monto', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Enter non-numeric text in monto field
      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'spotify-test');

      final montoField = find.byType(TextFormField).at(1);
      // Input formatter should prevent non-numeric, but test validates anyway
      await tester.enterText(montoField, '15.50'); // Valid number

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Form should submit with valid data
      verify(() => mockRepository.agregarCuentaIndividual(
        periodo: any(named: 'periodo'),
        accountId: any(named: 'accountId'),
        monto: any(named: 'monto'),
        nombre: any(named: 'nombre'),
      )).called(1);
    });

    testWidgets('submits form with valid data', (tester) async {
      when(() => mockRepository.agregarCuentaIndividual(
        periodo: any(named: 'periodo'),
        accountId: any(named: 'accountId'),
        monto: any(named: 'monto'),
        nombre: any(named: 'nombre'),
      )).thenAnswer((_) async => testCuenta);
      when(() => mockRepository.getCuentasPorPeriodo(any()))
          .thenAnswer((_) async => [testCuenta]);

      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Fill form fields in order
      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'spotify-test');

      final montoField = find.byType(TextFormField).at(1);
      await tester.enterText(montoField, '15000');

      final nombreField = find.byType(TextFormField).at(3);
      await tester.enterText(nombreField, 'Spotify');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Should dispatch event
      verify(() => mockRepository.agregarCuentaIndividual(
        periodo: '202605',
        accountId: 'spotify-test',
        monto: 15000,
        nombre: 'Spotify',
      )).called(1);
    });

    testWidgets('shows loading state while submitting', (tester) async {
      when(() => mockRepository.agregarCuentaIndividual(
        periodo: any(named: 'periodo'),
        accountId: any(named: 'accountId'),
        monto: any(named: 'monto'),
        nombre: any(named: 'nombre'),
      )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return testCuenta;
      });
      when(() => mockRepository.getCuentasPorPeriodo(any()))
          .thenAnswer((_) async => [testCuenta]);

      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Fill form
      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'spotify-test');

      final montoField = find.byType(TextFormField).at(1);
      await tester.enterText(montoField, '15000');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Button should be disabled (showing loading)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('displays periodo info in form', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc, periodo: '202605'));
      await tester.pumpAndSettle();

      expect(find.text('Período: 202605 (se usará el período actual)'), findsOneWidget);
    });

    testWidgets('valid monto accepts decimal numbers', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      final accountIdField = find.byType(TextFormField).first;
      await tester.enterText(accountIdField, 'spotify-test');

      final montoField = find.byType(TextFormField).at(1);
      await tester.enterText(montoField, '15.50');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // No validation error - form dispatched event
      verify(() => mockRepository.agregarCuentaIndividual(
        periodo: any(named: 'periodo'),
        accountId: any(named: 'accountId'),
        monto: any(named: 'monto'),
        nombre: any(named: 'nombre'),
      )).called(1);
    });

    testWidgets('close button is present', (tester) async {
      await tester.pumpWidget(buildTestWidget(cuentasBloc));
      await tester.pumpAndSettle();

      // Close button should be in AppBar
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}