import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/use_case/save_article_locally_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/use_case/get_topic_by_slug_use_case.di.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

const _daysToExpire = 7;

@injectable
class SaveTopicLocallyUseCase {
  SaveTopicLocallyUseCase(
    this._topicsLocalRepository,
    this._getTopicBySlugUseCase,
    this._saveArticleLocallyUseCase,
  );

  final TopicsLocalRepository _topicsLocalRepository;
  final GetTopicBySlugUseCase _getTopicBySlugUseCase;
  final SaveArticleLocallyUseCase _saveArticleLocallyUseCase;

  Future<void> fetchAndSave(String slug) async {
    final topic = await _getTopicBySlugUseCase(slug);

    await save(topic);
  }

  Future<void> save(Topic topic) async {
    final synchronizable = _getSynchronizable(topic);

    await _prefetchAllArticles(topic);
    await _topicsLocalRepository.saveTopic(synchronizable);
  }

  Future<void> _prefetchAllArticles(Topic topic) async {
    final articles = topic.entries
        .map((entry) => entry.item)
        .whereType<MediaItemArticle>()
        .where((element) => element.type == ArticleType.premium)
        .map((article) => _saveArticleLocallyUseCase.fetchDetailsAndSave(article));

    await Future.wait(articles);
  }

  Synchronizable<Topic> _getSynchronizable(Topic topic) {
    final syncTime = clock.now();

    return Synchronizable(
      data: topic,
      synchronizedAt: syncTime,
      expirationDate: _getExpirationTime(syncTime),
      createdAt: syncTime,
    );
  }

  DateTime _getExpirationTime(DateTime syncTime) {
    return syncTime.add(const Duration(days: _daysToExpire));
  }
}
