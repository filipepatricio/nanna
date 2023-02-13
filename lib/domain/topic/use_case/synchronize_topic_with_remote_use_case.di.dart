import 'package:better_informed_mobile/domain/article/article_local_repository.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/save_synchronizable_item_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_with_remote_use_case.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SynchronizeTopicWithRemoteUseCase extends SynchronizeWithRemoteUsecase<Topic> {
  SynchronizeTopicWithRemoteUseCase(
    this._topicsRepository,
    this._articleLocalRepository,
    this._saveSynchronizableItemUseCase,
  );

  final TopicsRepository _topicsRepository;
  final ArticleLocalRepository _articleLocalRepository;
  final SaveSynchronizableItemUseCase _saveSynchronizableItemUseCase;

  @override
  Future<Synchronizable<Topic>> call(Synchronizable<Topic> synchronizable) async {
    final topic = await _topicsRepository.getTopicBySlug(synchronizable.dataId);

    final articlesToSave = topic.entries
        .map((entry) => entry.item)
        .whereType<MediaItemArticle>()
        .where((element) => element.type == ArticleType.premium)
        .map(
          (article) => Synchronizable<Article>.notSynchronized(
            data: null,
            dataId: article.slug,
            expirationDate: synchronizable.expirationDate,
            createdAt: synchronizable.createdAt,
          ),
        );

    await Stream.fromIterable(articlesToSave)
        .asyncMap((article) => _saveSynchronizableItemUseCase(_articleLocalRepository, article))
        .drain();

    return synchronizable.synchronize(topic);
  }
}
