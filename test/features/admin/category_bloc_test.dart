import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';
import 'package:movil_home_pay/features/admin/domain/repositories/category_repository.dart';
import 'package:movil_home_pay/features/admin/presentation/bloc/category_bloc.dart';
import 'package:movil_home_pay/features/admin/presentation/bloc/category_event.dart';
import 'package:movil_home_pay/features/admin/presentation/bloc/category_state.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
  });

  final testCategory = Category(
    id: 1,
    name: 'Utilities',
    iconName: 'luz',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  group('CategoryBloc', () {
    test('initial state is CategoryInitial', () {
      final bloc = CategoryBloc(mockRepository);
      expect(bloc.state, isA<CategoryInitial>());
      bloc.close();
    });

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoriesLoaded] when CategoriesLoadRequested succeeds',
      setUp: () {
        when(() => mockRepository.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) async => [testCategory]);
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoriesLoadRequested()),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoriesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.getCategories(page: 1, limit: 20)).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoryError] when CategoriesLoadRequested fails',
      setUp: () {
        when(() => mockRepository.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenThrow(Exception('Failed to load categories'));
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoriesLoadRequested()),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryError>(),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoryCreated, CategoriesLoaded] when CategoryCreateRequested succeeds',
      setUp: () {
        when(() => mockRepository.createCategory(any()))
            .thenAnswer((_) async => testCategory);
        when(() => mockRepository.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) async => [testCategory]);
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoryCreateRequested('Utilities')),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryCreated>(),
        isA<CategoriesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.createCategory('Utilities')).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoryError] when CategoryCreateRequested fails',
      setUp: () {
        when(() => mockRepository.createCategory(any()))
            .thenThrow(Exception('Duplicate category'));
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoryCreateRequested('Utilities')),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryError>(),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoryUpdated, CategoriesLoaded] when CategoryUpdateRequested succeeds',
      setUp: () {
        when(() => mockRepository.updateCategory(any(), any()))
            .thenAnswer((_) async => testCategory);
        when(() => mockRepository.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) async => [testCategory]);
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoryUpdateRequested(1, 'Utilities')),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryUpdated>(),
        isA<CategoriesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.updateCategory(1, 'Utilities')).called(1);
      },
    );

    blocTest<CategoryBloc, CategoryState>(
      'emits [CategoryLoading, CategoryDeleted, CategoriesLoaded] when CategoryDeleteRequested succeeds',
      setUp: () {
        when(() => mockRepository.deleteCategory(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getCategories(page: any(named: 'page'), limit: any(named: 'limit')))
            .thenAnswer((_) async => []);
      },
      build: () => CategoryBloc(mockRepository),
      act: (bloc) => bloc.add(const CategoryDeleteRequested(1)),
      expect: () => [
        isA<CategoryLoading>(),
        isA<CategoryDeleted>(),
        isA<CategoriesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteCategory(1)).called(1);
      },
    );
  });
}
