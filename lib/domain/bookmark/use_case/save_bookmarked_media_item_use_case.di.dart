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
import 'package:better_informed_mobile/presentation/util/article_type_extension.dart';
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

          if (article.type.isPremium) {
            await _saveArticleLocallyUseCase.fetchDetailsAndSave(article, bookmarkExpirationTime);
          }
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
        article: (bookmark) async {
          if (bookmark.article.type.isPremium) {
            await _saveArticleLocallyUseCase.fetchDetailsAndSave(bookmark.article, bookmarkExpirationTime);
          }
        },
        topic: (bookmark) => _saveTopicLocallyUseCase.save(bookmark.topic, bookmarkExpirationTime),
        unknown: (_) async {},
      );
    }
  }

  Future<void> usingBookmarkList(List<Bookmark> bookmarkList) async {
    if (await _hasActiveSubscriptionUseCase()) {
      for (final bookmark in bookmarkList) {
        await _saveSynchronizableItemUseCase(
          _bookmarkLocalRepository,
          Synchronizable.createSynchronized(
            bookmark,
            bookmark.id,
            bookmarkExpirationTime,
          ),
        );
      }

      await _saveArticleList(bookmarkList);
      await _saveTopicList(bookmarkList);
    }
  }

  Future<void> _saveArticleList(List<Bookmark> bookmarkList) async {
    final articleSlugs = bookmarkList
        .where((item) => item.data.maybeMap(article: (_) => true, orElse: () => false))
        .map(
          (item) => item.data.maybeMap(
            article: (bookmarkData) => bookmarkData.article,
            orElse: () => throw Exception('Invalid bookmark data'),
          ),
        )
        .where((element) => element.type.isPremium)
        .map((item) => item.slug)
        .toList(growable: false);

    await _saveArticleLocallyUseCase.fetchListAndSave(articleSlugs, bookmarkExpirationTime);
  }

  Future<void> _saveTopicList(List<Bookmark> bookmarkList) async {
    final topicBookmarkList = bookmarkList
        .where((item) => item.data.maybeMap(topic: (_) => true, orElse: () => false))
        .map(
          (item) => item.data.maybeMap(
            topic: (topic) => topic.topic,
            orElse: () => throw Exception('Invalid bookmark data'),
          ),
        )
        .toList(growable: false);

    for (final topic in topicBookmarkList) {
      await _saveTopicLocallyUseCase.save(topic, bookmarkExpirationTime);
    }
  }
}
