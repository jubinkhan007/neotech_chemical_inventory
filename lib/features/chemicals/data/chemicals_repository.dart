import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/chemical.dart';
import '../domain/chemicals_repository.dart';
import '../domain/dashboard_metrics.dart';
import '../models/chemical.dart' as models;

class ChemicalsRepositoryException implements Exception {
  ChemicalsRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'ChemicalsRepositoryException: $message';
}

class ChemicalsRepositoryImpl implements ChemicalsRepository {
  ChemicalsRepositoryImpl({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const String _binUrl =
      'https://api.jsonbin.io/v3/b/68918782f7e7a370d1f4029d';

  @override
  Future<ChemicalsApiResponse> fetchChemicals() async {
    final http.Response response = await _client.get(
      Uri.parse(_binUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ChemicalsRepositoryException(
        'Failed to load chemicals (status: ${response.statusCode})',
      );
    }

    final dynamic decodedBody = json.decode(response.body);
    if (decodedBody is! Map<String, dynamic>) {
      throw ChemicalsRepositoryException('Unexpected response format');
    }

    // jsonbin.io wraps data in a 'record' object
    final record = decodedBody['record'];
    if (record is! Map<String, dynamic>) {
      throw ChemicalsRepositoryException('Missing record in response');
    }

    // Parse chemicals array
    final chemicalsJson = record['chemicals'];
    if (chemicalsJson is! List) {
      throw ChemicalsRepositoryException('Malformed chemicals payload');
    }

    final chemicals = chemicalsJson.map((json) {
      final model = models.Chemical.fromJson(json as Map<String, dynamic>);
      return Chemical(
        id: model.id,
        productName: model.productName,
        casNumber: model.casNumber,
        manufacturer: model.manufacturer,
        stockQuantity: model.inventoryData.currentStock,
        unit: model.inventoryData.unit,
      );
    }).toList(growable: false);

    // Parse dashboard metrics
    final metricsJson = record['dashboardMetrics'];
    final metrics = metricsJson is Map<String, dynamic>
        ? DashboardMetrics.fromJson(metricsJson)
        : DashboardMetrics(
            totalChemicals: chemicals.length,
            activeSDSDocuments: chemicals.length,
            recentIncidents: 0,
          );

    return ChemicalsApiResponse(chemicals: chemicals, metrics: metrics);
  }
}
