import 'package:better_informed_mobile/domain/article/data/article_header.dart';

class ReadingList {
  final String id;
  final List<ArticleHeader> articles;

  ReadingList({
    required this.id,
    required this.articles,
  });
}
