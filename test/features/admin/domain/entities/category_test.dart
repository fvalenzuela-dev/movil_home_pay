import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';

void main() {
  group('Category Entity', () {
    const testCategory = Category(
      id: 1,
      name: 'Streaming',
      iconApk: 'netflix',
      iconWeb: 'netflix',
      colorApk: 'primary',
      colorWeb: 'primary',
      createdAt: null,
      updatedAt: null,
    );

    test('creates Category with all fields', () {
      expect(testCategory.id, 1);
      expect(testCategory.name, 'Streaming');
      expect(testCategory.iconApk, 'netflix');
      expect(testCategory.iconWeb, 'netflix');
      expect(testCategory.colorApk, 'primary');
      expect(testCategory.colorWeb, 'primary');
    });

    test('creates Category with optional fields null', () {
      const category = Category(
        id: 2,
        name: 'Servicios',
      );

      expect(category.iconApk, isNull);
      expect(category.iconWeb, isNull);
      expect(category.colorApk, isNull);
      expect(category.colorWeb, isNull);
      expect(category.createdAt, isNull);
      expect(category.updatedAt, isNull);
    });

    group('icon', () {
      test('returns correct icon for netflix via iconApk', () {
        expect(testCategory.icon, Icons.movie);
      });

      test('returns correct icon for spotify', () {
        const category = Category(
          id: 3,
          name: 'Música',
          iconApk: 'spotify',
        );
        expect(category.icon, Icons.music_note);
      });

      test('returns correct icon for agua', () {
        const category = Category(
          id: 4,
          name: 'Agua',
          iconApk: 'agua',
        );
        expect(category.icon, Icons.water_drop);
      });

      test('returns default icon for null iconApk', () {
        const category = Category(
          id: 5,
          name: 'Otro',
        );
        expect(category.icon, Icons.category);
      });

      test('returns default icon for empty iconApk', () {
        const category = Category(
          id: 6,
          name: 'Otro',
          iconApk: '',
        );
        expect(category.icon, Icons.category);
      });

      test('returns default icon for unknown iconApk', () {
        const category = Category(
          id: 7,
          name: 'Otro',
          iconApk: 'unknown_icon',
        );
        expect(category.icon, Icons.category);
      });

      test('is case insensitive for iconApk', () {
        const category = Category(
          id: 8,
          name: 'Netflix',
          iconApk: 'NETFLIX',
        );
        expect(category.icon, Icons.movie);
      });
    });

    group('categoryColor', () {
      test('returns correct color for primary', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'primary',
        );
        // primary maps to primarySeed which is Color(0xFF2563EB)
        expect(category.categoryColor, const Color(0xFF2563EB));
      });

      test('returns correct color for secondary', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'secondary',
        );
        // secondary maps to secondarySeed which is Color(0xFF10B981)
        expect(category.categoryColor, const Color(0xFF10B981));
      });

      test('returns correct color for error', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'error',
        );
        expect(category.categoryColor, const Color(0xFFBA1A1A));
      });

      test('returns correct color for success', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'success',
        );
        expect(category.categoryColor, const Color(0xFF10B981));
      });

      test('returns correct color for warning', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'warning',
        );
        expect(category.categoryColor, const Color(0xFF2563EB));
      });

      test('returns correct color for tertiary', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'tertiary',
        );
        expect(category.categoryColor, const Color(0xFFF59E0B));
      });

      test('returns null for unknown colorApiName', () {
        const category = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'unknown',
        );
        expect(category.categoryColor, isNull);
      });
    });

    group('copyWith', () {
      test('creates copy with modified name', () {
        final updated = testCategory.copyWith(name: 'Nuevo Nombre');

        expect(updated.name, 'Nuevo Nombre');
        expect(updated.id, testCategory.id);
        expect(updated.iconApk, testCategory.iconApk);
      });

      test('creates copy with modified iconApk', () {
        final updated = testCategory.copyWith(iconApk: 'spotify');

        expect(updated.iconApk, 'spotify');
        expect(updated.name, testCategory.name);
      });

      test('creates copy with modified iconWeb', () {
        final updated = testCategory.copyWith(iconWeb: 'spotify_web');

        expect(updated.iconWeb, 'spotify_web');
        expect(updated.name, testCategory.name);
      });

      test('creates copy with modified colorApk', () {
        final updated = testCategory.copyWith(colorApk: 'secondary');

        expect(updated.colorApk, 'secondary');
        expect(updated.name, testCategory.name);
      });

      test('creates copy with modified colorWeb', () {
        final updated = testCategory.copyWith(colorWeb: 'error');

        expect(updated.colorWeb, 'error');
        expect(updated.name, testCategory.name);
      });

      test('keeps original values when no parameters provided', () {
        final copy = testCategory.copyWith();

        expect(copy.id, testCategory.id);
        expect(copy.name, testCategory.name);
        expect(copy.iconApk, testCategory.iconApk);
        expect(copy.iconWeb, testCategory.iconWeb);
        expect(copy.colorApk, testCategory.colorApk);
        expect(copy.colorWeb, testCategory.colorWeb);
      });
    });

    group('props', () {
      test('two categories with same values are equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
          iconApk: 'netflix',
          iconWeb: 'netflix',
          colorApk: 'primary',
          colorWeb: 'primary',
        );
        const category2 = Category(
          id: 1,
          name: 'Streaming',
          iconApk: 'netflix',
          iconWeb: 'netflix',
          colorApk: 'primary',
          colorWeb: 'primary',
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

      test('categories with different iconApk are not equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
          iconApk: 'netflix',
        );
        const category2 = Category(
          id: 1,
          name: 'Streaming',
          iconApk: 'spotify',
        );

        expect(category1, isNot(equals(category2)));
      });

      test('categories with different colorApk are not equal', () {
        const category1 = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'primary',
        );
        const category2 = Category(
          id: 1,
          name: 'Streaming',
          colorApk: 'secondary',
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

  group('CategoryColor', () {
    test('has correct enum values', () {
      expect(CategoryColor.values.length, 6);
      expect(CategoryColor.values, contains(CategoryColor.catPrimary));
      expect(CategoryColor.values, contains(CategoryColor.catSecondary));
      expect(CategoryColor.values, contains(CategoryColor.catError));
      expect(CategoryColor.values, contains(CategoryColor.catSuccess));
      expect(CategoryColor.values, contains(CategoryColor.catWarning));
      expect(CategoryColor.values, contains(CategoryColor.catTertiary));
    });

    group('colorValue getter', () {
      test('catPrimary returns primarySeed color', () {
        expect(CategoryColor.catPrimary.colorValue, const Color(0xFF2563EB));
      });

      test('catSecondary returns secondarySeed color', () {
        expect(CategoryColor.catSecondary.colorValue, const Color(0xFF10B981));
      });

      test('catError returns errorColor', () {
        expect(CategoryColor.catError.colorValue, const Color(0xFFBA1A1A));
      });

      test('catSuccess returns successColor', () {
        expect(CategoryColor.catSuccess.colorValue, const Color(0xFF10B981));
      });

      test('catWarning returns warningColor', () {
        expect(CategoryColor.catWarning.colorValue, const Color(0xFF2563EB));
      });

      test('catTertiary returns tertiaryColor', () {
        expect(CategoryColor.catTertiary.colorValue, const Color(0xFFF59E0B));
      });
    });

    group('apiName getter', () {
      test('catPrimary returns primary', () {
        expect(CategoryColor.catPrimary.apiName, 'primary');
      });

      test('catSecondary returns secondary', () {
        expect(CategoryColor.catSecondary.apiName, 'secondary');
      });

      test('catError returns error', () {
        expect(CategoryColor.catError.apiName, 'error');
      });

      test('catSuccess returns success', () {
        expect(CategoryColor.catSuccess.apiName, 'success');
      });

      test('catWarning returns warning', () {
        expect(CategoryColor.catWarning.apiName, 'warning');
      });

      test('catTertiary returns tertiary', () {
        expect(CategoryColor.catTertiary.apiName, 'tertiary');
      });
    });

    group('fromApiName', () {
      test('parses primary correctly', () {
        expect(CategoryColorExtension.fromApiName('primary'), CategoryColor.catPrimary);
      });

      test('parses secondary correctly', () {
        expect(CategoryColorExtension.fromApiName('secondary'), CategoryColor.catSecondary);
      });

      test('parses error correctly', () {
        expect(CategoryColorExtension.fromApiName('error'), CategoryColor.catError);
      });

      test('parses success correctly', () {
        expect(CategoryColorExtension.fromApiName('success'), CategoryColor.catSuccess);
      });

      test('parses warning correctly', () {
        expect(CategoryColorExtension.fromApiName('warning'), CategoryColor.catWarning);
      });

      test('parses tertiary correctly', () {
        expect(CategoryColorExtension.fromApiName('tertiary'), CategoryColor.catTertiary);
      });

      test('is case insensitive', () {
        expect(CategoryColorExtension.fromApiName('PRIMARY'), CategoryColor.catPrimary);
        expect(CategoryColorExtension.fromApiName('Primary'), CategoryColor.catPrimary);
        expect(CategoryColorExtension.fromApiName('secondary'), CategoryColor.catSecondary);
      });

      test('returns null for unknown value', () {
        expect(CategoryColorExtension.fromApiName('unknown'), isNull);
      });

      test('returns null for null input', () {
        expect(CategoryColorExtension.fromApiName(null), isNull);
      });

      test('returns null for empty string', () {
        expect(CategoryColorExtension.fromApiName(''), isNull);
      });
    });
  });

  group('CategoryColorExtension', () {
    test('extension methods work correctly', () {
      expect(CategoryColor.catPrimary.apiName, 'primary');
      expect(CategoryColor.catPrimary.colorValue, const Color(0xFF2563EB));
    });
  });
}