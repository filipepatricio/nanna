import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';

class Article {
  final ArticleContent content;
  final MediaItemArticle entry;

  Article({
    required this.content,
    required this.entry,
  });
}

enum ArticleType { freemium, premium }
