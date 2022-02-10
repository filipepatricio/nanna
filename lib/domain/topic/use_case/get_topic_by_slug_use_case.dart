import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topic_id_broadcaster.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicBySlugUseCase {
  GetTopicBySlugUseCase(
    this._topicsRepository,
    this._topicIdBroadcaster,
  );

  final TopicsRepository _topicsRepository;
  final TopicIdBroadcaster _topicIdBroadcaster;

  Future<Topic> call(String slug, [bool broadcastId = false]) {
    final topicFuture = _topicsRepository.getTopicBySlug(slug);

    if (broadcastId) {
      _topicIdBroadcaster.addFutureId(
        slug,
        topicFuture.then((value) => value.id),
      );
    }

    return topicFuture;
  }
}
