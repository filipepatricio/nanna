import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';

abstract class TopicsRepository {
  Future<List<TopicPreview>> getTopicPreviewsFromExpert(String expertId);

  Future<List<TopicPreview>> getTopicPreviewsFromEditor(String editorId);

  Future<Topic> getTopicBySlug(String slug);

  Future<String> tradeTopicIdForSlug(String slug);
}
