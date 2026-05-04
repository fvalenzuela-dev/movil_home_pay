import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movil_home_pay/features/admin/domain/entities/category.dart';
import 'package:movil_home_pay/features/admin/presentation/pages/categories_page.dart';

void main() {
  group('CategoryFormDialog Widget Tests', () {
    // Helper to show the dialog and pump until settled
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

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders name TextField with autofocus', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('renders icon picker with CategoryIcons.iconNames', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      // Icon picker should have InkWell containers for icons
      expect(
        find.descendant(
          of: find.byType(Wrap),
          matching: find.byType(InkWell),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('renders color picker with circles', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      // Find circular containers for color picker (multiple should exist)
      final colorCircles = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle &&
            widget.constraints != null &&
            widget.constraints!.maxWidth == 40,
      );
      expect(colorCircles, findsAtLeastNWidgets(6));
    });

    testWidgets('save button calls onSave with entered name and defaults', (tester) async {
      String? savedName;
      String? savedIcon;
      String? savedColor;

      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {
        savedName = name;
        savedIcon = iconApk;
        savedColor = colorApk;
      });

      // Enter a name
      await tester.enterText(find.byType(TextField), 'Test Category');
      await tester.pump();

      // Tap save button
      await tester.tap(find.widgetWithText(FilledButton, 'Crear'));
      await tester.pumpAndSettle();

      // Verify name was saved with default color (primary)
      expect(savedName, equals('Test Category'));
      expect(savedColor, equals('primary')); // Default color is 'primary'
    });

    testWidgets('save button enabled when name is not empty', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      // Enter a name
      await tester.enterText(find.byType(TextField), 'Test Category');
      await tester.pump();

      final saveButton = find.widgetWithText(FilledButton, 'Crear');
      expect(saveButton, findsOneWidget);

      final button = tester.widget<FilledButton>(saveButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('cancel button closes dialog', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('renders live preview with CircleAvatar and icon', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      expect(find.byType(CircleAvatar), findsOneWidget);

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

      await showDialogAndPump(tester, testCategory, (name, iconApk, colorApk) {});

      expect(find.text('Existing Category'), findsOneWidget);
    });

    testWidgets('renders title "Editar Categoría" when editing', (tester) async {
      final testCategory = Category(
        id: 1,
        name: 'Existing Category',
      );

      await showDialogAndPump(tester, testCategory, (name, iconApk, colorApk) {});

      expect(find.text('Editar Categoría'), findsOneWidget);
    });

    testWidgets('renders title "Nueva Categoría" when creating', (tester) async {
      await showDialogAndPump(tester, null, (name, iconApk, colorApk) {});

      expect(find.text('Nueva Categoría'), findsOneWidget);
    });
  });
}
