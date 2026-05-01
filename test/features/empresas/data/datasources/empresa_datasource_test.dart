import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/core/config/api_config.dart';
import 'package:movil_home_pay/features/empresas/data/datasources/empresa_datasource.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';

import '../../../../fixtures/empresa/empresa_fixture.dart';
import '../../../../fixtures/api_response.dart';
import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

void main() {
  late MockDio mockDio;
  late EmpresaDatasource datasource;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    datasource = EmpresaDatasource(mockDio);
  });

  group('EmpresaDatasource', () {
    group('getCompanies', () {
      test('returns PaginatedResult when API succeeds', () async {
        final empresasJson = [
          EmpresaFixture.createEmpresaJson(id: 'emp_1', name: 'Netflix'),
          EmpresaFixture.createEmpresaJson(id: 'emp_2', name: 'Spotify'),
        ];
        final responseData = ApiResponseBuilder.paginatedList(
          items: empresasJson,
          totalCount: 2,
        );

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.companiesUrl()),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCompanies(page: 1, pageSize: 20);

        expect(result.items, isA<List<Empresa>>());
        expect(result.items.length, equals(2));
        expect(result.totalCount, equals(2));
      });

      test('returns empty list when no companies exist', () async {
        final responseData = ApiResponseBuilder.emptyList();

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ApiConfig.companiesUrl()),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCompanies();

        expect(result.items, isEmpty);
        expect(result.totalCount, equals(0));
      });
    });

    group('getCompanyById', () {
      test('returns Empresa when found', () async {
        final empresaJson = EmpresaFixture.createEmpresaJson(
          id: 'emp_123',
          name: 'Netflix',
        );
        final responseData = ApiResponseBuilder.success(data: empresaJson);

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/emp_123'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCompanyById('emp_123');

        expect(result.id, equals('emp_123'));
        expect(result.name, equals('Netflix'));
      });

      test('throws ArgumentError for empty ID', () async {
        expect(
          () => datasource.getCompanyById(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for ID with invalid characters', () async {
        expect(
          () => datasource.getCompanyById('emp@123!'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError when empresa not found (null data)', () async {
        // Return null data to trigger ArgumentError in datasource
        final responseData = null;

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/emp_notfound'),
          statusCode: 200,
          data: responseData,
        ));

        expect(
          () => datasource.getCompanyById('emp_notfound'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('createCompany', () {
      test('creates company and returns created entity', () async {
        final empresa = EmpresaFixture.createValidEmpresa(
          id: 'emp_new',
          name: 'New Company',
        );
        final responseData = ApiResponseBuilder.success(
          data: EmpresaFixture.createEmpresaJson(
            id: 'emp_new',
            name: 'New Company',
          ),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}'),
          statusCode: 201,
          data: responseData,
        ));

        final result = await datasource.createCompany(empresa);

        expect(result.name, equals('New Company'));
      });

      test('throws ArgumentError for empty name', () async {
        final empresa = EmpresaFixture.createValidEmpresa(name: '   ');

        expect(
          () => datasource.createCompany(empresa),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid categoryId', () async {
        final empresa = EmpresaFixture.createValidEmpresa(categoryId: 0);

        expect(
          () => datasource.createCompany(empresa),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid website URL', () async {
        final empresa = EmpresaFixture.createValidEmpresa(
          website: 'not-a-valid-url',
        );

        expect(
          () => datasource.createCompany(empresa),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('accepts null website', () async {
        final empresa = EmpresaFixture.createValidEmpresa(website: null);
        final responseData = ApiResponseBuilder.success(
          data: EmpresaFixture.createEmpresaJson(
            name: 'Netflix',
            website: null,
          ),
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}'),
          statusCode: 201,
          data: responseData,
        ));

        final result = await datasource.createCompany(empresa);
        expect(result, isA<Empresa>());
      });
    });

    group('updateCompany', () {
      test('updates company and returns updated entity', () async {
        final empresa = EmpresaFixture.createValidEmpresa(
          id: 'emp_001',
          name: 'Updated Netflix',
        );
        final responseData = ApiResponseBuilder.success(
          data: EmpresaFixture.createEmpresaJson(
            id: 'emp_001',
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
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/emp_001'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.updateCompany(empresa);

        expect(result.name, equals('Updated Netflix'));
      });

      test('throws ArgumentError for empty ID', () async {
        final empresa = EmpresaFixture.createValidEmpresa(id: '');

        expect(
          () => datasource.updateCompany(empresa),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('deleteCompany', () {
      test('deletes company and returns true', () async {
        when(() => mockDio.delete(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '${ApiConfig.baseUrl}${ApiConfig.companiesPath}/emp_001'),
          statusCode: 204,
          data: null,
        ));

        final result = await datasource.deleteCompany('emp_001');

        expect(result, isTrue);
      });

      test('throws ArgumentError for empty ID', () async {
        expect(
          () => datasource.deleteCompany(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for ID with invalid characters', () async {
        expect(
          () => datasource.deleteCompany('emp@invalid'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}