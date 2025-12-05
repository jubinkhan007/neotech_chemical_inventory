import 'dart:convert';

import 'package:http/http.dart' as http;

/// Basic API client wrapper around [http.Client].
///
/// Handles applying a base URL and default headers for each request.
class ApiClient {
  ApiClient({
    http.Client? client,
    this.baseUrl = 'https://api.neotech.local/',
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  /// Default headers sent with every request.
  Map<String, String> get defaultHeaders => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Sends a GET request to the provided [path] relative to [baseUrl].
  Future<http.Response> get(String path) {
    final uri = Uri.parse(baseUrl).resolve(path);
    return _client.get(uri, headers: defaultHeaders);
  }

  /// Decodes a JSON response body to a dynamic map.
  Map<String, dynamic> decodeResponse(http.Response response) {
    return json.decode(response.body) as Map<String, dynamic>;
  }
}
