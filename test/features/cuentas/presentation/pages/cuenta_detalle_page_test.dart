import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/theme/app_theme.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';
import 'package:movil_home_pay/features/cuentas/domain/repositories/cuenta_repository.dart';
import 'package:movil_home_pay/features/cuentas/presentation/bloc/cuentas_bloc.dart';
import 'package:movil_home_pay/features/cuentas/presentation/pages/cuenta_detalle_page.dart';

import '../../../../fixtures/cuenta/cuenta_fixture.dart';

class MockCuentaRepository extends Mock implements CuentaRepository {}

class FakeCuentasEvent extends Fake implements CuentasEvent {}

class FakeCuentasState extends Fake implements CuentasState {}

void main() {
  late MockCuentaRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCuentasEvent());
    registerFallbackValue(FakeCuentasState());
  });

  setUp(() {
    mockRepository = MockCuentaRepository();
  });

  // Pumps the detail page for [cuenta]. The bloc is created inside the test
  // body (not setUp) so its event-processing microtasks run inside the
  // FakeAsync zone that pumpAndSettle drives; otherwise the initState-dispatched
  // CuentaDetalleRequested never settles into CuentaDetalleLoaded.
  Future<void> pumpDetalle(WidgetTester tester, Cuenta cuenta) async {
    final bloc = CuentasBloc(mockRepository);
    addTearDown(bloc.close);
    when(() => mockRepository.getDetalleCuenta(any()))
        .thenAnswer((_) async => cuenta);

    final router = GoRouter(
      initialLocation: '/detalle',
      routes: [
        GoRoute(
          path: '/detalle',
          builder: (context, state) => CuentaDetallePage(
            cuentaId: cuenta.id,
            accountId: cuenta.accountId,
            periodo: cuenta.periodo,
          ),
        ),
        GoRoute(
          path: '/cuentas',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('lista'))),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<CuentasBloc>.value(
        value: bloc,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.lightTheme,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CuentaDetallePage Widget Tests', () {
    testWidgets('shows a human-readable placeholder instead of the UUID when nombre is empty',
        (tester) async {
      final cuenta = CuentaFixture.createValidCuenta(
        accountId: '550e8400-e29b-41d4-a716-446655440000',
        nombre: '',
      );

      await pumpDetalle(tester, cuenta);

      expect(find.text(cuenta.accountId), findsNothing);
      expect(find.text('Cuenta sin nombre'), findsOneWidget);
    });

    testWidgets('account icon uses the brand color (Netflix red), matching the list',
        (tester) async {
      final cuenta = CuentaFixture.createValidCuenta(nombre: 'Netflix');

      await pumpDetalle(tester, cuenta);

      const brandRed = Color(0xFFEF4444);
      final iconFinder = find.byIcon(Icons.subscriptions);
      expect(iconFinder, findsOneWidget);

      // Glyph is tinted with the brand color (not the washed-out theme color).
      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, equals(brandRed));

      // Icon sits inside a container tinted with the same brand color.
      final containerFinder =
          find.ancestor(of: iconFinder, matching: find.byType(Container)).first;
      final decoration =
          tester.widget<Container>(containerFinder).decoration as BoxDecoration;
      expect(decoration.color, equals(brandRed.withValues(alpha: 0.1)));
    });

    testWidgets('renders the paid date using the yyyy-MM-dd format', (tester) async {
      final cuenta = CuentaFixture.createPaidCuenta(); // fechaPago: 2024-04-15

      await pumpDetalle(tester, cuenta);

      expect(find.text('2024-04-15'), findsOneWidget);
      expect(find.text('15/4/2024'), findsNothing);
    });

    testWidgets('reopen button is compact (not full-width) and right-aligned for a paid account',
        (tester) async {
      final cuenta = CuentaFixture.createPaidCuenta();

      await pumpDetalle(tester, cuenta);

      final buttonFinder = find.widgetWithText(OutlinedButton, 'Reabrir cuenta');
      expect(buttonFinder, findsOneWidget);

      // Compact: the button must not stretch to the full screen width.
      final buttonWidth = tester.getSize(buttonFinder).width;
      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      expect(buttonWidth, lessThan(screenWidth * 0.7));

      // Right-aligned: wrapped in an Align with centerRight.
      final alignFinder = find.ancestor(
        of: buttonFinder,
        matching: find.byWidgetPredicate(
          (w) => w is Align && w.alignment == Alignment.centerRight,
        ),
      );
      expect(alignFinder, findsOneWidget);
    });
  });
}
