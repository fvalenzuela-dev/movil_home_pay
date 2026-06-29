import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';
import 'package:movil_home_pay/features/accounts/domain/repositories/account_repository.dart';
import 'package:movil_home_pay/features/accounts/presentation/bloc/account_bloc.dart';

import '../../../../fixtures/account/account_fixture.dart';
import '../../../../helpers/test_bootstrap.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class FakeAccount extends Fake implements Account {}

void main() {
  late MockAccountRepository mockRepository;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(FakeAccount());
  });

  setUp(() {
    mockRepository = MockAccountRepository();
  });

  final testAccount = AccountFixture.createValidAccount(id: 'acc-001');
  final testPaginatedResult = PaginatedResult<Account>(
    items: [testAccount],
    currentPage: 1,
    totalPages: 2,
    totalCount: 5,
  );

  group('AccountBloc', () {
    test('initial state is AccountInitial', () {
      final bloc = AccountBloc(mockRepository);
      expect(bloc.state, isA<AccountInitial>());
      bloc.close();
    });

    group('AccountListRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountListLoaded] when getAccounts succeeds',
        setUp: () {
          when(() => mockRepository.getAccounts(
                companyId: any(named: 'companyId'),
                sort: any(named: 'sort'),
                order: any(named: 'order'),
                page: any(named: 'page'),
                limit: any(named: 'limit'),
              )).thenAnswer((_) async => testPaginatedResult);
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountListRequested()),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountListLoaded>(),
        ],
        verify: (bloc) {
          final state = bloc.state as AccountListLoaded;
          expect(state.accounts, equals([testAccount]));
          expect(state.page, equals(1));
          expect(state.totalPages, equals(2));
          expect(state.totalCount, equals(5));
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when getAccounts fails',
        setUp: () {
          when(() => mockRepository.getAccounts(
                companyId: any(named: 'companyId'),
                sort: any(named: 'sort'),
                order: any(named: 'order'),
                page: any(named: 'page'),
                limit: any(named: 'limit'),
              )).thenThrow(Exception('Network error'));
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountListRequested()),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountError>(),
        ],
      );
    });

    group('AccountDetailRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountDetailLoaded] when getAccountById succeeds',
        setUp: () {
          when(() => mockRepository.getAccountById(any()))
              .thenAnswer((_) async => testAccount);
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountDetailRequested('acc-001')),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountDetailLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepository.getAccountById('acc-001')).called(1);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when getAccountById fails',
        setUp: () {
          when(() => mockRepository.getAccountById(any()))
              .thenThrow(Exception('Not found'));
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountDetailRequested('bad-id')),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountError>(),
        ],
      );
    });

    group('AccountCreateRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountOperationSuccess] when createAccount succeeds',
        setUp: () {
          when(() => mockRepository.createAccount(any()))
              .thenAnswer((_) async => testAccount);
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(AccountCreateRequested(testAccount)),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountOperationSuccess>(),
        ],
        verify: (bloc) {
          final state = bloc.state as AccountOperationSuccess;
          expect(state.account, equals(testAccount));
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when createAccount fails',
        setUp: () {
          when(() => mockRepository.createAccount(any()))
              .thenThrow(Exception('Duplicate'));
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(AccountCreateRequested(testAccount)),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountError>(),
        ],
      );
    });

    group('AccountUpdateRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountOperationSuccess] when updateAccount succeeds',
        setUp: () {
          when(() => mockRepository.updateAccount(any()))
              .thenAnswer((_) async => testAccount);
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(AccountUpdateRequested(testAccount)),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountOperationSuccess>(),
        ],
        verify: (bloc) {
          final state = bloc.state as AccountOperationSuccess;
          expect(state.account, equals(testAccount));
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when updateAccount fails',
        setUp: () {
          when(() => mockRepository.updateAccount(any()))
              .thenThrow(Exception('Update failed'));
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(AccountUpdateRequested(testAccount)),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountError>(),
        ],
      );
    });

    group('AccountDeleteRequested', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountOperationSuccess] with null account when deleteAccount succeeds',
        setUp: () {
          when(() => mockRepository.deleteAccount(any()))
              .thenAnswer((_) async => true);
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountDeleteRequested('acc-001')),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountOperationSuccess>(),
        ],
        verify: (bloc) {
          final state = bloc.state as AccountOperationSuccess;
          expect(state.account, isNull);
        },
      );

      blocTest<AccountBloc, AccountState>(
        'emits [AccountLoading, AccountError] when deleteAccount fails',
        setUp: () {
          when(() => mockRepository.deleteAccount(any()))
              .thenThrow(Exception('Delete failed'));
        },
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountDeleteRequested('acc-001')),
        expect: () => [
          isA<AccountLoading>(),
          isA<AccountError>(),
        ],
      );
    });

    group('AccountListReset', () {
      blocTest<AccountBloc, AccountState>(
        'emits [AccountInitial] (NO AccountLoading) when AccountListReset is added',
        build: () => AccountBloc(mockRepository),
        act: (bloc) => bloc.add(const AccountListReset()),
        expect: () => [
          isA<AccountInitial>(),
        ],
      );
    });
  });
}
