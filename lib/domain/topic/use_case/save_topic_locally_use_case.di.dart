import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/image_precache/image_precache_broadcaster.di.dart';
import 'package:better_informed_mobile/domain/util/image_precache/image_precache_data.dt.dart';
import 'package:better_informed_mobile/presentation/util/article_type_extension.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveTopicLocallyUseCase {
  SaveTopicLocallyUseCase(
    this._topicsLocalRepository,
    this._getTopicBySlugUseCase,
    this._saveArticleLocallyUseCase,
    this._saveSynchronizableItemUseCase,
    this._imagePrecacheBroadcaster,
  );

  final TopicsLocalRepository _topicsLocalRepository;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;
  final ImagePrecacheBroadcaster _imagePrecacheBroadcaster;

  Future<void> saveUnsynchronized(String slug, Duration timeToExpire) async {
    final synchronizable = Synchronizable.createNotSynchronized<Topic>(slug, timeToExpire);
    await _saveSynchronizableItemUseCase(_topicsLocalRepository, synchronizable);
  }

  Future<void> fetchAndSave(String slug, Duration timeToExpire) async {
    final synchronizable = Synchronizable.createNotSynchronized<Topic>(slug, timeToExpire);
    await _saveSynchronizableItemUseCase(_topicsLocalRepository, synchronizable);

    final topic = await _getTopicBySlugUseCase(slug);

    await save(topic, timeToExpire);
  }

  Future<void> save(Topic topic, Duration timeToExpire) async {
    final synchronizable = Synchronizable.createSynchronized(topic, topic.slug, timeToExpire);

    _imagePrecacheBroadcaster.broadcast(ImagePrecacheData.topic(topic));

    await _prefetchAllArticles(topic, timeToExpire);
    await _saveSynchronizableItemUseCase(_topicsLocalRepository, synchronizable);
  }

  Future<void> _prefetchAllArticles(Topic topic, Duration timeToExpire) async {
    final slugs = topic.entries
        .map((entry) => entry.item)
        .whereType<MediaItemArticle>()
        .where((element) => element.type.isPremium)
        .map((item) => item.slug)
        .toList(growable: false);

    await _saveArticleLocallyUseCase.fetchListAndSave(slugs, timeToExpire);
  }
}
