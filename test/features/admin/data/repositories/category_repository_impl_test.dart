import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/admin/data/datasources/category_datasource.dart';
import 'package:movil_home_pay/features/admin/data/repositories/category_repository_impl.dart';

import '../../../../fixtures/admin/category_fixture.dart';

class MockCategoryDatasource extends Mock implements CategoryDatasource {}

void main() {
  late MockCategoryDatasource mockDatasource;
  late CategoryRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockCategoryDatasource();
    repository = CategoryRepositoryImpl(mockDatasource);
  });

  group('CategoryRepositoryImpl', () {
    group('getCategories', () {
      test('delegates to datasource with correct parameters', () async {
        final categories = [
          CategoryFixture.createValidCategory(id: 1),
          CategoryFixture.createValidCategory(id: 2),
        ];

        when(() => mockDatasource.getCategories(page: 1, limit: 20))
            .thenAnswer((_) async => categories);

        final result = await repository.getCategories(page: 1, limit: 20);

        expect(result.length, equals(2));
        expect(result[0].id, equals(1));
        verify(() => mockDatasource.getCategories(page: 1, limit: 20)).called(1);
      });

      test('returns empty list when no categories', () async {
        when(() => mockDatasource.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) async => []);

        final result = await repository.getCategories();

        expect(result, isEmpty);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenThrow(Exception('Network error'));

        expect(
          () => repository.getCategories(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCategoryById', () {
      test('delegates to datasource with correct id', () async {
        final category = CategoryFixture.createValidCategory(id: 42);

        when(() => mockDatasource.getCategoryById(42))
            .thenAnswer((_) async => category);

        final result = await repository.getCategoryById(42);

        expect(result.id, equals(42));
        verify(() => mockDatasource.getCategoryById(42)).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.getCategoryById(any()))
            .thenThrow(Exception('Not found'));

        expect(
          () => repository.getCategoryById(999),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createCategory', () {
      test('delegates to datasource with correct name', () async {
        final category = CategoryFixture.createValidCategory(name: 'New Category');

        when(() => mockDatasource.createCategory('New Category'))
            .thenAnswer((_) async => category);

        final result = await repository.createCategory('New Category');

        expect(result.name, equals('New Category'));
        verify(() => mockDatasource.createCategory('New Category')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.createCategory(any()))
            .thenThrow(Exception('Validation error'));

        expect(
          () => repository.createCategory(''),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateCategory', () {
      test('delegates to datasource with correct id and name', () async {
        final category = CategoryFixture.createValidCategory(id: 1, name: 'Updated');

        when(() => mockDatasource.updateCategory(1, 'Updated'))
            .thenAnswer((_) async => category);

        final result = await repository.updateCategory(1, 'Updated');

        expect(result.name, equals('Updated'));
        verify(() => mockDatasource.updateCategory(1, 'Updated')).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.updateCategory(any(), any()))
            .thenThrow(Exception('Update failed'));

        expect(
          () => repository.updateCategory(1, 'Name'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteCategory', () {
      test('delegates to datasource with correct id', () async {
        when(() => mockDatasource.deleteCategory(1))
            .thenAnswer((_) async {});

        await repository.deleteCategory(1);

        verify(() => mockDatasource.deleteCategory(1)).called(1);
      });

      test('forwards exceptions from datasource', () async {
        when(() => mockDatasource.deleteCategory(any()))
            .thenThrow(Exception('Delete failed'));

        expect(
          () => repository.deleteCategory(1),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}