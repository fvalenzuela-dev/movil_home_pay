import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/admin/data/datasources/category_datasource.dart';

import '../../../../fixtures/admin/category_fixture.dart';
import '../../../../fixtures/api_response.dart';
import '../../../../helpers/mock_dio.dart';
import '../../../../helpers/test_bootstrap.dart';

void main() {
  late MockDio mockDio;
  late CategoryDatasource datasource;

  setUpAll(() {
    bootstrapTests();
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    mockDio = MockDio();
    datasource = CategoryDatasource(mockDio);
  });

  group('CategoryDatasource', () {
    group('getCategories', () {
      test('returns list of categories when API succeeds', () async {
        final categoriesJson = [
          CategoryFixture.createCategoryJson(id: 1, name: 'Streaming'),
          CategoryFixture.createCategoryJson(id: 2, name: 'Utilities'),
        ];
        final responseData = ApiResponseBuilder.success(data: categoriesJson);

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCategories();

        expect(result, isA<List>());
        expect(result.length, equals(2));
        expect(result[0].id, equals(1));
        expect(result[0].name, equals('Streaming'));
      });

      test('returns empty list when no categories exist', () async {
        final responseData = ApiResponseBuilder.success(data: []);

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCategories();

        expect(result, isEmpty);
      });

      test('handles different data wrappers (data, categories, items)', () async {
        final categoriesJson = [
          CategoryFixture.createCategoryJson(id: 10, name: 'Test'),
        ];

        // Test with 'categories' wrapper
        final responseData = {'categories': categoriesJson};

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCategories();
        expect(result.length, equals(1));
      });
    });

    group('getCategoryById', () {
      test('returns Category when found', () async {
        final responseData = ApiResponseBuilder.categoryResponse(
          id: 1,
          name: 'Streaming',
          iconName: 'netflix',
        );

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories/1'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.getCategoryById(1);

        expect(result.id, equals(1));
        expect(result.name, equals('Streaming'));
      });
    });

    group('createCategory', () {
      test('creates category and returns created entity', () async {
        final responseData = ApiResponseBuilder.categoryResponse(
          id: 99,
          name: 'New Category',
        );

        when(() => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 201,
          data: responseData,
        ));

        final result = await datasource.createCategory('New Category');

        expect(result.name, equals('New Category'));
      });
    });

    group('updateCategory', () {
      test('updates category and returns updated entity', () async {
        final responseData = ApiResponseBuilder.categoryResponse(
          id: 1,
          name: 'Updated Name',
        );

        when(() => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories/1'),
          statusCode: 200,
          data: responseData,
        ));

        final result = await datasource.updateCategory(1, 'Updated Name');

        expect(result.name, equals('Updated Name'));
      });
    });

    group('deleteCategory', () {
      test('deletes category without error', () async {
        when(() => mockDio.delete(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories/1'),
          statusCode: 204,
          data: null,
        ));

        await expectLater(
          datasource.deleteCategory(1),
          completes,
        );
      });
    });

    group('_fromJson', () {
      test('parses Category correctly with data wrapper', () async {
        final categoryJson = {
          'data': {
            'id': 5,
            'name': 'Parsed Category',
            'icon_name': 'test',
            'created_at': '2024-01-15T00:00:00Z',
            'updated_at': '2024-01-15T00:00:00Z',
          }
        };

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: {'data': [categoryJson]},
        ));

        final result = await datasource.getCategories();

        expect(result[0].name, equals('Parsed Category'));
      });

      test('handles string ID and converts to int', () async {
        final categoryJson = {
          'id': '10', // String instead of int
          'name': 'String ID Category',
        };

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: {'data': [categoryJson]},
        ));

        final result = await datasource.getCategories();

        expect(result[0].id, equals(10));
      });

      test('handles null created_at and updated_at', () async {
        final categoryJson = {
          'id': 1,
          'name': 'No Dates Category',
          'created_at': null,
          'updated_at': null,
        };

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: {'data': [categoryJson]},
        ));

        final result = await datasource.getCategories();

        expect(result[0].createdAt, isNull);
        expect(result[0].updatedAt, isNull);
      });

      test('handles missing name gracefully', () async {
        final categoryJson = {
          'id': 1,
          // no name field
        };

        when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/categories'),
          statusCode: 200,
          data: {'data': [categoryJson]},
        ));

        final result = await datasource.getCategories();

        expect(result[0].name, equals(''));
      });
    });
  });
}