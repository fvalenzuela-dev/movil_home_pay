import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/config/api_config.dart';
import 'package:movil_home_pay/features/cuentas/data/datasources/cuenta_datasource.dart';

import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

/// Builds a billing JSON map with API-shaped keys, as returned by the backend.
Map<String, dynamic> billingJson({
  String id = 'cta_new',
  String accountId = 'acc_123',
  String? accountName,
  double amountBilled = 14990.0,
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

  void stubPost(Map<String, dynamic> responseData, {int statusCode = 201}) {
    when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions:
              RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings'),
          statusCode: statusCode,
          data: responseData,
        ));
  }

  group('CuentaDatasource', () {
    group('agregarCuentaIndividual', () {
      test('POSTs to /accounts/{accountId}/billings with correct body', () async {
        // Arrange
        stubPost({'billing': billingJson(accountName: 'Netflix')});

        // Act
        final result = await datasource.agregarCuentaIndividual(
          accountId: 'acc_123',
          monto: 14990.0,
          periodo: '202404',
          nombre: 'Netflix',
        );

        // Assert
        expect(result.id, equals('cta_new'));
        expect(result.accountId, equals('acc_123'));
        verify(() => mockDio.post(
              '${ApiConfig.baseUrl}/accounts/acc_123/billings',
              data: predicate<Map<String, dynamic>>((data) {
                // account_id lives in the URL path, not in the body
                expect(data.containsKey('account_id'), isFalse);
                expect(data['amount_billed'], equals(14990.0));
                expect(data['amount_paid'], equals(0));
                expect(data['account_name'], equals('Netflix'));
                expect(data['period'], equals('202404'));
                return true;
              }),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      });

      test('omits account_name when nombre is null', () async {
        // Arrange
        stubPost({
          'billing': billingJson(id: 'cta_no_name', accountId: 'acc_456'),
        });

        // Act
        final result = await datasource.agregarCuentaIndividual(
          accountId: 'acc_456',
          monto: 5000.0,
        );

        // Assert: nombre stays empty (does not expose the account_id/UUID)
        // when no account_name is returned.
        expect(result.nombre, isEmpty);
        verify(() => mockDio.post(
              '${ApiConfig.baseUrl}/accounts/acc_456/billings',
              data: predicate<Map<String, dynamic>>((data) {
                expect(data.containsKey('account_name'), isFalse);
                return true;
              }),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      });

      test('omits period from body when periodo is null', () async {
        // Arrange
        stubPost({'billing': billingJson()});

        // Act
        await datasource.agregarCuentaIndividual(
          accountId: 'acc_123',
          monto: 9000.0,
        );

        // Assert
        verify(() => mockDio.post(
              any(),
              data: predicate<Map<String, dynamic>>((data) {
                expect(data.containsKey('period'), isFalse);
                return true;
              }),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      });

      test('throws ArgumentError for empty accountId', () async {
        expect(
          () => datasource.agregarCuentaIndividual(
            accountId: '',
            monto: 10000.0,
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('vacío'),
          )),
        );
      });

      test('throws ArgumentError for whitespace-only accountId', () async {
        expect(
          () => datasource.agregarCuentaIndividual(
            accountId: '   ',
            monto: 10000.0,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid accountId characters', () async {
        expect(
          () => datasource.agregarCuentaIndividual(
            accountId: 'acc@invalid!',
            monto: 10000.0,
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('inválidos'),
          )),
        );
      });

      test('throws ArgumentError for negative monto', () async {
        expect(
          () => datasource.agregarCuentaIndividual(
            accountId: 'acc_123',
            monto: -100.0,
          ),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('negativo'),
          )),
        );
      });

      test('allows zero amount', () async {
        // Arrange
        stubPost({
          'billing': billingJson(
            id: 'cta_zero',
            accountId: 'acc_zero',
            amountBilled: 0.0,
          ),
        });

        // Act & Assert - should not throw
        final result = await datasource.agregarCuentaIndividual(
          accountId: 'acc_zero',
          monto: 0.0,
        );
        expect(result.monto, equals(0.0));
      });

      test('parses response correctly returning Cuenta with pendiente status', () async {
        // Arrange
        stubPost({
          'billing': billingJson(
            id: 'cta_created',
            accountId: 'acc_789',
            accountName: 'New Service',
            amountBilled: 25000.0,
            amountPaid: 0.0,
            isPaid: false,
            status: 'pending',
            period: '202405',
          ),
        });

        // Act
        final result = await datasource.agregarCuentaIndividual(
          accountId: 'acc_789',
          monto: 25000.0,
          nombre: 'New Service',
        );

        // Assert
        expect(result.id, equals('cta_created'));
        expect(result.estado, equals('pendiente'));
        expect(result.isPaid, isFalse);
        expect(result.montoPagado, equals(0.0));
      });

      test('throws DioException on 409 Conflict (duplicate account)', () async {
        // Arrange
        when(() => mockDio.post(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(DioException(
          requestOptions: RequestOptions(
              path: '${ApiConfig.baseUrl}/accounts/acc_duplicate/billings'),
          type: DioExceptionType.badResponse,
          message: 'Conflict',
          response: Response(
            requestOptions: RequestOptions(
                path: '${ApiConfig.baseUrl}/accounts/acc_duplicate/billings'),
            statusCode: 409,
            data: {'error': 'Cuenta ya existe para este período'},
          ),
        ));

        // Act & Assert
        expect(
          () => datasource.agregarCuentaIndividual(
            accountId: 'acc_duplicate',
            monto: 10000.0,
          ),
          throwsA(isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            equals(409),
          )),
        );
      });
    });
  });
}
