import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';

class ArticleHeader {
  final int wordCount;
  final String? note;
  final String id;
  final String? sourceUrl;
  final String slug;
  final String title;
  final ArticleType type;
  final DateTime publicationDate;
  final int timeToRead;
  final Publisher publisher;
  final Image? image;
  final String? author;

  ArticleHeader({
    required this.wordCount,
    required this.note,
    required this.id,
    required this.sourceUrl,
    required this.slug,
    required this.title,
    required this.type,
    required this.publicationDate,
    required this.timeToRead,
    required this.publisher,
    required this.image,
    required this.author,
  });
}
