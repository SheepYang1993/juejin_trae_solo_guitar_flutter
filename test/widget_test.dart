// This is a basic Flutter widget test for the guitar fretboard simulator.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:juejin_trae_solo_guitar_flutter/main.dart';
import 'package:juejin_trae_solo_guitar_flutter/components/guitar_fretboard_painter.dart';
import 'package:juejin_trae_solo_guitar_flutter/models/scales.dart';

void main() {
  testWidgets('Guitar fretboard widget smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed in the app bar.
    expect(find.widgetWithText(AppBar, '吉他指板模拟器'), findsOneWidget);

    // Verify that the guitar fretboard title is displayed.
    expect(find.text('6弦12品吉他指板'), findsOneWidget);

    // Verify that the key selection dropdown is displayed.
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(2));

    // Verify that the guitar fretboard widget is displayed.
    expect(find.byType(GuitarFretboardWidget), findsOneWidget);
  });

  testWidgets('Key selection test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial scale is displayed in the info card
    expect(find.text('C Major'), findsOneWidget);

    // Tap the key dropdown button to open the menu
    final dropdownButtons = find.byType(DropdownButtonFormField<String>);
    await tester.tap(dropdownButtons.first);
    await tester.pumpAndSettle();

    // Select the second key (G)
    await tester.tap(find.text('G').last);
    await tester.pumpAndSettle();

    // Verify that the selected key has changed in the info card
    expect(find.text('G Major'), findsOneWidget);
  });

  testWidgets('Scale type selection test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial scale type is displayed in the info card
    expect(find.text('C Major'), findsOneWidget);

    // Tap the scale type dropdown button to open the menu
    final dropdownButtons = find.byType(DropdownButtonFormField<String>);
    await tester.tap(dropdownButtons.last);
    await tester.pumpAndSettle();

    // Select the second scale type (大调五声音阶)
    await tester.tap(find.text('大调五声音阶').last);
    await tester.pumpAndSettle();

    // Verify that the selected scale type has changed in the info card
    expect(find.text('C Pentatonic Major'), findsOneWidget);
  });
}
