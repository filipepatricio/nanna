import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_editor_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dt.dart';

abstract class TopicsApiDataSource {
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId, [String? excludedTopicSlug]);

  Future<TopicsFromEditorDTO> getTopicsFromEditor(String editorId, [String? excludedTopicSlug]);

  Future<TopicDTO> getTopicBySlug(String slug);

  Future<String> getTopicId(String slug);

  Future<void> markTopicAsVisited(String slug);
}
