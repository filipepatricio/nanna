import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/update_article_progress_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleReadingProgressUseCase {
  const TrackArticleReadingProgressUseCase(
    this._articleRepository,
    this._updateArticleProgressUseCase,
  );

  final ArticleRepository _articleRepository;
  final UpdateArticleProgressStateNotifierUseCase _updateArticleProgressUseCase;

  Future<UpdateArticleProgressResponse> call(MediaItemArticle article, int progress) async {
    final updatedProgress = await _articleRepository.trackReadingProgress(article.slug, progress);

    final updatedArticle = article.copyWith(
      progress: updatedProgress.progress,
      progressState: updatedProgress.progressState,
    );
    _updateArticleProgressUseCase(updatedArticle);

    return updatedProgress;
  }
}
