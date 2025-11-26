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

    // Verify that the app title is displayed.
    expect(find.text('吉他指板模拟器'), findsOneWidget);

    // Verify that the guitar fretboard title is displayed.
    expect(find.text('6弦12品吉他指板'), findsOneWidget);

    // Verify that the scale selection dropdown is displayed.
    expect(find.byType(DropdownButton<int>), findsOneWidget);

    // Verify that the guitar fretboard widget is displayed.
    expect(find.byType(GuitarFretboardWidget), findsOneWidget);
  });

  testWidgets('Scale selection test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial scale is displayed
    expect(find.text('当前显示: C Major'), findsOneWidget);

    // Tap the dropdown button to open the menu
    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();

    // Select the second scale (G Major)
    await tester.tap(find.text('G Major').last);
    await tester.pumpAndSettle();

    // Verify that the selected scale has changed
    expect(find.text('当前显示: G Major'), findsOneWidget);
  });
}
