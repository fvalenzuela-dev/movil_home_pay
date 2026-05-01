import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/cuentas/presentation/widgets/estado_badge.dart';

void main() {
  group('EstadoBadge', () {
    Widget createWidgetUnderTest({required String estado}) {
      return MaterialApp(
        home: Scaffold(
          body: EstadoBadge(estado: estado),
        ),
      );
    }

    testWidgets('renders "Pagada" for estado "pagada"', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      expect(find.text('Pagada'), findsOneWidget);
    });

    testWidgets('renders "Pendiente" for estado "pendiente"', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pendiente'));

      expect(find.text('Pendiente'), findsOneWidget);
    });

    testWidgets('renders check_circle icon for "pagada" estado', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('renders pending icon for "pendiente" estado', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pendiente'));

      expect(find.byIcon(Icons.pending), findsOneWidget);
    });

    testWidgets('applies green color scheme for "pagada"', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      // Find the Container that has the green background
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(Colors.green.shade100));
    });

    testWidgets('applies amber color scheme for "pendiente"', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pendiente'));

      // Find the Container that has the amber background
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, equals(Colors.amber.shade100));
    });

    testWidgets('renders Row with icon and text', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('badge has rounded corners', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('text uses correct font weight', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pendiente'));

      final textFinder = find.text('Pendiente');
      final text = tester.widget<Text>(textFinder);
      
      expect(text.style?.fontWeight, equals(FontWeight.w600));
    });

    testWidgets('text uses correct font size', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final textFinder = find.text('Pagada');
      final text = tester.widget<Text>(textFinder);
      
      expect(text.style?.fontSize, equals(12));
    });

    testWidgets('icon has correct size', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final iconFinder = find.byIcon(Icons.check_circle);
      final icon = tester.widget<Icon>(iconFinder);
      
      expect(icon.size, equals(16));
    });

    testWidgets('handles unknown estado gracefully (treats as not paid)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'unknown'));

      // Should still render something, treating 'unknown' as not paid
      expect(find.byType(EstadoBadge), findsOneWidget);
      // pending icon because estado != 'pagada'
      expect(find.byIcon(Icons.pending), findsOneWidget);
    });

    testWidgets('handles "vencida" estado (overdue) renders as pending', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'vencida'));

      expect(find.byIcon(Icons.pending), findsOneWidget);
    });

    testWidgets('icon and text are horizontally arranged', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final row = tester.widget<Row>(find.byType(Row).first);
      expect(row.mainAxisSize, equals(MainAxisSize.min));
    });

    testWidgets('has proper padding', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final container = tester.widget<Container>(find.byType(Container).first);
      final padding = container.padding as EdgeInsets;
      
      // Padding is symmetric, total horizontal = left + right = 12 + 12 = 24
      expect(padding.horizontal, 24);
      expect(padding.vertical, 12);
    });

    testWidgets('text color matches icon color for paid status', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pagada'));

      final textFinder = find.text('Pagada');
      final text = tester.widget<Text>(textFinder);
      
      expect(text.style?.color, equals(Colors.green.shade700));
    });

    testWidgets('text color matches icon color for pending status', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(estado: 'pendiente'));

      final textFinder = find.text('Pendiente');
      final text = tester.widget<Text>(textFinder);
      
      expect(text.style?.color, equals(Colors.amber.shade700));
    });
  });
}
