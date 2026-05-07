import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../models/reading_list_repository.dart';

// State
class ReadingListState {
  final List<Book> books;
  final bool isLoading;
  final String? message;

  const ReadingListState({
    this.books = const [],
    this.isLoading = false,
    this.message,
  });

  ReadingListState copyWith({List<Book>? books, bool? isLoading, String? message}) =>
      ReadingListState(
        books: books ?? this.books,
        isLoading: isLoading ?? this.isLoading,
        message: message,
      );

  int get readCount   => books.where((b) => b.isRead).length;
  int get unreadCount => books.where((b) => !b.isRead).length;

  // So screens can call state.containsBook(id)
  bool containsBook(String bookId) => books.any((b) => b.id == bookId);
}

// Cubit
class ReadingListCubit extends Cubit<ReadingListState> {
  final ReadingListRepository _repo;

  ReadingListCubit(this._repo) : super(const ReadingListState()) {
    loadList();
  }

  Future<void> loadList() async {
    emit(state.copyWith(isLoading: true));
    final books = await _repo.loadReadingList();
    emit(state.copyWith(books: books, isLoading: false));
  }

  Future<void> addBook(Book book) async {
    if (state.containsBook(book.id)) {
      emit(state.copyWith(message: '"${book.title}" is already in your list'));
      return;
    }
    await _repo.addBook(book);
    emit(state.copyWith(books: [...state.books, book], message: 'Added "${book.title}"'));
  }

  Future<void> removeBook(String bookId) async {
    await _repo.removeBook(bookId);
    emit(state.copyWith(books: state.books.where((b) => b.id != bookId).toList()));
  }

  Future<void> toggleRead(String bookId) async {
    await _repo.toggleRead(bookId);
    final updated = state.books.map((b) {
      return b.id == bookId ? b.copyWith(isRead: !b.isRead) : b;
    }).toList();
    emit(state.copyWith(books: updated));
  }

  void clearMessage() => emit(state.copyWith());
}
