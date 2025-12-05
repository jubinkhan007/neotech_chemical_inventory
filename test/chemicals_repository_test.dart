import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:neotech_chemical_inventory/core/network/api_client.dart';
import 'package:neotech_chemical_inventory/features/chemicals/data/chemicals_repository.dart';
import 'package:neotech_chemical_inventory/features/chemicals/models/chemical.dart';

void main() {
  group('ChemicalsRepository', () {
    test('returns chemicals on success', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), 'https://example.com/chemicals');
        return http.Response(
          jsonEncode({
            'data': [
              {
                'id': '1',
                'name': 'Ethanol',
                'cas_number': '64-17-5',
                'storage_location': 'Shelf 2',
                'quantity': 10,
              }
            ],
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });

      final repository = ChemicalsRepository(
        apiClient: ApiClient(baseUrl: 'https://example.com/', client: mockClient),
      );

      final result = await repository.fetchChemicals();
      expect(
        result,
        equals(
          const [
            Chemical(
              id: '1',
              name: 'Ethanol',
              casNumber: '64-17-5',
              storageLocation: 'Shelf 2',
              quantity: 10,
            )
          ],
        ),
      );
    });

    test('returns empty list when API returns no data', () async {
      final mockClient = MockClient((_) async {
        return http.Response(jsonEncode({'data': []}), 200,
            headers: {'Content-Type': 'application/json'});
      });

      final repository = ChemicalsRepository(
        apiClient: ApiClient(baseUrl: 'https://example.com/', client: mockClient),
      );

      final result = await repository.fetchChemicals();
      expect(result, isEmpty);
    });

    test('throws exception for non-successful response', () async {
      final mockClient = MockClient((_) async {
        return http.Response('Not found', 404);
      });

      final repository = ChemicalsRepository(
        apiClient: ApiClient(baseUrl: 'https://example.com/', client: mockClient),
      );

      expect(
        repository.fetchChemicals(),
        throwsA(isA<ChemicalsRepositoryException>()),
      );
    });

    test('throws exception for malformed payload', () async {
      final mockClient = MockClient((_) async {
        return http.Response(jsonEncode({'data': {}}), 200,
            headers: {'Content-Type': 'application/json'});
      });

      final repository = ChemicalsRepository(
        apiClient: ApiClient(baseUrl: 'https://example.com/', client: mockClient),
      );

      expect(
        repository.fetchChemicals(),
        throwsA(isA<ChemicalsRepositoryException>()),
      );
    });
  });
}
