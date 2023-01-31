import 'package:better_informed_mobile/domain/exception/no_internet_connection_exception.dart';
import 'package:better_informed_mobile/domain/synchronization/synchronizable.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/topic_id_broadcaster.di.dart';
import 'package:better_informed_mobile/domain/topic/topics_local_repository.dart';
import 'package:better_informed_mobile/domain/topic/topics_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTopicBySlugUseCase {
  GetTopicBySlugUseCase(
    this._topicsRepository,
    this._topicIdBroadcaster,
    this._topicLocalRepository,
  );

  final TopicsRepository _topicsRepository;
  final TopicIdBroadcaster _topicIdBroadcaster;
  final TopicsLocalRepository _topicLocalRepository;

  Future<Topic> call(String slug, [bool broadcastId = false]) async {
    try {
      return await _fromRemote(slug, broadcastId);
    } on NoInternetConnectionException {
      final localTopic = await _fromLocal(slug);

      if (localTopic != null) {
        return localTopic;
      }

      rethrow;
    }
  }

  Future<Topic> _fromRemote(String slug, bool broadcastId) {
    final topicFuture = _topicsRepository.getTopicBySlug(slug);

    if (broadcastId) {
      _topicIdBroadcaster.addFutureId(
        slug,
        topicFuture.then((value) => value.id),
      );
    }

    return topicFuture;
  }

  Future<Topic?> _fromLocal(String slug) async {
    final localTopic = await _topicLocalRepository.load(slug);

    if (localTopic != null && localTopic is Synchronized<Topic>) {
      return localTopic.data;
    }

    return null;
  }
}
