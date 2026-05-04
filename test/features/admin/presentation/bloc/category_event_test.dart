import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/presentation/bloc/category_event.dart';

void main() {
  group('CategoryEvent', () {
    test('CategoriesLoadRequested has correct props', () {
      const event1 = CategoriesLoadRequested();
      const event2 = CategoriesLoadRequested();

      expect(event1.props, isEmpty);
      expect(event1, equals(event2));
    });

    test('CategoryCreateRequested has correct props including name and iconApk', () {
      const event1 = CategoryCreateRequested('Utilities', iconApk: 'luz');
      const event2 = CategoryCreateRequested('Utilities', iconApk: 'luz');
      const event3 = CategoryCreateRequested('Utilities'); // without iconApk
      const event4 = CategoryCreateRequested('Entertainment', iconApk: 'netflix');

      expect(event1.props, ['Utilities', 'luz', null]);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3))); // different iconApk
      expect(event1, isNot(equals(event4))); // different name
    });

    test('CategoryCreateRequested with null iconApk', () {
      const event = CategoryCreateRequested('Utilities');
      expect(event.props, ['Utilities', null, null]);
    });

    test('CategoryUpdateRequested has correct props', () {
      const event1 = CategoryUpdateRequested(1, 'Utilities', iconApk: 'luz');
      const event2 = CategoryUpdateRequested(1, 'Utilities', iconApk: 'luz');
      const event3 = CategoryUpdateRequested(2, 'Utilities', iconApk: 'luz'); // different id
      const event4 = CategoryUpdateRequested(1, 'Entertainment', iconApk: 'luz'); // different name

      expect(event1.props, [1, 'Utilities', 'luz', null]);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3))); // different id
      expect(event1, isNot(equals(event4))); // different name
    });

    test('CategoryUpdateRequested with null iconApk', () {
      const event = CategoryUpdateRequested(1, 'Utilities');
      expect(event.props, [1, 'Utilities', null, null]);
    });

    test('CategoryDeleteRequested has correct props', () {
      const event1 = CategoryDeleteRequested(1);
      const event2 = CategoryDeleteRequested(1);
      const event3 = CategoryDeleteRequested(2);

      expect(event1.props, [1]);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });

    group('CategoriesLoadRequested', () {
      test('supports value equality', () {
        const event1 = CategoriesLoadRequested();
        const event2 = CategoriesLoadRequested();
        expect(event1, equals(event2));
      });
    });

    group('CategoryCreateRequested edge cases', () {
      test('handles special characters in name', () {
        const event = CategoryCreateRequested('Utilities & Services');
        expect(event.name, 'Utilities & Services');
      });

      test('handles empty string for name', () {
        const event = CategoryCreateRequested('');
        expect(event.name, '');
      });

      test('iconApk accepts all valid icon names', () {
        const event1 = CategoryCreateRequested('Name', iconApk: 'netflix');
        const event2 = CategoryCreateRequested('Name', iconApk: 'spotify');
        const event3 = CategoryCreateRequested('Name', iconApk: 'agua');

        expect(event1.iconApk, 'netflix');
        expect(event2.iconApk, 'spotify');
        expect(event3.iconApk, 'agua');
      });
    });

    group('CategoryUpdateRequested edge cases', () {
      test('handles id of 0', () {
        const event = CategoryDeleteRequested(0);
        expect(event.id, 0);
      });

      test('handles negative id', () {
        const event = CategoryDeleteRequested(-1);
        expect(event.id, -1);
      });

      test('handles very large id', () {
        const event = CategoryDeleteRequested(999999999);
        expect(event.id, 999999999);
      });
    });
  });
}
