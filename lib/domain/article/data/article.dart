import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';

class Article {
  final ArticleContent content;
  final Entry entry;

  Article({
    required this.content,
    required this.entry,
  });
}

enum ArticleType { freemium, premium }
