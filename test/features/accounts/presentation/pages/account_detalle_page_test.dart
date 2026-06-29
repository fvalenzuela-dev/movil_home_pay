import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:movil_home_pay/features/accounts/presentation/pages/account_detalle_page.dart';

import '../../../../fixtures/account/account_fixture.dart';
import '../../../../helpers/test_bootstrap.dart';

class MockAccountBloc extends MockBloc<AccountEvent, AccountState>
    implements AccountBloc {}

void main() {
  late MockAccountBloc mockAccountBloc;

  setUpAll(() {
    bootstrapTests();
  });

  setUp(() {
    mockAccountBloc = MockAccountBloc();
  });

  final account = AccountFixture.createValidAccount(
    id: 'acc-1',
    name: 'Netflix',
    companyName: 'Test Company',
    billingDay: 15,
    autoAccumulate: false,
    isActive: true,
    createdAt: '2024-01-01T00:00:00Z',
  );

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<AccountBloc>.value(
        value: mockAccountBloc,
        child: const AccountDetallePage(accountId: 'acc-1'),
      ),
    );
  }

  group('AccountDetallePage', () {
    testWidgets('shows loading indicator when state is AccountLoading',
        (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountLoading());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is AccountError',
        (tester) async {
      when(() => mockAccountBloc.state)
          .thenReturn(const AccountError('Error cargando cuenta'));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Error cargando cuenta'), findsOneWidget);
    });

    testWidgets('renders account name when state is AccountDetailLoaded',
        (tester) async {
      when(() => mockAccountBloc.state)
          .thenReturn(AccountDetailLoaded(account));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('renders company name when state is AccountDetailLoaded',
        (tester) async {
      when(() => mockAccountBloc.state)
          .thenReturn(AccountDetailLoaded(account));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Test Company'), findsOneWidget);
    });

    testWidgets('renders Editar affordance when state is AccountDetailLoaded',
        (tester) async {
      when(() => mockAccountBloc.state)
          .thenReturn(AccountDetailLoaded(account));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Editar'), findsOneWidget);
    });
  });
}
