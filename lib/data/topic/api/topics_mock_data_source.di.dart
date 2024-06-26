import 'package:better_informed_mobile/data/common/dto/successful_response_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_editor_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsApiDataSource, env: mockEnvs)
class TopicsMockDataSource implements TopicsApiDataSource {
  @override
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId, [String? excludedTopicSlug]) async {
    return TopicsFromExpertDTO(
      [
        MockDTO.topicPreview,
        MockDTO.topicPreview,
      ],
    );
  }

  @override
  Future<TopicsFromEditorDTO> getTopicsFromEditor(String editorId, [String? excludedTopicSlug]) async {
    return TopicsFromEditorDTO([]);
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    if (slug == MockDTO.topicWithUnknownOwner.slug) {
      return MockDTO.topicWithUnknownOwner;
    }

    if (slug == MockDTO.topicWithEditorOwner.slug) {
      return MockDTO.topicWithEditorOwner;
    }

    return MockDTO.topic;
  }

  @override
  Future<String> getTopicId(String slug) async {
    return MockDTO.topic.id;
  }

  @override
  Future<void> markTopicAsVisited(String slug) async {}

  @override
  Future<SuccessfulResponseDTO> markTopicAsSeen(String slug) async {
    return SuccessfulResponseDTO(true);
  }
}
