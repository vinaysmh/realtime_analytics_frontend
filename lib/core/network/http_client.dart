import 'dart:convert';
import 'package:http/http.dart' as http;

/// A reusable HTTP client wrapper with basic GET support and error handling.
class HttpClientService {
  final http.Client _client;

  HttpClientService({http.Client? client}) : _client = client ?? http.Client();

  ///Timeout for HTTP requests in case of server sleeping as it happens with render
  final Duration _timeout = const Duration(minutes: 2);

  /// Performs a GET request and returns the decoded JSON.
  Future<Map<String, dynamic>> getJson(String url) async {
    final response = await _client.get(Uri.parse("https://$url")).timeout(_timeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw HttpException('Failed to load data', response.statusCode);
    }
  }

  /// Dispose the client when no longer needed.
  void dispose() {
    _client.close();
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() => 'HttpException ($statusCode): $message';
}
