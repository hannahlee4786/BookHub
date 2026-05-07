import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookApiService {
  static const _maxResults = 20;

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final apiKey = dotenv.env['GOOGLE_BOOKS_API_KEY'] ?? '';

    final params = {
      'q': query.trim(),
      'maxResults': '$_maxResults',
      'printType': 'books',
      'langRestrict': 'en',
      if (apiKey.isNotEmpty) 'key': apiKey,
    };

    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', params);

    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 403) {
      throw Exception('API key invalid or quota exceeded.');
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
  }
}
