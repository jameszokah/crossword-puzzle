import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crossword_puzzle/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Verify that HomeScreen has the expected widgets.

    // Example: Check if there's an AppBar.
    expect(find.byType(AppBar), findsOneWidget);

    // Check if there's a Text widget with a specific text.
    expect(find.text('Crossword Puzzle'), findsOneWidget);

    // Example: Check if there's an ElevatedButton.
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Check if there's an IconButton.
    expect(find.byType(IconButton), findsOneWidget);

    // You can add more test cases based on your UI.

    // Tap on the ElevatedButton.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    //  Verify that certain changes happened after tapping.
    // expect(find.text('New Text After Tap'), findsOneWidget);
  });
}
