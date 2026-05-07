import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class BookCoverWidget extends StatelessWidget {
  final String? thumbnailUrl;
  final double width;
  final double height;
  final double borderRadius;

  const BookCoverWidget({
    super.key,
    required this.thumbnailUrl,
    this.width = 60,
    this.height = 85,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.mintGlow,
        child: thumbnailUrl != null
            ? CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                fit: BoxFit.cover,
                width: width,
                height: height,
                placeholder: (ctx, url) => _placeholder(),
                errorWidget: (ctx, url, err) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.mintGlow,
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: Color.fromRGBO(84, 54, 24, 0.35),
          size: width * 0.45,
        ),
      ),
    );
  }
}
