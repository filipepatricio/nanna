import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

class ReadingBanner {
  ReadingBanner({
    required this.article,
    required this.scrollProgress,
  });
  final MediaItemArticle article;
  final double scrollProgress;
}
