import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/cuentas/domain/entities/cuenta.dart';
import 'package:movil_home_pay/features/cuentas/presentation/widgets/cuenta_card.dart';
import 'package:movil_home_pay/features/cuentas/presentation/widgets/estado_badge.dart';

void main() {
  group('CuentaCard', () {
    Cuenta createTestCuenta({
      String id = '1',
      String accountId = 'acc-1',
      String nombre = 'Netflix',
      double monto = 15000,
      double montoPagado = 0,
      String estado = 'pendiente',
      String periodo = '202604',
    }) {
      return Cuenta(
        id: id,
        accountId: accountId,
        nombre: nombre,
        monto: monto,
        montoPagado: montoPagado,
        estado: estado,
        periodo: periodo,
      );
    }

    Widget createWidgetUnderTest({
      required Cuenta cuenta,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CuentaCard(
            cuenta: cuenta,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('renders cuenta nombre correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(cuenta: createTestCuenta()));

      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('renders formatted monto', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(cuenta: createTestCuenta()));

      expect(find.text('\$15000'), findsOneWidget);
    });

    testWidgets('renders EstadoBadge for pending status', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(cuenta: createTestCuenta()));

      expect(find.byType(EstadoBadge), findsOneWidget);
      expect(find.text('Pendiente'), findsOneWidget);
    });

    testWidgets('renders EstadoBadge for paid status', (tester) async {
      final paidCuenta = createTestCuenta(
        estado: 'pagada',
        montoPagado: 15000,
      );
      await tester.pumpWidget(createWidgetUnderTest(cuenta: paidCuenta));

      expect(find.text('Pagada'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when card is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        cuenta: createTestCuenta(),
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byType(CuentaCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders icon based on nombre - luz/electricidad', (tester) async {
      final luzCuenta = createTestCuenta(nombre: 'CFE Luz');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: luzCuenta));

      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('renders icon based on nombre - agua', (tester) async {
      final aguaCuenta = createTestCuenta(nombre: 'Agua Pay');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: aguaCuenta));

      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });

    testWidgets('renders icon based on nombre - internet/wifi', (tester) async {
      final internetCuenta = createTestCuenta(nombre: 'Internet Telmex');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: internetCuenta));

      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });

    testWidgets('renders icon based on nombre - gas', (tester) async {
      final gasCuenta = createTestCuenta(nombre: 'Gas Natural');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: gasCuenta));

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('renders icon based on nombre - telefono/celular', (tester) async {
      final telefonoCuenta = createTestCuenta(nombre: 'Telefono Azteca');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: telefonoCuenta));

      expect(find.byIcon(Icons.phone_android), findsOneWidget);
    });

    testWidgets('renders default icon for unknown service', (tester) async {
      final unknownCuenta = createTestCuenta(nombre: 'Unknown Service');
      await tester.pumpWidget(createWidgetUnderTest(cuenta: unknownCuenta));

      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('renders in a Card widget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(cuenta: createTestCuenta()));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders InkWell for tap effect', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(cuenta: createTestCuenta()));

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('handles large monto values', (tester) async {
      // Note: toStringAsFixed(0) rounds 999999.99 to 1000000
      final largeMontoCuenta = createTestCuenta(monto: 999999.99);
      await tester.pumpWidget(createWidgetUnderTest(cuenta: largeMontoCuenta));

      expect(find.text('\$1000000'), findsOneWidget);
    });

    testWidgets('renders with zero monto', (tester) async {
      final zeroMontoCuenta = createTestCuenta(monto: 0);
      await tester.pumpWidget(createWidgetUnderTest(cuenta: zeroMontoCuenta));

      expect(find.text('\$0'), findsOneWidget);
    });

    testWidgets('handles very long nombre with ellipsis', (tester) async {
      final longNombreCuenta = createTestCuenta(
        nombre: 'Very Long Service Name That Might Exceed Layout',
      );
      await tester.pumpWidget(createWidgetUnderTest(cuenta: longNombreCuenta));

      expect(find.byType(CuentaCard), findsOneWidget);
    });
  });
}
