import 'package:better_informed_mobile/domain/article/data/article_content_type.dart';

class ArticleContent {
  final ArticleContentType type;
  final String content;

  ArticleContent({
    required this.type,
    required this.content,
  });
}
