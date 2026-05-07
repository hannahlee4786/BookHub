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
    final raw = books.map((b) => b.toJsonString()).toList();
    await prefs.setStringList(_key, raw);
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

  Future<void> toggleRead(String bookId) async {
    final list = await loadReadingList();
    final index = list.indexWhere((b) => b.id == bookId);
    if (index != -1) {
      list[index] = list[index].copyWith(isRead: !list[index].isRead);
      await saveReadingList(list);
    }
  }

  Future<bool> isInReadingList(String bookId) async {
    final list = await loadReadingList();
    return list.any((b) => b.id == bookId);
  }
}
