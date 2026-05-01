import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';
import 'package:movil_home_pay/features/admin/presentation/bloc/category_state.dart';

void main() {
  group('CategoryState', () {
    test('CategoryInitial supports value equality', () {
      final state1 = CategoryInitial();
      final state2 = CategoryInitial();

      expect(state1.props, isEmpty);
      expect(state1, equals(state2));
    });

    test('CategoryLoading supports value equality', () {
      final state1 = CategoryLoading();
      final state2 = CategoryLoading();

      expect(state1.props, isEmpty);
      expect(state1, equals(state2));
    });

    test('CategoriesLoaded contains categories list and supports value equality', () {
      final categories = [
        Category(
          id: 1,
          name: 'Utilities',
          iconName: 'luz',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];
      final state1 = CategoriesLoaded(categories);
      final state2 = CategoriesLoaded(categories);
      final state3 = CategoriesLoaded([]);

      expect(state1.props, [categories]);
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('CategoriesLoaded handles empty list', () {
      final state = CategoriesLoaded([]);

      expect(state.categories, isEmpty);
      expect(state.props, [[]]);
    });

    test('CategoryError contains message and supports value equality', () {
      final state1 = CategoryError('Failed to load');
      final state2 = CategoryError('Failed to load');
      final state3 = CategoryError('Different error');

      expect(state1.props, ['Failed to load']);
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('CategoryError handles empty message', () {
      final state = CategoryError('');

      expect(state.message, '');
    });

    test('CategoryCreated contains category and supports value equality', () {
      final category = Category(
        id: 1,
        name: 'Utilities',
        iconName: 'luz',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      final state1 = CategoryCreated(category);
      final state2 = CategoryCreated(category);
      final state3 = CategoryCreated(Category(
        id: 2,
        name: 'Utilities',
        iconName: 'luz',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ));

      expect(state1.props, [category]);
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3))); // different category id
    });

    test('CategoryUpdated contains category and supports value equality', () {
      final category = Category(
        id: 1,
        name: 'Utilities',
        iconName: 'luz',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      final state1 = CategoryUpdated(category);
      final state2 = CategoryUpdated(category);

      expect(state1.props, [category]);
      expect(state1, equals(state2));
    });

    test('CategoryDeleted contains id and supports value equality', () {
      final state1 = CategoryDeleted(1);
      final state2 = CategoryDeleted(1);
      final state3 = CategoryDeleted(2);

      expect(state1.props, [1]);
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    group('CategoriesLoaded edge cases', () {
      test('handles single category', () {
        final categories = [
          Category(id: 1, name: 'Utilities', iconName: 'luz'),
        ];
        final state = CategoriesLoaded(categories);

        expect(state.categories.length, 1);
        expect(state.categories.first.name, 'Utilities');
      });

      test('handles many categories', () {
        final categories = List.generate(
          100,
          (i) => Category(id: i, name: 'Category $i', iconName: 'luz'),
        );
        final state = CategoriesLoaded(categories);

        expect(state.categories.length, 100);
      });

      test('categories list is mutable but props is immutable', () {
        final categories = [
          Category(id: 1, name: 'Utilities', iconName: 'luz'),
        ];
        final state = CategoriesLoaded(categories);

        // The categories list inside props should be the same reference
        expect(state.props[0], same(categories));
      });
    });

    group('CategoryDeleted edge cases', () {
      test('handles id of 0', () {
        final state = CategoryDeleted(0);
        expect(state.id, 0);
      });

      test('handles negative id', () {
        final state = CategoryDeleted(-1);
        expect(state.id, -1);
      });
    });
  });
}
