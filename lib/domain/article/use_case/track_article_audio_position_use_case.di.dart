import 'package:better_informed_mobile/data/util/audio_progress.dart';
import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleAudioPositionUseCase {
  const TrackArticleAudioPositionUseCase(
    this._articleRepository,
    this._audioProgress,
  );

  final ArticleRepository _articleRepository;
  final AudioProgress _audioProgress;

  void call(String articleSlug, int position, [int? duration]) {
    _articleRepository.trackAudioPosition(articleSlug, position);
    _audioProgress.setProgress(articleSlug: articleSlug, progress: position / (duration ?? 1));
  }
}
