import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/config/api_config.dart';
import 'package:movil_home_pay/features/accounts/data/datasources/account_datasource.dart';
import 'package:movil_home_pay/features/accounts/domain/entities/account.dart';

import '../../../../fixtures/account/account_fixture.dart';
import '../../../../fixtures/api_response.dart';
import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

void main() {
  late MockDio mockDio;
  late AccountDatasource datasource;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    datasource = AccountDatasource(mockDio);
  });

  group('AccountDatasource', () {
    group('getAccounts', () {
      test('returns PaginatedResult<Account> on success', () async {
        final accountsJson = [
          AccountFixture.createAccountJson(id: 'acc-1', name: 'Netflix'),
          AccountFixture.createAccountJson(id: 'acc-2', name: 'Spotify'),
        ];
        final responseData = ApiResponseBuilder.paginatedList(
          items: accountsJson,
          totalCount: 2,
        );

        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ApiConfig.accountsUrl()),
              statusCode: 200,
              data: responseData,
            ));

        final result = await datasource.getAccounts();

        expect(result.items, isA<List<Account>>());
        expect(result.items.length, equals(2));
        expect(result.totalCount, equals(2));
      });

      test('request URL contains limit=20 NOT page_size', () async {
        final responseData = ApiResponseBuilder.paginatedList(
          items: [],
          totalCount: 0,
        );

        String? capturedUrl;
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((invocation) async {
          capturedUrl = invocation.positionalArguments[0] as String;
          return Response(
            requestOptions: RequestOptions(path: capturedUrl!),
            statusCode: 200,
            data: responseData,
          );
        });

        await datasource.getAccounts(page: 1, limit: 20);

        expect(capturedUrl, contains('limit=20'));
        expect(capturedUrl, isNot(contains('page_size')));
      });

      test('forwards companyId in query string', () async {
        final responseData = ApiResponseBuilder.paginatedList(
          items: [],
          totalCount: 0,
        );

        String? capturedUrl;
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((invocation) async {
          capturedUrl = invocation.positionalArguments[0] as String;
          return Response(
            requestOptions: RequestOptions(path: capturedUrl!),
            statusCode: 200,
            data: responseData,
          );
        });

        await datasource.getAccounts(companyId: 'comp-1');

        expect(capturedUrl, contains('company_id=comp-1'));
      });

      test('propagates DioException', () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiConfig.accountsUrl()),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => datasource.getAccounts(),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('getAccountById', () {
      test('returns Account parsing from response root (no envelope)', () async {
        final accountJson = AccountFixture.createAccountJson(
          id: 'acc-1',
          name: 'Netflix',
        );

        // Direct root response (no wrapping data key)
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Response(
              requestOptions:
                  RequestOptions(path: ApiConfig.accountUrl('acc-1')),
              statusCode: 200,
              data: accountJson,
            ));

        final result = await datasource.getAccountById('acc-1');

        expect(result.id, 'acc-1');
        expect(result.name, 'Netflix');
      });

      test('throws ArgumentError for empty id without HTTP call', () {
        expect(
          () => datasource.getAccountById(''),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(() => mockDio.get(any()));
      });

      test('propagates DioException', () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions:
              RequestOptions(path: ApiConfig.accountUrl('acc-1')),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => datasource.getAccountById('acc-1'),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('createAccount', () {
      test('throws ArgumentError for whitespace-only name without HTTP call',
          () {
        final account =
            AccountFixture.createValidAccount(companyId: 'comp-1', name: '   ');

        expect(
          () => datasource.createAccount(account),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(() => mockDio.post(any()));
      });

      test('throws ArgumentError for empty companyId without HTTP call', () {
        final account =
            AccountFixture.createValidAccount(companyId: '', name: 'Netflix');

        expect(
          () => datasource.createAccount(account),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(() => mockDio.post(any()));
      });

      test('creates account and returns Account on 201', () async {
        final account = AccountFixture.createValidAccount(
          companyId: 'comp-1',
          name: 'Netflix',
        );
        final responseData = ApiResponseBuilder.success(
          data: AccountFixture.createAccountJson(
            id: 'acc-new',
            name: 'Netflix',
          ),
        );

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Response(
              requestOptions:
                  RequestOptions(path: ApiConfig.accountsPath),
              statusCode: 201,
              data: responseData,
            ));

        final result = await datasource.createAccount(account);

        expect(result, isA<Account>());
        expect(result.name, 'Netflix');
      });

      test('propagates DioException', () async {
        final account = AccountFixture.createValidAccount(
          companyId: 'comp-1',
          name: 'Netflix',
        );

        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiConfig.accountsPath),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => datasource.createAccount(account),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('updateAccount', () {
      test('throws ArgumentError for invalid id without HTTP call', () {
        final account =
            AccountFixture.createValidAccount(id: '', name: 'Netflix');

        expect(
          () => datasource.updateAccount(account),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(() => mockDio.put(any()));
      });

      test('updates account and returns Account on 200', () async {
        final account = AccountFixture.createValidAccount(
          id: 'acc-001',
          name: 'Updated Netflix',
        );
        final responseData = ApiResponseBuilder.success(
          data: AccountFixture.createAccountJson(
            id: 'acc-001',
            name: 'Updated Netflix',
          ),
        );

        when(() => mockDio.put(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Response(
              requestOptions:
                  RequestOptions(path: ApiConfig.accountUrl('acc-001')),
              statusCode: 200,
              data: responseData,
            ));

        final result = await datasource.updateAccount(account);

        expect(result.name, 'Updated Netflix');
      });

      test('propagates DioException', () async {
        final account = AccountFixture.createValidAccount(id: 'acc-001');

        when(() => mockDio.put(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions:
              RequestOptions(path: ApiConfig.accountUrl('acc-001')),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => datasource.updateAccount(account),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('deleteAccount', () {
      test('throws ArgumentError for empty id without HTTP call', () {
        expect(
          () => datasource.deleteAccount(''),
          throwsA(isA<ArgumentError>()),
        );
        verifyNever(() => mockDio.delete(any()));
      });

      test('returns true on 204 (no body)', () async {
        when(() => mockDio.delete(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Response(
              requestOptions:
                  RequestOptions(path: ApiConfig.accountUrl('acc-1')),
              statusCode: 204,
              data: null,
            ));

        final result = await datasource.deleteAccount('acc-1');

        expect(result, isTrue);
      });

      test('propagates DioException', () async {
        when(() => mockDio.delete(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions:
              RequestOptions(path: ApiConfig.accountUrl('acc-1')),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => datasource.deleteAccount('acc-1'),
          throwsA(isA<DioException>()),
        );
      });
    });
  });
}
