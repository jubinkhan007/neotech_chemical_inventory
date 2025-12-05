import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/network/api_client.dart';
import '../models/chemical.dart';

class ChemicalsRepositoryException implements Exception {
  ChemicalsRepositoryException(this.message);

  final String message;

  @override
  String toString() => 'ChemicalsRepositoryException: $message';
}

class ChemicalsRepository {
  ChemicalsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Chemical>> fetchChemicals() async {
    final http.Response response = await _apiClient.get('/chemicals');

    if (response.statusCode != 200) {
      throw ChemicalsRepositoryException(
        'Failed to load chemicals (status: ${response.statusCode})',
      );
    }

    final dynamic decodedBody = json.decode(response.body);
    if (decodedBody is! Map<String, dynamic>) {
      throw ChemicalsRepositoryException('Unexpected response format');
    }

    final data = decodedBody['data'];
    if (data is! List) {
      throw ChemicalsRepositoryException('Malformed data payload');
    }

    if (data.isEmpty) {
      return const [];
    }

    return data
        .cast<Map<String, dynamic>>()
        .map(Chemical.fromJson)
        .toList(growable: false);
  }
}
