import 'package:flutter/material.dart';
import '../models/book.dart';
import '../theme.dart';
import 'book_cover_widget.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showReadBadge;

  const BookListTile({
    super.key,
    required this.book,
    required this.onTap,
    this.trailing,
    this.showReadBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              Stack(
                children: [
                  BookCoverWidget(thumbnailUrl: book.thumbnailUrl),
                  if (showReadBadge && book.isRead)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.goldenGoose,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: AppColors.brownMoss, size: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: tt.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.authorsDisplay,
                      style: tt.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book.yearDisplay.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(book.yearDisplay, style: tt.bodySmall),
                    ],
                    if (book.categories.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: book.categories
                            .take(2)
                            .map((c) => Chip(label: Text(c)))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
