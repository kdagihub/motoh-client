import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_error.dart';

typedef TokenReader = Future<String?> Function();

class ApiClient {
  ApiClient({
    this.baseUrl = 'http://10.0.2.2:8080',
    TokenReader? tokenReader,
    http.Client? httpClient,
  })  : _tokenReader = tokenReader,
        _http = httpClient ?? http.Client();

  final String baseUrl;
  final TokenReader? _tokenReader;
  final http.Client _http;

  Uri _uri(String path, [Map<String, String>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$baseUrl$normalized').replace(queryParameters: query);
  }

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final reader = _tokenReader;
      if (reader != null) {
        final t = await reader();
        if (t != null && t.isNotEmpty) {
          h['Authorization'] = 'Bearer $t';
        }
      }
    }
    return h;
  }

  Never _throwForResponse(http.Response r) {
    try {
      final body = jsonDecode(r.body);
      if (body is Map<String, dynamic>) {
        throw ApiError.fromJson(body);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
    }
    throw ApiError(
      code: 'HTTP_${r.statusCode}',
      message: 'Erreur réseau (${r.statusCode})',
      details: r.body.isNotEmpty ? r.body : null,
    );
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query, bool auth = false}) async {
    final res = await _http.get(_uri(path, query), headers: await _headers(auth: auth));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw ApiError(code: 'INVALID_JSON', message: 'Réponse invalide');
    }
    _throwForResponse(res);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {bool auth = false}) async {
    final res = await _http.post(
      _uri(path),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw ApiError(code: 'INVALID_JSON', message: 'Réponse invalide');
    }
    _throwForResponse(res);
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body, {bool auth = false}) async {
    final res = await _http.patch(
      _uri(path),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw ApiError(code: 'INVALID_JSON', message: 'Réponse invalide');
    }
    _throwForResponse(res);
  }

  void close() => _http.close();
}
