import 'package:better_informed_mobile/domain/article/data/article_data.dart';

class ReadingBanner {
  final Article article;
  final double scrollProgress;
  final double scrollOffset;

  ReadingBanner({
    required this.article,
    required this.scrollProgress,
    required this.scrollOffset,
  });
}
