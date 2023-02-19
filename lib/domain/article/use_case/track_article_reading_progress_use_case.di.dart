import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_read_progress_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/article/use_case/update_article_progress_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackArticleReadingProgressUseCase {
  const TrackArticleReadingProgressUseCase(
    this._articleRepository,
    this._updateArticleProgressUseCase,
    this._saveArticleReadProgressLocallyUseCase,
  );

  final ArticleRepository _articleRepository;
  final UpdateArticleProgressStateNotifierUseCase _updateArticleProgressUseCase;
  final SaveArticleReadProgressLocallyUseCase _saveArticleReadProgressLocallyUseCase;

  Future<UpdateArticleProgressResponse> call(MediaItemArticle article, int progress) async {
    UpdateArticleProgressResponse updatedProgress;

    try {
      updatedProgress = await _articleRepository.trackReadingProgress(article.slug, progress);
    } on NoInternetConnectionException {
      updatedProgress = await _saveArticleReadProgressLocallyUseCase(article.slug, progress);
    }

    final updatedArticle = article.copyWith(
      progress: updatedProgress.progress,
      progressState: updatedProgress.progressState,
    );
    _updateArticleProgressUseCase(updatedArticle);

    return updatedProgress;
  }
}
