import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:injectable/injectable.dart';

const _finishedRatio = 0.9;

@lazySingleton
class AudioProgressTracker {
  AudioProgressTracker(
    this._analyticsRepository,
  );

  final AnalyticsRepository _analyticsRepository;

  String? _lastFinishedArticleId;

  void track(
    String articleId,
    Duration progress,
    Duration totalDuration,
  ) {
    final ratio = progress.inMilliseconds / totalDuration.inMilliseconds;

    if (ratio > _finishedRatio && _lastFinishedArticleId != articleId) {
      _lastFinishedArticleId = articleId;
      _analyticsRepository.event(
        AnalyticsEvent.listenedToArticleAudio(articleId),
      );
    } else if (ratio < _finishedRatio && _lastFinishedArticleId == articleId) {
      _lastFinishedArticleId = null;
    }
  }
}
