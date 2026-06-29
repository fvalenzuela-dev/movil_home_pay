import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';
import 'package:movil_home_pay/features/accounts/presentation/widgets/account_card.dart';

void main() {
  group('AccountCard', () {
    late Account testAccount;

    setUp(() {
      testAccount = const Account(
        id: 'acc-1',
        companyId: 'comp-1',
        companyName: 'Netflix Corp',
        name: 'Netflix Monthly',
        accountNumber: 'ACC-001',
        billingDay: 15,
        autoAccumulate: false,
        isActive: true,
      );
    });

    Widget createWidgetUnderTest({
      required Account account,
      VoidCallback? onEdit,
      VoidCallback? onDelete,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AccountCard(
            account: account,
            onEdit: onEdit ?? () {},
            onDelete: onDelete ?? () {},
          ),
        ),
      );
    }

    testWidgets('renders account name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.text('Netflix Monthly'), findsOneWidget);
    });

    testWidgets('renders company name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.text('Netflix Corp'), findsOneWidget);
    });

    testWidgets('renders active badge when isActive is true', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.text('Activa'), findsOneWidget);
    });

    testWidgets('renders inactive badge when isActive is false', (tester) async {
      final inactiveAccount = testAccount.copyWith(isActive: false);
      await tester.pumpWidget(createWidgetUnderTest(account: inactiveAccount));

      expect(find.text('Inactiva'), findsOneWidget);
    });

    testWidgets('shows edit icon button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('shows delete icon button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('triggers onEdit callback when edit button is tapped',
        (tester) async {
      bool editCalled = false;
      await tester.pumpWidget(createWidgetUnderTest(
        account: testAccount,
        onEdit: () => editCalled = true,
      ));

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pump();

      expect(editCalled, isTrue);
    });

    testWidgets('triggers onDelete callback when delete button is tapped',
        (tester) async {
      bool deleteCalled = false;
      await tester.pumpWidget(createWidgetUnderTest(
        account: testAccount,
        onDelete: () => deleteCalled = true,
      ));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('renders inside a Card widget', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(account: testAccount));

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
