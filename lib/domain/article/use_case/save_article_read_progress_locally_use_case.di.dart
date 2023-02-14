import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/article_progress_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

@visibleForTesting
const finishedArticleProgressThreshold = 80;

@injectable
class SaveArticleReadProgressLocallyUseCase {
  SaveArticleReadProgressLocallyUseCase(
    this._articleLocalRepository,
    this._articleProgressLocalRepository,
  );

  final ArticleLocalRepository _articleLocalRepository;
  final ArticleProgressLocalRepository _articleProgressLocalRepository;

  Future<UpdateArticleProgressResponse> call(String articleSlug, int progress) async {
    final storedArticle = await _articleLocalRepository.load(articleSlug);
    final storedProgress = await _articleProgressLocalRepository.load(articleSlug);

    ArticleProgress newProgress;

    if (storedProgress == null) {
      newProgress = ArticleProgress(
        contentProgress: progress,
        audioProgress: 0,
        audioPosition: 0,
      );
    } else {
      final currentProgress = storedProgress.data?.contentProgress ?? 0;

      if (currentProgress > progress) {
        return UpdateArticleProgressResponse(
          progress: storedProgress.data!,
          progressState: _getStateForProgress(currentProgress),
        );
      }

      newProgress = ArticleProgress(
        contentProgress: progress,
        audioProgress: storedProgress.data?.audioProgress ?? 0,
        audioPosition: storedProgress.data?.audioPosition ?? 0,
      );
    }

    await _articleProgressLocalRepository.save(
      Synchronizable.createNotSynchronized(
        articleSlug,
        const Duration(days: 90),
        newProgress,
      ),
    );

    await _updateStoredArticle(storedArticle, progress);

    final progressState = _getStateForProgress(progress);

    return UpdateArticleProgressResponse(
      progress: newProgress,
      progressState: progressState,
    );
  }

  Future<void> _updateStoredArticle(
    Synchronizable<Article>? synchronizableArticle,
    int progress,
  ) async {
    if (synchronizableArticle == null) return;

    final article = synchronizableArticle.data;

    if (article == null) return;
    if (article.metadata.progress.contentProgress > progress) return;

    final updatedArticle = article.copyWith(
      metadata: article.metadata.copyWith(
        progress: article.metadata.progress.copyWith(
          contentProgress: progress,
        ),
        progressState: progress >= finishedArticleProgressThreshold
            ? ArticleProgressState.finished
            : ArticleProgressState.inProgress,
      ),
    );

    final updatedSynchronizableArticle = synchronizableArticle.map(
      synchronized: (value) => value.copyWith(data: updatedArticle),
      notSynchronized: (value) => value.copyWith(data: updatedArticle),
    );

    await _articleLocalRepository.save(updatedSynchronizableArticle);
  }

  ArticleProgressState _getStateForProgress(int progress) {
    if (progress >= finishedArticleProgressThreshold) {
      return ArticleProgressState.finished;
    } else if (progress > 0) {
      return ArticleProgressState.inProgress;
    } else {
      return ArticleProgressState.unread;
    }
  }
}
