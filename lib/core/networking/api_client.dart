import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/app_exception.dart';

class ApiClient {
  ApiClient({required this.baseUrl, required http.Client client})
      : _client = client;

  final String baseUrl;
  final http.Client _client;

  Future<Map<String, dynamic>> getJson(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.get(uri);

    if (response.statusCode == 404) {
      throw const NotFoundException('Not found');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        'HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException(500, 'Invalid JSON response');
    }
    return decoded;
  }
}
