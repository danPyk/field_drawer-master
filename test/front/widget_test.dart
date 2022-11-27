import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('FAB', (tester) async {
    // Test code goes here.
    await tester.pumpWidget(MaterialApp(key: Key('fab'), home: Container()));
    expect(find.byKey(Key('fab')), findsOneWidget);

  });
  testWidgets('welcomeScreen/button', (tester) async {
    // Test code goes here.
    await tester.pumpWidget(MaterialApp(key: Key('o1'), home: Container()));
    expect(find.byKey(Key('o1')), findsOneWidget);
  });
}