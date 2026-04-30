import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/empresas/data/datasources/empresa_datasource.dart';
import 'package:movil_home_pay/features/empresas/data/repositories/empresa_repository_impl.dart';
import 'package:movil_home_pay/features/empresas/domain/entities/empresa.dart';
import 'package:movil_home_pay/features/empresas/domain/repositories/empresa_repository.dart';

import '../../../../fixtures/empresa/empresa_fixture.dart';

class MockEmpresaDatasource extends Mock implements EmpresaDatasource {}

class FakeEmpresa extends Fake implements Empresa {}

void main() {
  late MockEmpresaDatasource mockDatasource;
  late EmpresaRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeEmpresa());
  });

  setUp(() {
    mockDatasource = MockEmpresaDatasource();
    repository = EmpresaRepositoryImpl(mockDatasource);
  });

  group('EmpresaRepositoryImpl', () {
    group('getCompanies', () {
      test('delegates to datasource with correct parameters', () async {
        final paginatedResult = PaginatedResult<Empresa>(
          items: [
            EmpresaFixture.createValidEmpresa(id: 'emp_1'),
            EmpresaFixture.createValidEmpresa(id: 'emp_2'),
          ],
          totalCount: 2,
          currentPage: 1,
          totalPages: 1,
        );

        when(() => mockDatasource.getCompanies(page: 1, pageSize: 20))
            .thenAnswer((_) async => paginatedResult);

        final result = await repository.getCompanies(page: 1, pageSize: 20);

        expect(result.items.length, equals(2));
        expect(result.totalCount, equals(2));
        verify(() => mockDatasource.getCompanies(page: 1, pageSize: 20)).called(1);
      });

      test('returns empty result when no companies', () async {
        final paginatedResult = PaginatedResult<Empresa>(
          items: [],
          totalCount: 0,
          currentPage: 1,
          totalPages: 0,
        );

        when(() => mockDatasource.getCompanies(page: 1, pageSize: 20))
            .thenAnswer((_) async => paginatedResult);

        final result = await repository.getCompanies();

        expect(result.items, isEmpty);
        expect(result.totalCount, equals(0));
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getCompanies(page: any(named: 'page'), pageSize: any(named: 'pageSize')))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.getCompanies(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCompanyById', () {
      test('delegates to datasource with correct ID', () async {
        final empresa = EmpresaFixture.createValidEmpresa(id: 'emp_123');
        when(() => mockDatasource.getCompanyById('emp_123'))
            .thenAnswer((_) async => empresa);

        final result = await repository.getCompanyById('emp_123');

        expect(result.id, equals('emp_123'));
        verify(() => mockDatasource.getCompanyById('emp_123')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getCompanyById(any()))
            .thenThrow(Exception('Not found'));

        expect(
          () => repository.getCompanyById('invalid_id'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createCompany', () {
      test('delegates to datasource with correct empresa', () async {
        final empresa = EmpresaFixture.createValidEmpresa(name: 'New Company');
        final createdEmpresa = empresa.copyWith(id: 'emp_new');

        when(() => mockDatasource.createCompany(empresa))
            .thenAnswer((_) async => createdEmpresa);

        final result = await repository.createCompany(empresa);

        expect(result.id, equals('emp_new'));
        expect(result.name, equals('New Company'));
        verify(() => mockDatasource.createCompany(empresa)).called(1);
      });

      test('forwards exceptions from datasource', () async {
        final empresa = EmpresaFixture.createValidEmpresa();

        when(() => mockDatasource.createCompany(any()))
            .thenThrow(Exception('Validation error'));

        expect(
          () => repository.createCompany(empresa),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateCompany', () {
      test('delegates to datasource with correct empresa', () async {
        final empresa = EmpresaFixture.createValidEmpresa(id: 'emp_001', name: 'Updated');
        final updatedEmpresa = empresa.copyWith(name: 'Updated');

        when(() => mockDatasource.updateCompany(empresa))
            .thenAnswer((_) async => updatedEmpresa);

        final result = await repository.updateCompany(empresa);

        expect(result.name, equals('Updated'));
        verify(() => mockDatasource.updateCompany(empresa)).called(1);
      });

      test('forwards exceptions from datasource', () async {
        final empresa = EmpresaFixture.createValidEmpresa();

        when(() => mockDatasource.updateCompany(any()))
            .thenThrow(Exception('Update failed'));

        expect(
          () => repository.updateCompany(empresa),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteCompany', () {
      test('delegates to datasource with correct ID and returns true', () async {
        when(() => mockDatasource.deleteCompany('emp_001'))
            .thenAnswer((_) async => true);

        final result = await repository.deleteCompany('emp_001');

        expect(result, isTrue);
        verify(() => mockDatasource.deleteCompany('emp_001')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.deleteCompany(any()))
            .thenThrow(Exception('Delete failed'));

        expect(
          () => repository.deleteCompany('emp_invalid'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}