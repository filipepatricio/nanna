import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/daily_brief_local_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/use_case/save_topic_locally_use_case.di.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@visibleForTesting
const expirationTime = Duration(days: 7);

@injectable
class SaveBriefLocallyUseCase {
  SaveBriefLocallyUseCase(
    this._dailyBriefLocalRepository,
    this._saveArticleLocallyUseCase,
    this._saveTopicLocallyUseCase,
    this._saveSynchronizableItemUseCase,
    this._hasActiveSubscriptionUseCase,
  );

  final DailyBriefLocalRepository _dailyBriefLocalRepository;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;
  final SaveTopicLocallyUseCase _saveTopicLocallyUseCase;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;

  Future<void> call(Brief brief) async {
    final briefSynchronizable = Synchronizable.createSynchronized(
      brief,
      brief.date.toIso8601String(),
      expirationTime,
    );

    await _saveSynchronizableItemUseCase(_dailyBriefLocalRepository, briefSynchronizable);
    await _prepareElementsToSync(brief);

    if (await _hasActiveSubscriptionUseCase()) {
      await _syncAllEntries(brief);
    }
  }

  Future<void> _prepareElementsToSync(Brief brief) async {
    for (final entry in brief.allEntries) {
      await entry.item.map(
        article: (item) {
          final article = item.article as MediaItemArticle;
          if (article.type == ArticleType.premium) {
            return _saveArticleLocallyUseCase.saveUnsynchronized(
              article.slug,
              expirationTime,
            );
          }
        },
        topicPreview: (item) {
          return _saveTopicLocallyUseCase.saveUnsynchronized(item.topicPreview.slug, expirationTime);
        },
        unknown: (_) async {},
      );
    }
  }

  Future<void> _syncAllEntries(Brief brief) async {
    for (final entry in brief.allEntries) {
      await entry.item.map(
        article: (item) {
          final article = item.article as MediaItemArticle;
          if (article.type == ArticleType.premium) {
            return _saveArticleLocallyUseCase.fetchDetailsAndSave(
              article,
              expirationTime,
            );
          }
        },
        topicPreview: (item) {
          return _saveTopicLocallyUseCase.fetchAndSave(item.topicPreview.slug, expirationTime);
        },
        unknown: (_) async {},
      );
    }
  }
}
