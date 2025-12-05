import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neotech_chemical_inventory/app.dart';

void main() {
  testWidgets('App starts and shows dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    // Verify dashboard screen is shown
    expect(find.text('Chemical Inventory'), findsOneWidget);
    expect(find.text('Dashboard Overview'), findsOneWidget);
  });
}
