import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/save_topic_locally_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveBookmarkedMediaItemUseCase {
  SaveBookmarkedMediaItemUseCase(
    this._articleRepository,
    this._topicsRepository,
    this._bookmarkLocalRepository,
    this._saveArticleLocallyUseCase,
    this._saveTopicLocallyUseCase,
    this._hasActiveSubscriptionUseCase,
  );

  final ArticleRepository _articleRepository;
  final TopicsRepository _topicsRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;
  final SaveTopicLocallyUseCase _saveTopicLocallyUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;

  Future<void> usingBookmarkType(BookmarkTypeData data, String bookmarkId) async {
    if (await _hasActiveSubscriptionUseCase()) {
      await data.map(
        article: (bookmark) async {
          final article = await _articleRepository.getArticleHeader(bookmark.slug);

          await _bookmarkLocalRepository.saveBookmark(
            Bookmark(
              bookmarkId,
              BookmarkData.article(
                article,
              ),
            ),
          );

          await _saveArticle(article);
        },
        topic: (bookmark) async {
          final topic = await _topicsRepository.getTopicBySlug(bookmark.slug);

          await _bookmarkLocalRepository.saveBookmark(
            Bookmark(
              bookmarkId,
              BookmarkData.topic(
                topic,
              ),
            ),
          );

          await _saveTopicLocallyUseCase.save(topic);
        },
      );
    }
  }

  Future<void> usingBookmarkData(BookmarkData data, String bookmarkId) async {
    if (await _hasActiveSubscriptionUseCase()) {
      await _bookmarkLocalRepository.saveBookmark(
        Bookmark(
          bookmarkId,
          data,
        ),
      );

      await data.map(
        article: (bookmark) => _saveArticle(bookmark.article),
        topic: (bookmark) => _saveTopicLocallyUseCase.save(bookmark.topic),
        unknown: (_) async {},
      );
    }
  }

  Future<void> _saveArticle(MediaItemArticle article) async {
    if (article.type == ArticleType.premium) {
      await _saveArticleLocallyUseCase.fetchDetailsAndSave(article);
    }
  }
}
