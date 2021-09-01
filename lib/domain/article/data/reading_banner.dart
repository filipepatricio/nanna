import 'package:better_informed_mobile/domain/article/data/article_header.dart';

class ReadingBanner {
  final ArticleHeader article;
  final double scrollProgress;

  ReadingBanner({
    required this.article,
    required this.scrollProgress,
  });
}
