import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';
import 'package:movil_home_pay/features/empresas/presentation/widgets/empresa_card.dart';

void main() {
  group('EmpresaCard', () {
    late Empresa testEmpresa;

    setUp(() {
      testEmpresa = Empresa(
        id: 'emp-1',
        authUserId: 'user-1',
        categoryId: 1,
        name: 'Netflix',
        website: 'https://netflix.com',
        phone: '+1234567890',
        isActive: true,
      );
    });

    Widget createWidgetUnderTest({
      required Empresa empresa,
      VoidCallback? onTap,
      VoidCallback? onEdit,
      VoidCallback? onDelete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: EmpresaCard(
            empresa: empresa,
            onTap: onTap,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ),
      );
    }

    testWidgets('renders empresa name correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('renders website when provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.text('https://netflix.com'), findsOneWidget);
    });

    testWidgets('renders category badge with categoryId', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.text('Cat: 1'), findsOneWidget);
    });

    testWidgets('renders active badge when empresa is active', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.text('Activa'), findsOneWidget);
    });

    testWidgets('renders inactive badge when empresa is not active', (tester) async {
      final inactiveEmpresa = testEmpresa.copyWith(isActive: false);
      await tester.pumpWidget(createWidgetUnderTest(empresa: inactiveEmpresa));

      expect(find.text('Inactiva'), findsOneWidget);
    });

    testWidgets('renders business icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.byIcon(Icons.business), findsOneWidget);
    });

    testWidgets('does not render website when null', (tester) async {
      // Note: Empresa copyWith has a known issue where website: null doesn't clear the website
      // Instead, test with an empresa that was created with null website from the start
      final empresaWithoutWebsite = Empresa(
        id: 'emp-1',
        authUserId: 'user-1',
        categoryId: 1,
        name: 'Netflix',
        website: null,
        phone: '+1234567890',
        isActive: true,
      );
      await tester.pumpWidget(createWidgetUnderTest(empresa: empresaWithoutWebsite));

      // Website should not be rendered when null
      expect(find.text('https://netflix.com'), findsNothing);
    });

    testWidgets('triggers onTap callback when card is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byType(EmpresaCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows edit button when onEdit is provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onEdit: () {},
      ));

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('shows delete button when onDelete is provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onDelete: () {},
      ));

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('does not show edit button when onEdit is null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onEdit: null,
        onDelete: () {},
      ));

      expect(find.byIcon(Icons.edit_outlined), findsNothing);
    });

    testWidgets('does not show delete button when onDelete is null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onEdit: () {},
        onDelete: null,
      ));

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('triggers onEdit callback when edit button is pressed', (tester) async {
      bool editTapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onEdit: () => editTapped = true,
      ));

      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(editTapped, isTrue);
    });

    testWidgets('triggers onDelete callback when delete button is pressed', (tester) async {
      bool deleteTapped = false;
      await tester.pumpWidget(createWidgetUnderTest(
        empresa: testEmpresa,
        onDelete: () => deleteTapped = true,
      ));

      await tester.tap(find.byIcon(Icons.delete_outline));
      expect(deleteTapped, isTrue);
    });

    testWidgets('renders in a Card widget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders InkWell for tap effect', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('handles empresa with phone number', (tester) async {
      // Phone is displayed via InkWell so just verify it renders without error
      await tester.pumpWidget(createWidgetUnderTest(empresa: testEmpresa));

      expect(find.byType(EmpresaCard), findsOneWidget);
    });

    testWidgets('handles long website text with ellipsis', (tester) async {
      final empresaLongWebsite = testEmpresa.copyWith(
        website: 'https://verylongwebsitename.thatexceedsnormalength.com',
      );
      await tester.pumpWidget(createWidgetUnderTest(empresa: empresaLongWebsite));

      expect(find.byType(EmpresaCard), findsOneWidget);
      expect(find.text('https://verylongwebsitename.thatexceedsnormalength.com'), findsOneWidget);
    });
  });
}
