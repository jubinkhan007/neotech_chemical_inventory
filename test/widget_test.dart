import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neotech_chemical_inventory/main.dart';

void main() {
  testWidgets('Dashboard summary shows calculated metrics',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dashboard Summary'), findsOneWidget);

    final totalValue = tester.widget<Text>(find.byKey(const Key('totalChemicalsValue')));
    final sdsValue = tester.widget<Text>(find.byKey(const Key('sdsValue')));
    final incidentsValue = tester.widget<Text>(find.byKey(const Key('incidentsValue')));

    expect(totalValue.data, '5');
    expect(sdsValue.data, '3');
    expect(incidentsValue.data, '3');
  });

  testWidgets('Chemical list renders all records', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final listTiles = find.byType(ListTile);
    expect(listTiles, findsNWidgets(5));

    expect(find.text('Acetone'), findsOneWidget);
    expect(find.text('Hydrochloric Acid'), findsOneWidget);
    expect(find.text('Sodium Hydroxide'), findsOneWidget);
    expect(find.text('Ethanol'), findsOneWidget);
    expect(find.text('Ammonia'), findsOneWidget);
  });
}
