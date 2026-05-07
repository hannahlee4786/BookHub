import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/reading_list_cubit.dart';
import '../models/book.dart';
import '../theme.dart';
import '../widgets/book_list_tile.dart';
import 'book_detail_screen.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Reading List')),
      body: BlocConsumer<ReadingListCubit, ReadingListState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
            context.read<ReadingListCubit>().clearMessage();
          }
        },
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());

          if (state.books.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                          color: AppColors.mintGlow, shape: BoxShape.circle),
                      child: const Icon(Icons.bookmarks_outlined,
                          size: 56, color: AppColors.brownMoss),
                    ),
                    const SizedBox(height: 20),
                    Text('Your reading list is empty',
                        style: tt.displayMedium, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('Search for books and add them here!',
                        style: tt.bodyMedium?.copyWith(
                            color: Color.fromRGBO(84, 54, 24, 0.6)),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Stats banner
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.goldenGoose, Color(0xFFE8A830)]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(241, 188, 82, 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(value: '${state.books.length}', label: 'Total',   icon: Icons.library_books_rounded),
                    Container(width: 1, height: 36, color: Color.fromRGBO(84, 54, 24, 0.3)),
                    _StatItem(value: '${state.readCount}',    label: 'Read',    icon: Icons.check_circle_outline_rounded),
                    Container(width: 1, height: 36, color: Color.fromRGBO(84, 54, 24, 0.3)),
                    _StatItem(value: '${state.unreadCount}',  label: 'To Read', icon: Icons.schedule_rounded),
                  ],
                ),
              ),

              // Book list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.books.length,
                  itemBuilder: (ctx, i) {
                    final book = state.books[i];
                    return BookListTile(
                      book: book,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book))),
                      showReadBadge: true,
                      trailing: _BookActions(book: book),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.brownMoss),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.brownMoss)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color.fromRGBO(84, 54, 24, 0.7), fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _BookActions extends StatelessWidget {
  final Book book;
  const _BookActions({required this.book});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingListCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => cubit.toggleRead(book.id),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: book.isRead ? AppColors.goldenGoose : AppColors.mintGlow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              book.isRead ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
              size: 16, color: AppColors.brownMoss,
            ),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Remove book?'),
                content: Text('Remove "${book.title}" from your reading list?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      cubit.removeBook(book.id);
                      Navigator.pop(context);
                    },
                    child: const Text('Remove', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: AppColors.strawberryMilkshake, shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded, size: 16, color: AppColors.brownMoss),
          ),
        ),
      ],
    );
  }
}
