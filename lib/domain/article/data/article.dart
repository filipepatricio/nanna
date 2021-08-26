import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';

class Article {
  final String sourceUrl;
  final ArticleContent content;
  final ArticleHeader header;

  Article({
    required this.content,
    required this.sourceUrl,
    required this.header,
  });
}

enum ArticleType { freemium, premium }
