import 'package:better_informed_mobile/domain/topic/topic_id_broadcaster.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TradeTopicIdForSlugUseCase {
  TradeTopicIdForSlugUseCase(
    this._topicsRepository,
    this._topicIdBroadcaster,
  );

  final TopicsRepository _topicsRepository;
  final TopicIdBroadcaster _topicIdBroadcaster;

  Future<String> call(String slug) async {
    try {
      final topicId = await _topicIdBroadcaster.getId(slug);
      if (topicId != null) return topicId;
    } catch (_) {
      return _topicsRepository.tradeTopicIdForSlug(slug);
    }

    return _topicsRepository.tradeTopicIdForSlug(slug);
  }
}
