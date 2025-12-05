import 'package:flutter_test/flutter_test.dart';
import 'package:neotech_chemical_inventory/features/chemicals/models/chemical.dart';

void main() {
  group('Chemical', () {
    const chemical = Chemical(
      id: 'abc123',
      name: 'Acetone',
      casNumber: '67-64-1',
      storageLocation: 'Cabinet A',
      quantity: 5,
    );

    test('serializes to JSON with API field names', () {
      expect(
        chemical.toJson(),
        equals({
          'id': 'abc123',
          'name': 'Acetone',
          'cas_number': '67-64-1',
          'storage_location': 'Cabinet A',
          'quantity': 5,
        }),
      );
    });

    test('deserializes from JSON with API field names', () {
      const json = {
        'id': 'abc123',
        'name': 'Acetone',
        'cas_number': '67-64-1',
        'storage_location': 'Cabinet A',
        'quantity': 5,
      };

      expect(Chemical.fromJson(json), equals(chemical));
    });
  });
}
