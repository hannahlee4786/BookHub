import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/search_cubit.dart';
import '../cubits/reading_list_cubit.dart';
import '../models/book.dart';
import '../theme.dart';
import '../widgets/book_list_tile.dart';
import 'book_detail_screen.dart';
import 'reading_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode  = FocusNode();

  void _search() {
    _focusNode.unfocus();
    context.read<SearchCubit>().search(_controller.text);
  }

  void _openDetail(Book book) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
        actions: [
          BlocBuilder<ReadingListCubit, ReadingListState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bookmarks_rounded),
                    tooltip: 'My Reading List',
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ReadingListScreen())),
                  ),
                  if (state.books.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.goldenGoose,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${state.books.length}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brownMoss),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(
                      hintText: 'Search by title, author, or keyword…',
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.brownMoss),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldenGoose,
                    foregroundColor: AppColors.brownMoss,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.search_rounded),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial)  return _Splash();
                if (state is SearchLoading)  return const Center(child: CircularProgressIndicator());
                if (state is SearchError)    return _ErrorView(message: state.message);
                if (state is SearchEmpty)    return _EmptyView(query: state.query);
                if (state is SearchSuccess)  return _ResultsList(books: state.results, onTap: _openDetail);
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-widgets

class _Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(241, 188, 82, 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_stories_rounded, size: 72, color: AppColors.goldenGoose),
            ),
            const SizedBox(height: 24),
            Text('Discover your next read',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Search millions of books by title,\nauthor, or topic.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Color.fromRGBO(84, 54, 24, 0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Color.fromRGBO(84, 54, 24, 0.4)),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String query;
  const _EmptyView({required this.query});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 56, color: Color.fromRGBO(84, 54, 24, 0.35)),
            const SizedBox(height: 16),
            Text('No results for "$query"',
                style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<Book> books;
  final void Function(Book) onTap;
  const _ResultsList({required this.books, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: books.length,
      itemBuilder: (ctx, i) => BookListTile(book: books[i], onTap: () => onTap(books[i])),
    );
  }
}
