import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsApiDataSource, env: mockEnvs)
class TopicsMockDataSource implements TopicsApiDataSource {
  @override
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId) async {
    return TopicsFromExpertDTO([MockDTO.topic, MockDTO.topic]);
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    return MockDTO.topic;
  }

  @override
  Future<String> getTopicId(String slug) async {
    return MockDTO.topic.id;
  }
}
