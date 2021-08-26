import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';

class ArticleHeader {
  final String slug;
  final String title;
  final ArticleType type;
  final String publicationDate;
  final int timeToRead;
  final Publisher publisher;
  final Image? image;

  ArticleHeader({
    required this.slug,
    required this.title,
    required this.type,
    required this.publicationDate,
    required this.timeToRead,
    required this.publisher,
    required this.image,
  });
}
