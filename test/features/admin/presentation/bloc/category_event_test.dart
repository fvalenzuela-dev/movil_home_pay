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

    test('CategoryCreateRequested has correct props including name and iconName', () {
      const event1 = CategoryCreateRequested('Utilities', 'luz');
      const event2 = CategoryCreateRequested('Utilities', 'luz');
      const event3 = CategoryCreateRequested('Utilities'); // without iconName
      const event4 = CategoryCreateRequested('Entertainment', 'netflix');

      expect(event1.props, ['Utilities', 'luz']);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3))); // different iconName
      expect(event1, isNot(equals(event4))); // different name
    });

    test('CategoryCreateRequested with null iconName', () {
      const event = CategoryCreateRequested('Utilities');
      expect(event.props, ['Utilities', null]);
    });

    test('CategoryUpdateRequested has correct props', () {
      const event1 = CategoryUpdateRequested(1, 'Utilities', 'luz');
      const event2 = CategoryUpdateRequested(1, 'Utilities', 'luz');
      const event3 = CategoryUpdateRequested(2, 'Utilities', 'luz'); // different id
      const event4 = CategoryUpdateRequested(1, 'Entertainment', 'luz'); // different name

      expect(event1.props, [1, 'Utilities', 'luz']);
      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3))); // different id
      expect(event1, isNot(equals(event4))); // different name
    });

    test('CategoryUpdateRequested with null iconName', () {
      const event = CategoryUpdateRequested(1, 'Utilities');
      expect(event.props, [1, 'Utilities', null]);
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

      test('iconName accepts all valid icon names', () {
        const event1 = CategoryCreateRequested('Name', 'netflix');
        const event2 = CategoryCreateRequested('Name', 'spotify');
        const event3 = CategoryCreateRequested('Name', 'agua');

        expect(event1.iconName, 'netflix');
        expect(event2.iconName, 'spotify');
        expect(event3.iconName, 'agua');
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
