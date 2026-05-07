import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class ReadingListRepository {
  static const _key = 'reading_list';

  Future<List<Book>> loadReadingList() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => Book.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveReadingList(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, books.map((b) => b.toJsonString()).toList());
  }

  Future<void> addBook(Book book) async {
    final list = await loadReadingList();
    if (!list.any((b) => b.id == book.id)) {
      list.add(book);
      await saveReadingList(list);
    }
  }

  Future<void> removeBook(String bookId) async {
    final list = await loadReadingList();
    list.removeWhere((b) => b.id == bookId);
    await saveReadingList(list);
  }

  // Stores the date when marking read, clears it when marking unread
  Future<void> toggleRead(String bookId) async {
    final list = await loadReadingList();
    final index = list.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      final book = list[index];
      if (book.isRead) {
        // marking unread → clear date
        list[index] = book.copyWith(isRead: false, clearDateRead: true);
      } else {
        // marking read → record today
        list[index] = book.copyWith(isRead: true, dateRead: DateTime.now());
      }
      await saveReadingList(list);
    }
  }
}