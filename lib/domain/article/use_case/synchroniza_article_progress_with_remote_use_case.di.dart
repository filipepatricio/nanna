import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:better_informed_mobile/domain/article/use_case/update_article_progress_state_notifier_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/use_case/get_bookmark_state_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizaArticleProgressWithRemoteUseCase implements SynchronizeWithRemoteUsecase<ArticleProgress> {
  SynchronizaArticleProgressWithRemoteUseCase(
    this._articleRepository,
    this._updateArticleProgressStateNotifierUseCase,
    this._getBookmarkStateUseCase,
    this._bookmarkLocalRepository,
  );

  final ArticleRepository _articleRepository;
  final UpdateArticleProgressStateNotifierUseCase _updateArticleProgressStateNotifierUseCase;
  final GetBookmarkStateUseCase _getBookmarkStateUseCase;
  final BookmarkLocalRepository _bookmarkLocalRepository;

  @override
  Future<Synchronizable<ArticleProgress>> call(Synchronizable<ArticleProgress> synchronizable) async {
    final progress = synchronizable.data;
    if (progress == null) throw Exception('Progress is null');

    final updatedProgress = await _articleRepository.trackReadingProgress(
      synchronizable.dataId,
      progress.contentProgress,
    );
    await _notifyAboutProgressUpdate(synchronizable.dataId, updatedProgress);

    final updatedSynchronizable = Synchronizable.synchronized(
      data: progress,
      dataId: synchronizable.dataId,
      createdAt: synchronizable.createdAt,
      synchronizedAt: clock.now(),
      expirationDate: synchronizable.createdAt,
    );

    return updatedSynchronizable;
  }

  Future<void> _notifyAboutProgressUpdate(
    String articleSlug,
    UpdateArticleProgressResponse response,
  ) async {
    final article = await _articleRepository.getArticleHeader(articleSlug);
    final updatedArticle = article.copyWith(progress: response.progress, progressState: response.progressState);

    _updateArticleProgressStateNotifierUseCase(updatedArticle);

    await _resyncLocalBookmarkState(article);
  }

  Future<void> _resyncLocalBookmarkState(MediaItemArticle article) async {
    final bookmarkData = BookmarkTypeData.article(article.slug, article.id, article.type);
    final bookmarkState = await _getBookmarkStateUseCase(bookmarkData);

    await bookmarkState.map(
      bookmarked: (bookmark) async {
        final localBookmark = await _bookmarkLocalRepository.load(bookmark.id);
        if (localBookmark != null) {
          final refreshedSynchronizable = localBookmark.map(
            synchronized: (synchronized) => synchronized.copyWith(
              data: Bookmark(
                bookmark.id,
                BookmarkData.article(article),
              ),
            ),
            notSynchronized: (notSynchronized) => notSynchronized.copyWith(
              data: Bookmark(
                bookmark.id,
                BookmarkData.article(article),
              ),
            ),
          );
          await _bookmarkLocalRepository.save(refreshedSynchronizable);
        }
      },
      notBookmarked: (_) async {},
    );
  }
}
