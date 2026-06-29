import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/accounts/data/datasources/account_datasource.dart';
import 'package:movil_home_pay/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';
import 'package:movil_home_pay/features/accounts/domain/repositories/account_repository.dart';

import '../../../../fixtures/account/account_fixture.dart';
import '../../../../helpers/test_bootstrap.dart';

class MockAccountDatasource extends Mock implements AccountDatasource {}

class FakeAccount extends Fake implements Account {}

void main() {
  late MockAccountDatasource mockDatasource;
  late AccountRepositoryImpl repository;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(FakeAccount());
  });

  setUp(() {
    mockDatasource = MockAccountDatasource();
    repository = AccountRepositoryImpl(mockDatasource);
  });

  final testAccount = AccountFixture.createValidAccount(id: 'acc-001');
  final testPaginatedResult = PaginatedResult<Account>(
    items: [testAccount],
    currentPage: 1,
    totalPages: 1,
    totalCount: 1,
  );

  group('AccountRepositoryImpl', () {
    group('getAccounts', () {
      test('delegates to datasource and returns result unchanged', () async {
        when(() => mockDatasource.getAccounts(
              companyId: any(named: 'companyId'),
              sort: any(named: 'sort'),
              order: any(named: 'order'),
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => testPaginatedResult);

        final result = await repository.getAccounts();

        expect(result, equals(testPaginatedResult));
        verify(() => mockDatasource.getAccounts(
              companyId: null,
              sort: null,
              order: null,
              page: 1,
              limit: 20,
            )).called(1);
      });

      test('propagates DioException from datasource', () {
        when(() => mockDatasource.getAccounts(
              companyId: any(named: 'companyId'),
              sort: any(named: 'sort'),
              order: any(named: 'order'),
              page: any(named: 'page'),
              limit: any(named: 'limit'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.getAccounts(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('getAccountById', () {
      test('delegates to datasource and returns result unchanged', () async {
        when(() => mockDatasource.getAccountById(any()))
            .thenAnswer((_) async => testAccount);

        final result = await repository.getAccountById('acc-001');

        expect(result, equals(testAccount));
        verify(() => mockDatasource.getAccountById('acc-001')).called(1);
      });

      test('propagates exception from datasource', () {
        when(() => mockDatasource.getAccountById(any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.getAccountById('acc-001'),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('createAccount', () {
      test('delegates to datasource and returns result unchanged', () async {
        when(() => mockDatasource.createAccount(any()))
            .thenAnswer((_) async => testAccount);

        final result = await repository.createAccount(testAccount);

        expect(result, equals(testAccount));
        verify(() => mockDatasource.createAccount(testAccount)).called(1);
      });

      test('propagates exception from datasource', () {
        when(() => mockDatasource.createAccount(any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.createAccount(testAccount),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateAccount', () {
      test('delegates to datasource and returns result unchanged', () async {
        when(() => mockDatasource.updateAccount(any()))
            .thenAnswer((_) async => testAccount);

        final result = await repository.updateAccount(testAccount);

        expect(result, equals(testAccount));
        verify(() => mockDatasource.updateAccount(testAccount)).called(1);
      });

      test('propagates exception from datasource', () {
        when(() => mockDatasource.updateAccount(any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.updateAccount(testAccount),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('deleteAccount', () {
      test('delegates to datasource and returns true', () async {
        when(() => mockDatasource.deleteAccount(any()))
            .thenAnswer((_) async => true);

        final result = await repository.deleteAccount('acc-001');

        expect(result, isTrue);
        verify(() => mockDatasource.deleteAccount('acc-001')).called(1);
      });

      test('propagates exception from datasource', () {
        when(() => mockDatasource.deleteAccount(any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.deleteAccount('acc-001'),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
