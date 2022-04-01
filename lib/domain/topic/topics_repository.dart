import 'package:better_informed_mobile/domain/topic/data/topic.dart';

abstract class TopicsRepository {
  Future<List<Topic>> getTopicsFromExpert(String expertId);

  Future<List<Topic>> getTopicsFromEditor(String editorId);

  Future<Topic> getTopicBySlug(String slug);

  Future<String> tradeTopicIdForSlug(String slug);
}
