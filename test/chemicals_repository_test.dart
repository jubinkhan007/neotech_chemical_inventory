import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:neotech_chemical_inventory/features/chemicals/data/chemicals_repository.dart';

void main() {
  group('ChemicalsRepositoryImpl', () {
    test('returns chemicals on success', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'record': {
              'chemicals': [
                {
                  'id': 'CHM001',
                  'productName': 'Acetone',
                  'casNumber': '67-64-1',
                  'manufacturer': 'ChemCorp',
                  'inventoryData': {
                    'currentStock': 450.0,
                    'unit': 'liters',
                  },
                }
              ],
              'dashboardMetrics': {
                'totalChemicals': 1,
                'activeSDSDocuments': 1,
                'recentIncidents': 0,
              },
            },
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final repository = ChemicalsRepositoryImpl(client: mockClient);
      final result = await repository.fetchChemicals();

      expect(result.chemicals.length, 1);
      expect(result.chemicals.first.productName, 'Acetone');
      expect(result.chemicals.first.casNumber, '67-64-1');
      expect(result.chemicals.first.manufacturer, 'ChemCorp');
      expect(result.chemicals.first.stockQuantity, 450.0);
      expect(result.chemicals.first.unit, 'liters');

      expect(result.metrics.totalChemicals, 1);
      expect(result.metrics.activeSDSDocuments, 1);
      expect(result.metrics.recentIncidents, 0);
    });

    test('returns empty list when API returns no chemicals', () async {
      final mockClient = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'record': {
              'chemicals': [],
              'dashboardMetrics': {
                'totalChemicals': 0,
                'activeSDSDocuments': 0,
                'recentIncidents': 0,
              },
            },
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final repository = ChemicalsRepositoryImpl(client: mockClient);
      final result = await repository.fetchChemicals();

      expect(result.chemicals, isEmpty);
    });

    test('throws exception for non-successful response', () async {
      final mockClient = MockClient((_) async {
        return http.Response('Not found', 404);
      });

      final repository = ChemicalsRepositoryImpl(client: mockClient);

      expect(
        repository.fetchChemicals(),
        throwsA(isA<ChemicalsRepositoryException>()),
      );
    });

    test('throws exception for malformed payload', () async {
      final mockClient = MockClient((_) async {
        return http.Response(
          jsonEncode({'record': {'chemicals': {}}}),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final repository = ChemicalsRepositoryImpl(client: mockClient);

      expect(
        repository.fetchChemicals(),
        throwsA(isA<ChemicalsRepositoryException>()),
      );
    });
  });
}
