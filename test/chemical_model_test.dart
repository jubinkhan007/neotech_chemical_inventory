import 'package:flutter_test/flutter_test.dart';
import 'package:neotech_chemical_inventory/features/chemicals/models/chemical.dart';

void main() {
  group('Chemical', () {
    test('deserializes from JSON with API field names', () {
      const json = {
        'id': 'abc123',
        'productName': 'Acetone',
        'casNumber': '67-64-1',
        'manufacturer': 'ChemCorp',
        'inventoryData': {
          'currentStock': 450.0,
          'unit': 'liters',
        },
      };

      final chemical = Chemical.fromJson(json);

      expect(chemical.id, 'abc123');
      expect(chemical.productName, 'Acetone');
      expect(chemical.casNumber, '67-64-1');
      expect(chemical.manufacturer, 'ChemCorp');
      expect(chemical.inventoryData.currentStock, 450.0);
      expect(chemical.inventoryData.unit, 'liters');
    });

    test('serializes to JSON with API field names', () {
      const chemical = Chemical(
        id: 'abc123',
        productName: 'Acetone',
        casNumber: '67-64-1',
        manufacturer: 'ChemCorp',
        inventoryData: InventoryData(
          currentStock: 450.0,
          unit: 'liters',
        ),
      );

      final json = chemical.toJson();

      expect(json['id'], 'abc123');
      expect(json['productName'], 'Acetone');
      expect(json['casNumber'], '67-64-1');
      expect(json['manufacturer'], 'ChemCorp');
      expect(json['inventoryData']['currentStock'], 450.0);
      expect(json['inventoryData']['unit'], 'liters');
    });
  });
}
