import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookApiService {
  static const _apiKey = 'AIzaSyBfAycKcKhw2EKDW3tPml6RSRjywgsJIHg';
  static const _maxResults = 20;

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final params = {
      'q': query.trim(),
      'maxResults': '$_maxResults',
      'printType': 'books',
      'langRestrict': 'en',
      if (_apiKey.isNotEmpty) 'key': _apiKey,
    };

    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', params);

    try {
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 403) {
        throw Exception(
            'API key required or quota exceeded. Add a free Google Books API key.');
      }

      if (response.statusCode != 200) {
        throw Exception('API error ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>? ?? [];

      return items
          .map((item) => Book.fromGoogleBooksJson(item as Map<String, dynamic>))
          .where((book) => book.id.isNotEmpty)
          .toList();
    } on Exception {
      rethrow;
    }
  }
}