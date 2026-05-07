import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../models/book_api_service.dart';

// State
abstract class SearchState {}

// No search (initial) state
class SearchInitial extends SearchState {}

// Loading search state when user searches
class SearchLoading extends SearchState {}

// Search state when user searches
class SearchSuccess extends SearchState {
  final List<Book> results;
  final String query;
  SearchSuccess(this.results, this.query);
}

// Search state with nothing found after user searches
class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);
}

// Failure to search state
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// Cubit
class SearchCubit extends Cubit<SearchState> {
  final BookApiService _api;

  SearchCubit(this._api) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await _api.searchBooks(query);
      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchSuccess(results, query));
      }
    } catch (e) {
      final msg = e.toString().contains('API key')
          ? 'API key required. See book_api_service.dart for instructions.'
          : 'Could not load results. Check your connection.\n\nError: $e';
      emit(SearchError(msg));
    }
  }

  // Clearing search
  void reset() => emit(SearchInitial());
}