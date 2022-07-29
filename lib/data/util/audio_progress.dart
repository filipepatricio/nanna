import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

class AudioProgress {
  final Map<String, double> _progressMap = {};

  void setProgress({required String articleSlug, required double progress}) {
    _progressMap[articleSlug] = progress;
  }

  double getProgress({required MediaItemArticle article}) {
    if (_progressMap[article.slug] == null) return article.progress.audioProgress / 100;

    return _progressMap[article.slug]!;
  }
}
