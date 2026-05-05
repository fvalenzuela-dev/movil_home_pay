import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/config/api_config.dart';
import 'package:movil_home_pay/features/cuentas/data/datasources/cuenta_datasource.dart';

import '../../../../fixtures/cuenta/cuenta_fixture.dart';
import '../../../../fixtures/api_response.dart';
import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

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

  group('CuentaDatasource', () {
    group('getCuentasPorPeriodo', () {
      test('returns list of cuentas when API succeeds', () async {
        final cuentasJson = [
          CuentaFixture.createCuentaJson(id: 'cta_1', nombre: 'Netflix'),
          CuentaFixture.createCuentaJson(id: 'cta_2', nombre: 'Spotify'),
        ];
        final responseData = ApiResponseBuilder.success(data: cuentasJson);

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202404')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202404');

        expect(result, isA<List>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('cta_1'));
        expect(result[1].id, equals('cta_2'));
      });

      test('returns empty list when no cuentas exist', () async {
        final responseData = ApiResponseBuilder.success(data: []);

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202404')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202404');

        expect(result, isEmpty);
      });

      test('throws ArgumentError for invalid periodo format', () async {
        expect(
          () => datasource.getCuentasPorPeriodo('2024'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => datasource.getCuentasPorPeriodo('202400'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => datasource.getCuentasPorPeriodo('abcd12'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid year in periodo', () async {
        expect(
          () => datasource.getCuentasPorPeriodo('201901'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => datasource.getCuentasPorPeriodo('210101'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid month in periodo', () async {
        expect(
          () => datasource.getCuentasPorPeriodo('202400'),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => datasource.getCuentasPorPeriodo('202413'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('handles different data wrappers (data, billings, items)', () async {
        final cuentasJson = [
          CuentaFixture.createCuentaJson(id: 'cta_wrap'),
        ];

        // Test with 'billings' wrapper
        final responseData = {'billings': cuentasJson};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202404')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202404');
        expect(result.length, equals(1));
      });
    });

    group('getDetalle', () {
      test('calls direct endpoint /accounts/{accountId}/billings/{billingId}', () async {
        final cuentaJson = {
          'id': 'cta_direct',
          'account_id': 'acc_123',
          'account_name': 'Direct Service',
          'amount_billed': 15000.0,
          'amount_paid': 0.0,
          'is_paid': false,
          'status': 'pending',
          'period': '202404',
        };
        final responseData = {'billing': cuentaJson};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.accountBillingUrl('acc_123', 'cta_direct')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getDetalle('acc_123', 'cta_direct');

        expect(result.id, equals('cta_direct'));
        expect(result.nombre, equals('Direct Service'));
      });

      test('throws ArgumentError for invalid accountId characters', () async {
        expect(
          () => datasource.getDetalle('acc@invalid!', 'cta_001'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid cuentaId characters', () async {
        expect(
          () => datasource.getDetalle('acc_123', 'cta@invalid!'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for empty accountId', () async {
        expect(
          () => datasource.getDetalle('', 'cta_001'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for empty cuentaId', () async {
        expect(
          () => datasource.getDetalle('acc_123', ''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('registrarPago', () {
      test('returns true when payment registered successfully', () async {
        final responseData = {
          'billing': {'is_paid': true},
        };

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings/cta_001'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          15000.0,
        );

        expect(result, isTrue);
      });

      test('returns false when is_paid is false', () async {
        final responseData = {
          'billing': {'is_paid': false},
        };

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings/cta_001'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.registrarPago(
          'cta_001',
          'acc_123',
          15000.0,
          10000.0,
        );

        expect(result, isFalse);
      });

      test('throws ArgumentError for negative montoTotal', () async {
        expect(
          () => datasource.registrarPago('cta_001', 'acc_123', -100.0, 0.0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for negative montoPagado', () async {
        expect(
          () => datasource.registrarPago('cta_001', 'acc_123', 100.0, -50.0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for empty cuentaId', () async {
        expect(
          () => datasource.registrarPago('', 'acc_123', 100.0, 100.0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid cuentaId characters', () async {
        expect(
          () => datasource.registrarPago('cta@invalid!', 'acc_123', 100.0, 100.0),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('reopenAccount', () {
      test('returns true when account reopened successfully', () async {
        final responseData = {
          'billing': {'is_paid': false, 'amount_paid': 0},
        };

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings/cta_001'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.reopenAccount(
          'cta_001',
          'acc_123',
          15000.0,
        );

        expect(result, isTrue);
      });

      test('sends correct payload with amount_billed, amount_paid=0, is_paid=false', () async {
        final responseData = {
          'billing': {'is_paid': false, 'amount_paid': 0},
        };

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings/cta_001'),
          statusCode: 200,
          data: responseData,
        ));

        await datasource.reopenAccount('cta_001', 'acc_123', 15000.0);

        verify(() => mockDio.put(
          any(),
          data: predicate<Map<String, dynamic>>((data) {
            expect(data['amount_billed'], equals(15000.0));
            expect(data['amount_paid'], equals(0));
            expect(data['is_paid'], equals(false));
            return true;
          }),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).called(1);
      });

      test('returns false when API returns is_paid still true', () async {
        final responseData = {
          'billing': {'is_paid': true, 'amount_paid': 15000},
        };

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}/accounts/acc_123/billings/cta_001'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.reopenAccount(
          'cta_001',
          'acc_123',
          15000.0,
        );

        expect(result, isFalse);
      });

      test('throws ArgumentError for negative montoOriginal', () async {
        expect(
          () => datasource.reopenAccount('cta_001', 'acc_123', -100.0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for empty cuentaId', () async {
        expect(
          () => datasource.reopenAccount('', 'acc_123', 15000.0),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid cuentaId characters', () async {
        expect(
          () => datasource.reopenAccount('cta@invalid!', 'acc_123', 15000.0),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('_fromJson', () {
      test('parses Cuenta correctly from API response', () async {
        final cuentaJson = {
          'id': 'cta_parsed',
          'account_id': 'acc_parsed',
          'account_name': 'Parsed Service',
          'amount_billed': 20000.0,
          'amount_paid': 5000.0,
          'status': 'pending',
          'period': '202405',
        };
        final responseData = {'data': [cuentaJson]};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202405')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202405');

        expect(result[0].id, equals('cta_parsed'));
        expect(result[0].accountId, equals('acc_parsed'));
        expect(result[0].nombre, equals('Parsed Service'));
        expect(result[0].monto, equals(20000.0));
        expect(result[0].montoPagado, equals(5000.0));
        expect(result[0].estado, equals('pendiente'));
      });

      test('marks as pagada when is_paid is true', () async {
        final cuentaJson = {
          'id': 'cta_paid',
          'account_id': 'acc_123',
          'name': 'Paid Service',
          'amount_billed': 10000.0,
          'amount_paid': 10000.0,
          'is_paid': true,
          'status': 'paid',
          'period': '202405',
        };
        final responseData = {'data': [cuentaJson]};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202405')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202405');

        expect(result[0].estado, equals('pagada'));
        expect(result[0].isPaid, isTrue);
      });

      test('marks as vencida when status is overdue', () async {
        final cuentaJson = {
          'id': 'cta_overdue',
          'account_id': 'acc_456',
          'name': 'Overdue Service',
          'amount_billed': 30000.0,
          'amount_paid': 0.0,
          'status': 'overdue',
          'period': '202403',
        };
        final responseData = {'data': [cuentaJson]};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202403')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202403');

        expect(result[0].estado, equals('vencida'));
      });

      test('handles paid_at date parsing', () async {
        final cuentaJson = {
          'id': 'cta_dated',
          'account_id': 'acc_123',
          'name': 'Dated Service',
          'amount_billed': 15000.0,
          'amount_paid': 15000.0,
          'is_paid': true,
          'paid_at': '2024-04-15T10:30:00Z',
          'period': '202404',
        };
        final responseData = {'data': [cuentaJson]};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.periodBillingsUrl('202404')),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCuentasPorPeriodo('202404');

        expect(result[0].fechaPago, isNotNull);
      });
    });
  });
}