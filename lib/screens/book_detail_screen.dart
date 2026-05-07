import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/reading_list_cubit.dart';
import '../models/book.dart';
import '../theme.dart';
import '../widgets/book_cover_widget.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocConsumer<ReadingListCubit, ReadingListState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
            context.read<ReadingListCubit>().clearMessage();
          }
        },
        builder: (context, rlState) {
          final inList = rlState.containsBook(book.id); // now on state

          return CustomScrollView(
            slivers: [
              // Hero app bar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.brownMoss, Color(0xFF7A5230)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -40, right: -40,
                        child: Container(
                          width: 200, height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(241, 188, 82, 0.12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BookCoverWidget(
                                thumbnailUrl: book.thumbnailUrl,
                                width: 90, height: 130, borderRadius: 10),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(book.title,
                                      style: tt.displayMedium?.copyWith(color: AppColors.butterscotch),
                                      maxLines: 3, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text(book.authorsDisplay,
                                      style: tt.bodyMedium?.copyWith(color: AppColors.goldenGoose)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add / Remove button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (inList) {
                              context.read<ReadingListCubit>().removeBook(book.id);
                            } else {
                              context.read<ReadingListCubit>().addBook(book);
                            }
                          },
                          icon: Icon(inList
                              ? Icons.bookmark_remove_rounded
                              : Icons.bookmark_add_rounded),
                          label: Text(inList
                              ? 'Remove from Reading List'
                              : 'Add to Reading List'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inList
                                ? AppColors.strawberryMilkshake
                                : AppColors.primary,
                            foregroundColor: inList
                                ? AppColors.brownMoss
                                : AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Metadata
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          if (book.yearDisplay.isNotEmpty)
                            _MetaChip(icon: Icons.calendar_today_rounded, label: book.yearDisplay),
                          if (book.pageCount != null)
                            _MetaChip(icon: Icons.menu_book_rounded, label: '${book.pageCount} pages'),
                          ...book.categories.take(3).map((c) => Chip(label: Text(c))),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      if (book.description != null && book.description!.isNotEmpty) ...[
                        Text('About this book', style: tt.titleLarge),
                        const SizedBox(height: 8),
                        Text(book.description!,
                            style: tt.bodyMedium?.copyWith(height: 1.6)),
                      ] else
                        Center(
                          child: Text('No description available.',
                              style: tt.bodyMedium?.copyWith(
                                  color: Color.fromRGBO(84, 54, 24, 0.5))),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(241, 188, 82, 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(241, 188, 82, 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.brownMoss),
          const SizedBox(width: 5),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
