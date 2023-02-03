import 'package:better_informed_mobile/domain/article/article_repository.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/bookmark/bookmark_local_repository.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_data.dt.dart';
import 'package:better_informed_mobile/domain/bookmark/data/bookmark_type_data.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/save_topic_locally_use_case.di.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@visibleForTesting
const bookmarkExpirationTime = Duration(days: 90);

@injectable
class SaveBookmarkedMediaItemUseCase {
  SaveBookmarkedMediaItemUseCase(
    this._articleRepository,
    this._topicsRepository,
    this._bookmarkLocalRepository,
    this._saveArticleLocallyUseCase,
    this._saveTopicLocallyUseCase,
    this._hasActiveSubscriptionUseCase,
    this._saveSynchronizableItemUseCase,
  );

  final ArticleRepository _articleRepository;
  final TopicsRepository _topicsRepository;
  final BookmarkLocalRepository _bookmarkLocalRepository;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;
  final SaveTopicLocallyUseCase _saveTopicLocallyUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  Future<void> usingBookmarkType(BookmarkTypeData data, String bookmarkId) async {
    if (await _hasActiveSubscriptionUseCase()) {
      await data.map(
        article: (bookmark) async {
          final article = await _articleRepository.getArticleHeader(bookmark.slug);

          await _saveSynchronizableItemUseCase(
            _bookmarkLocalRepository,
            Synchronizable.createSynchronized(
              Bookmark(
                bookmarkId,
                BookmarkData.article(
                  article,
                ),
              ),
              bookmarkId,
              bookmarkExpirationTime,
            ),
          );

          await _saveArticleLocallyUseCase.fetchDetailsAndSave(article, bookmarkExpirationTime);
        },
        topic: (bookmark) async {
          final topic = await _topicsRepository.getTopicBySlug(bookmark.slug);

          await _saveSynchronizableItemUseCase(
            _bookmarkLocalRepository,
            Synchronizable.createSynchronized(
              Bookmark(
                bookmarkId,
                BookmarkData.topic(
                  topic,
                ),
              ),
              bookmarkId,
              bookmarkExpirationTime,
            ),
          );

          await _saveTopicLocallyUseCase.save(topic, bookmarkExpirationTime);
        },
      );
    }
  }

  Future<void> usingBookmarkData(BookmarkData data, String bookmarkId) async {
    if (await _hasActiveSubscriptionUseCase()) {
      await _saveSynchronizableItemUseCase(
        _bookmarkLocalRepository,
        Synchronizable.createSynchronized(
          Bookmark(
            bookmarkId,
            data,
          ),
          bookmarkId,
          bookmarkExpirationTime,
        ),
      );

      await data.map(
        article: (bookmark) => _saveArticleLocallyUseCase.fetchDetailsAndSave(bookmark.article, bookmarkExpirationTime),
        topic: (bookmark) => _saveTopicLocallyUseCase.save(bookmark.topic, bookmarkExpirationTime),
        unknown: (_) async {},
      );
    }
  }
}
