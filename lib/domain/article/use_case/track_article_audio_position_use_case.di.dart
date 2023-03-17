import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/article_read_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleAudioPositionUseCase {
  const TrackArticleAudioPositionUseCase(
    this._articleRepository,
    this._articleReadStateNotifier,
  );

  final ArticleRepository _articleRepository;
  final ArticleReadStateNotifier _articleReadStateNotifier;

  Future<UpdateArticleProgressResponse> call(String articleSlug, int position, [int? duration]) async {
    final updatedProgress = await _articleRepository.trackAudioPosition(articleSlug, position, duration);

    final article =
        _articleReadStateNotifier.getArticle(articleSlug) ?? await _articleRepository.getArticleHeader(articleSlug);
    final updatedArticle = article.copyWith(
      progress: updatedProgress.progress,
      progressState: updatedProgress.progressState,
    );
    _articleReadStateNotifier.notify(updatedArticle);

    return updatedProgress;
  }
}
