import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';
import 'package:movil_home_pay/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:movil_home_pay/features/accounts/presentation/pages/lista_accounts_page.dart';
import 'package:movil_home_pay/features/accounts/presentation/widgets/account_card.dart';

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

  final account1 = AccountFixture.createValidAccount(id: 'acc-1', name: 'Netflix');
  final account2 = AccountFixture.createValidAccount(id: 'acc-2', name: 'Spotify');

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<AccountBloc>.value(
        value: mockAccountBloc,
        child: const ListaAccountsPage(),
      ),
    );
  }

  group('ListaAccountsPage', () {
    testWidgets('renders two AccountCard widgets when state is AccountListLoaded',
        (tester) async {
      when(() => mockAccountBloc.state).thenReturn(AccountListLoaded(
        accounts: [account1, account2],
        page: 1,
        totalPages: 1,
        totalCount: 2,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(AccountCard), findsNWidgets(2));
    });

    testWidgets('renders account1 name', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(AccountListLoaded(
        accounts: [account1, account2],
        page: 1,
        totalPages: 1,
        totalCount: 2,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Netflix'), findsOneWidget);
    });

    testWidgets('renders FloatingActionButton', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitial());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows loading indicator on AccountLoading state', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(AccountLoading());

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error text on AccountError state', (tester) async {
      when(() => mockAccountBloc.state)
          .thenReturn(const AccountError('Error de red'));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Error de red'), findsOneWidget);
    });
  });
}
