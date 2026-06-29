import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';
import 'package:movil_home_pay/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:movil_home_pay/features/accounts/presentation/pages/account_form_page.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';
import 'package:movil_home_pay/features/empresas/presentation/bloc/empresa_bloc.dart';

import '../../../../helpers/test_bootstrap.dart';

class MockAccountBloc extends MockBloc<AccountEvent, AccountState>
    implements AccountBloc {}

class MockEmpresaBloc extends MockBloc<EmpresaEvent, EmpresaState>
    implements EmpresaBloc {}

void main() {
  late MockAccountBloc mockAccountBloc;
  late MockEmpresaBloc mockEmpresaBloc;

  setUpAll(() {
    bootstrapTests();
  });

  setUp(() {
    mockAccountBloc = MockAccountBloc();
    mockEmpresaBloc = MockEmpresaBloc();
  });

  final empresa1 = Empresa(
    id: 'comp-1',
    authUserId: 'user-1',
    categoryId: 1,
    name: 'Netflix Corp',
  );

  Widget buildSubject({String? accountId}) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>.value(value: mockAccountBloc),
          BlocProvider<EmpresaBloc>.value(value: mockEmpresaBloc),
        ],
        child: AccountFormPage(accountId: accountId),
      ),
    );
  }

  group('AccountFormPage', () {
    testWidgets('renders empresa dropdown and exposes empresa1.name as option',
        (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitial());
      when(() => mockEmpresaBloc.state).thenReturn(EmpresaListLoaded(
        empresas: [empresa1],
        page: 1,
        totalPages: 1,
        totalCount: 1,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // The dropdown widget renders
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      // Open the dropdown to see the empresa option
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Empresa name should be visible as a menu item
      expect(find.text('Netflix Corp'), findsWidgets);
    });

    testWidgets('submit button is disabled when no empresa is selected',
        (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitial());
      when(() => mockEmpresaBloc.state).thenReturn(EmpresaListLoaded(
        empresas: [empresa1],
        page: 1,
        totalPages: 1,
        totalCount: 1,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Find ElevatedButton (submit)
      final submitButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(submitButton.onPressed, isNull);
    });

    testWidgets('submit button is enabled after selecting an empresa',
        (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitial());
      when(() => mockEmpresaBloc.state).thenReturn(EmpresaListLoaded(
        empresas: [empresa1],
        page: 1,
        totalPages: 1,
        totalCount: 1,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Open the dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Select empresa1
      await tester.tap(find.text('Netflix Corp').last);
      await tester.pumpAndSettle();

      // Submit button should now be enabled
      final submitButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('renders in create mode when accountId is null', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountInitial());
      when(() => mockEmpresaBloc.state).thenReturn(EmpresaListLoaded(
        empresas: [empresa1],
        page: 1,
        totalPages: 1,
        totalCount: 1,
      ));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Nueva Cuenta'), findsOneWidget);
    });

    testWidgets('renders in edit mode when accountId is provided', (tester) async {
      when(() => mockAccountBloc.state).thenReturn(const AccountLoading());
      when(() => mockEmpresaBloc.state).thenReturn(EmpresaInitial());

      await tester.pumpWidget(buildSubject(accountId: 'acc-1'));
      await tester.pumpAndSettle();

      expect(find.text('Editar Cuenta'), findsOneWidget);
    });
  });
}
