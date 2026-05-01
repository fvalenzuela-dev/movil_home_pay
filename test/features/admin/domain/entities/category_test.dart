import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';

void main() {
  group('Category Entity', () {
    const testCategory = Category(
      id: 1,
      name: 'Streaming',
      iconName: 'netflix',
      createdAt: null,
      updatedAt: null,
    );

    test('creates Category with all fields', () {
      expect(testCategory.id, 1);
      expect(testCategory.name, 'Streaming');
      expect(testCategory.iconName, 'netflix');
    });

    test('creates Category with optional fields null', () {
      const category = Category(
        id: 2,
        name: 'Servicios',
      );

      expect(category.iconName, isNull);
      expect(category.createdAt, isNull);
      expect(category.updatedAt, isNull);
    });

    group('icon', () {
      test('returns correct icon for netflix', () {
        expect(testCategory.icon, Icons.movie);
      });

      test('returns correct icon for spotify', () {
        const category = Category(
          id: 3,
          name: 'Música',
          iconName: 'spotify',
        );
        expect(category.icon, Icons.music_note);
      });

      test('returns correct icon for agua', () {
        const category = Category(
          id: 4,
          name: 'Agua',
          iconName: 'agua',
        );
        expect(category.icon, Icons.water_drop);
      });

      test('returns default icon for null iconName', () {
        const category = Category(
          id: 5,
          name: 'Otro',
        );
        expect(category.icon, Icons.category);
      });

      test('returns default icon for empty iconName', () {
        const category = Category(
          id: 6,
          name: 'Otro',
          iconName: '',
        );
        expect(category.icon, Icons.category);
      });

      test('returns default icon for unknown iconName', () {
        const category = Category(
          id: 7,
          name: 'Otro',
          iconName: 'unknown_icon',
        );
        expect(category.icon, Icons.category);
      });

      test('is case insensitive for iconName', () {
        const category = Category(
          id: 8,
          name: 'Netflix',
          iconName: 'NETFLIX',
        );
        expect(category.icon, Icons.movie);
      });
    });

    group('copyWith', () {
      test('creates copy with modified name', () {
        final updated = testCategory.copyWith(name: 'Nuevo Nombre');

        expect(updated.name, 'Nuevo Nombre');
        expect(updated.id, testCategory.id);
        expect(updated.iconName, testCategory.iconName);
      });

      test('creates copy with modified iconName', () {
        final updated = testCategory.copyWith(iconName: 'spotify');

        expect(updated.iconName, 'spotify');
        expect(updated.name, testCategory.name);
      });

      test('keeps original values when no parameters provided', () {
        final copy = testCategory.copyWith();

        expect(copy.id, testCategory.id);
        expect(copy.name, testCategory.name);
        expect(copy.iconName, testCategory.iconName);
      });
    });

    group('props', () {
      test('two categories with same values are equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
          iconName: 'netflix',
        );
        const category2 = Category(
          id: 1,
          name: 'Streaming',
          iconName: 'netflix',
        );

        expect(category1, equals(category2));
      });

      test('two categories with different values are not equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
        );
        const category2 = Category(
          id: 2,
          name: 'Streaming',
        );

        expect(category1, isNot(equals(category2)));
      });

      test('categories with different iconName are not equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
          iconName: 'netflix',
        );
        const category2 = Category(
          id: 1,
          name: 'Streaming',
          iconName: 'spotify',
        );

        expect(category1, isNot(equals(category2)));
      });
    });
  });

  group('CategoryIcons', () {
    test('getIcon returns correct icon for known name', () {
      expect(CategoryIcons.getIcon('netflix'), Icons.movie);
      expect(CategoryIcons.getIcon('spotify'), Icons.music_note);
      expect(CategoryIcons.getIcon('agua'), Icons.water_drop);
      expect(CategoryIcons.getIcon('luz'), Icons.bolt);
      expect(CategoryIcons.getIcon('gas'), Icons.local_fire_department);
    });

    test('getIcon returns default for null', () {
      expect(CategoryIcons.getIcon(null), Icons.category);
    });

    test('getIcon returns default for empty string', () {
      expect(CategoryIcons.getIcon(''), Icons.category);
    });

    test('getIcon returns default for unknown name', () {
      expect(CategoryIcons.getIcon('unknown'), Icons.category);
    });

    test('getIcon is case insensitive', () {
      expect(CategoryIcons.getIcon('NETFLIX'), Icons.movie);
      expect(CategoryIcons.getIcon('Netflix'), Icons.movie);
      expect(CategoryIcons.getIcon('netflix'), Icons.movie);
    });

    test('iconNames returns all available icon names', () {
      final names = CategoryIcons.iconNames;
      expect(names, contains('netflix'));
      expect(names, contains('spotify'));
      expect(names, contains('agua'));
      expect(names, contains('luz'));
      expect(names, contains('gas'));
      expect(names, contains('internet'));
      expect(names.length, greaterThan(20));
    });
  });
}
