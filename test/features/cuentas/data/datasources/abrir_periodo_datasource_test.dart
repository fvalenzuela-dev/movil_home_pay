import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/config/api_config.dart';
import 'package:movil_home_pay/features/cuentas/data/datasources/cuenta_datasource.dart';

import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

/// Builds a billing JSON map with API-shaped keys, as returned by the backend.
Map<String, dynamic> billingJson({
  String id = 'cta_1',
  String accountId = 'acc_1',
  String? accountName,
  double amountBilled = 10000.0,
  double amountPaid = 0.0,
  bool isPaid = false,
  String status = 'pending',
  String period = '202404',
}) {
  return {
    'id': id,
    'account_id': accountId,
    'account_name': ?accountName,
    'amount_billed': amountBilled,
    'amount_paid': amountPaid,
    'is_paid': isPaid,
    'status': status,
    'period': period,
  };
}

void main() {
  late MockDio mockDio;
  late CuentaDatasource datasource;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    datasource = CuentaDatasource(mockDio);
  });

  void stubPost(Map<String, dynamic> responseData, {int statusCode = 200}) {
    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions:
              RequestOptions(path: ApiConfig.periodOpenUrl('202404')),
          statusCode: statusCode,
          data: responseData,
        ));
  }

  group('CuentaDatasource', () {
    group('abrirPeriodo', () {
      test('POSTs to /periods/{period}/open and parses billings list', () async {
        // Arrange
        stubPost({
          'billings': [
            billingJson(id: 'cta_1', accountId: 'acc_1'),
            billingJson(id: 'cta_2', accountId: 'acc_2'),
          ],
        });

        // Act
        final result = await datasource.abrirPeriodo('202404');

        // Assert
        expect(result, hasLength(2));
        expect(result.first.id, equals('cta_1'));
        expect(result.last.id, equals('cta_2'));
        verify(() => mockDio.post(
              ApiConfig.periodOpenUrl('202404'),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      });

      test('falls back to data key when billings key is absent', () async {
        // Arrange
        stubPost({
          'data': [billingJson(id: 'cta_only')],
        });

        // Act
        final result = await datasource.abrirPeriodo('202404');

        // Assert
        expect(result, hasLength(1));
        expect(result.first.id, equals('cta_only'));
      });

      test('parses billings nested under a data envelope', () async {
        // Arrange: backend wraps the list as { data: { billings: [...] } }
        stubPost({
          'data': {
            'billings': [
              billingJson(id: 'cta_nested_1'),
              billingJson(id: 'cta_nested_2'),
            ],
          },
        });

        // Act
        final result = await datasource.abrirPeriodo('202404');

        // Assert
        expect(result, hasLength(2));
        expect(result.first.id, equals('cta_nested_1'));
      });

      test('returns empty list when no billings are returned', () async {
        // Arrange
        stubPost({'billings': []});

        // Act
        final result = await datasource.abrirPeriodo('202404');

        // Assert
        expect(result, isEmpty);
      });

      test('throws ArgumentError for period with wrong length', () async {
        expect(
          () => datasource.abrirPeriodo('2024'),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('YYYYMM'),
          )),
        );
      });

      test('throws ArgumentError for non-numeric period', () async {
        expect(
          () => datasource.abrirPeriodo('abcd12'),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('dígitos'),
          )),
        );
      });

      test('throws ArgumentError for invalid month', () async {
        expect(
          () => datasource.abrirPeriodo('202413'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('propagates DioException on server error', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ApiConfig.periodOpenUrl('202404')),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions:
                RequestOptions(path: ApiConfig.periodOpenUrl('202404')),
            statusCode: 500,
            data: {'error': 'Internal error'},
          ),
        ));

        // Act & Assert
        expect(
          () => datasource.abrirPeriodo('202404'),
          throwsA(isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            equals(500),
          )),
        );
      });
    });
  });
}
