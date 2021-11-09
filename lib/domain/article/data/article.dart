import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';

class Article {
  final ArticleContent content;
  final MediaItemArticle article;

  Article({
    required this.content,
    required this.article,
  });
}

enum ArticleType { freemium, premium }
