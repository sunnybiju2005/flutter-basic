import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic/main.dart';

void main() {
  testWidgets('counter increments and list updates', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('You have pushed the button 0 times.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('You have pushed the button 1 times.'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });
}
