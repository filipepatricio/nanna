import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

class ReadingBanner {
  final MediaItemArticle article;
  final double scrollProgress;

  ReadingBanner({
    required this.article,
    required this.scrollProgress,
  });
}
