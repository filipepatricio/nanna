import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveTopicLocallyUseCase {
  SaveTopicLocallyUseCase(
    this._topicsLocalRepository,
    this._getTopicBySlugUseCase,
    this._saveArticleLocallyUseCase,
    this._saveSynchronizableItemUseCase,
  );

  final TopicsLocalRepository _topicsLocalRepository;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  Future<void> fetchAndSave(String slug, Duration timeToExpire) async {
    final synchronizable = Synchronizable.notSynchronized<Topic>(slug, timeToExpire);
    await _saveSynchronizableItemUseCase(_topicsLocalRepository, synchronizable);

    final topic = await _getTopicBySlugUseCase(slug);

    await save(topic, timeToExpire);
  }

  Future<void> save(Topic topic, Duration timeToExpire) async {
    final synchronizable = Synchronizable.synchronized(topic, topic.slug, timeToExpire);

    await _prefetchAllArticles(topic, timeToExpire);
    await _saveSynchronizableItemUseCase(_topicsLocalRepository, synchronizable);
  }

  Future<void> _prefetchAllArticles(Topic topic, Duration timeToExpire) async {
    final articles = topic.entries
        .map((entry) => entry.item)
        .whereType<MediaItemArticle>()
        .where((element) => element.type == ArticleType.premium)
        .map((article) => _saveArticleLocallyUseCase.fetchDetailsAndSave(article, timeToExpire));

    await Future.wait(articles);
  }
}
