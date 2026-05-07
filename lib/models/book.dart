import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publishedDate;
  final int? pageCount;
  final List<String> categories;
  final String? previewLink;
  bool isRead;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnailUrl,
    this.publishedDate,
    this.pageCount,
    this.categories = const [],
    this.previewLink,
    this.isRead = false,
  });

  // Construct from Google Books API JSON
  factory Book.fromGoogleBooksJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>? ?? {};

    // Replace http to https to avoid mixed-content
    String? thumb = imageLinks['thumbnail'] as String? ??
        imageLinks['smallThumbnail'] as String?;
    if (thumb != null) {
      thumb = thumb.replaceFirst('http://', 'https://');
    }

    return Book(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Unknown Title',
      authors: (volumeInfo['authors'] as List<dynamic>?)
              ?.map((a) => a.toString())
              .toList() ??
          ['Unknown Author'],
      description: volumeInfo['description'] as String?,
      thumbnailUrl: thumb,
      publishedDate: volumeInfo['publishedDate'] as String?,
      pageCount: volumeInfo['pageCount'] as int?,
      categories: (volumeInfo['categories'] as List<dynamic>?)
              ?.map((c) => c.toString())
              .toList() ??
          [],
      previewLink: volumeInfo['previewLink'] as String?,
    );
  }

  // Serialization for SharedPreferences
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'publishedDate': publishedDate,
        'pageCount': pageCount,
        'categories': categories,
        'previewLink': previewLink,
        'isRead': isRead,
      };

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as String,
        title: json['title'] as String,
        authors: (json['authors'] as List<dynamic>).map((a) => a.toString()).toList(),
        description: json['description'] as String?,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        publishedDate: json['publishedDate'] as String?,
        pageCount: json['pageCount'] as int?,
        categories:
            (json['categories'] as List<dynamic>?)?.map((c) => c.toString()).toList() ?? [],
        previewLink: json['previewLink'] as String?,
        isRead: json['isRead'] as bool? ?? false,
      );

  String toJsonString() => jsonEncode(toJson());

  Book copyWith({bool? isRead}) => Book(
        id: id,
        title: title,
        authors: authors,
        description: description,
        thumbnailUrl: thumbnailUrl,
        publishedDate: publishedDate,
        pageCount: pageCount,
        categories: categories,
        previewLink: previewLink,
        isRead: isRead ?? this.isRead,
      );

  String get authorsDisplay => authors.join(', ');

  String get yearDisplay {
    if (publishedDate == null || publishedDate!.isEmpty) return '';
    return publishedDate!.length >= 4 ? publishedDate!.substring(0, 4) : publishedDate!;
  }
}
