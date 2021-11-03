import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';

class ReadingBanner {
  final MediaItemArticle entry;
  final double scrollProgress;

  ReadingBanner({
    required this.entry,
    required this.scrollProgress,
  });
}
