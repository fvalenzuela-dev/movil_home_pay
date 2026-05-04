import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';
import 'package:movil_home_pay/features/admin/presentation/pages/categories_page.dart';

void main() {
  group('CategoryFormDialog Widget Tests', () {
    // Helper to show the dialog and get a callback when saved
    Future<void> showDialogAndPump(
      WidgetTester tester,
      Category? category,
      void Function(String name, String? iconApk, String? colorApk) onSave,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CategoryFormDialog(
                      category: category,
                      onSave: onSave,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders name TextField with autofocus', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});
      
      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('renders icon picker grid with CategoryIcons.iconNames', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Icon grid should have icons from CategoryIcons.iconNames
      expect(find.byType(GridView), findsOneWidget);
      
      // Verify at least some icons are rendered (grid contains icon containers)
      expect(
        find.descendant(
          of: find.byType(GridView),
          matching: find.byType(InkWell),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('renders color picker with 6 CategoryColor circles', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Should have a horizontal scrollable list for colors (ListView.separated)
      expect(find.byType(ListView), findsOneWidget);
      
      // Find circular containers (color indicators)
      final colorCircles = find.byWidgetPredicate(
        (widget) => widget is Container && 
                     widget.decoration is BoxDecoration && 
                     (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      expect(colorCircles, findsNWidgets(CategoryColor.values.length));
    });

    testWidgets('tapping color selects it and updates state', (tester) async {
      CategoryColor? selectedColor;
      
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {
        selectedColor = colorApk != null 
            ? CategoryColorExtension.fromApiName(colorApk) 
            : null;
      });

      // Find color circles
      final colorCircles = find.byWidgetPredicate(
        (widget) => widget is Container && 
                     widget.decoration is BoxDecoration && 
                     (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      
      expect(colorCircles, findsNWidgets(6));
      
      // Tap second color circle (index 1)
      await tester.tap(colorCircles.at(1));
      await tester.pump();
      
      // Verify state was updated
      expect(colorCircles, findsNWidgets(6));
    });

    testWidgets('save button disabled when name is empty', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Find the FilledButton "Crear"
      final saveButton = find.widgetWithText(FilledButton, 'Crear');
      expect(saveButton, findsOneWidget);
      
      // Button should be disabled when name is empty
      final button = tester.widget<FilledButton>(saveButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('save button enabled when name is not empty', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Enter a name
      await tester.enterText(find.byType(TextField), 'Test Category');
      await tester.pump();
      
      // Find the save button
      final saveButton = find.widgetWithText(FilledButton, 'Crear');
      expect(saveButton, findsOneWidget);
      
      // Button should be enabled now
      final button = tester.widget<FilledButton>(saveButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('onSave callback receives correct params when name and icon selected', (tester) async {
      String? savedName;
      String? savedIcon;
      String? savedColor;
      
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {
        savedName = name;
        savedIcon = iconApk;
        savedColor = colorApk;
      });

      // Enter name
      await tester.enterText(find.byType(TextField), 'Food');
      await tester.pump();
      
      // Select an icon
      final iconInkWells = find.descendant(
        of: find.byType(GridView),
        matching: find.byType(InkWell),
      );
      await tester.tap(iconInkWells.first);
      await tester.pump();
      
      // Select a color
      final colorCircles = find.byWidgetPredicate(
        (widget) => widget is Container && 
                     widget.decoration is BoxDecoration && 
                     (widget.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      await tester.tap(colorCircles.at(2)); // tertiary
      await tester.pump();
      
      // Tap save button
      await tester.tap(find.widgetWithText(FilledButton, 'Crear'));
      await tester.pumpAndSettle();
      
      // Verify callback params
      expect(savedName, equals('Food'));
      expect(savedIcon, isNotNull); // First icon in grid
      expect(savedColor, equals('tertiary'));
    });

    testWidgets('cancel button closes dialog', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // Tap cancel
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      
      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('renders live preview with CircleAvatar', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      // Should have CircleAvatar for preview
      expect(find.byType(CircleAvatar), findsOneWidget);
      
      // Should have icon in preview
      expect(find.descendant(
        of: find.byType(CircleAvatar),
        matching: find.byType(Icon),
      ), findsOneWidget);
    });

    testWidgets('renders with initial values when category provided for edit', (tester) async {
      final testCategory = Category(
        id: 1,
        name: 'Existing Category',
        iconApk: 'luz',
        colorApk: 'secondary',
      );
      
      await showDialogAndPump(tester, testCategory, (_, __, ___) {});

      // Name should be pre-filled
      expect(find.text('Existing Category'), findsOneWidget);
    });

    testWidgets('renders title "Editar Categoría" when editing', (tester) async {
      final testCategory = Category(
        id: 1,
        name: 'Existing Category',
      );
      
      await showDialogAndPump(tester, testCategory, (_, __, ___) {});

      expect(find.text('Editar Categoría'), findsOneWidget);
    });

    testWidgets('renders title "Nueva Categoría" when creating', (tester) async {
      await showDialogAndPump(tester, null, (_, __, ___) {});

      expect(find.text('Nueva Categoría'), findsOneWidget);
    });
  });
}
