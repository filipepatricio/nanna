import 'dart:convert';

import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_graphql_responses.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsApiDataSource, env: mockEnvs)
class TopicsMockDataSource implements TopicsApiDataSource {
  @override
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId) async {
    const result = MockGraphqlResponses.topicsFromExpert;
    final data = jsonDecode(result) as Map<String, dynamic>;
    final dto = TopicsFromExpertDTO.fromJson(data['getTopicsFromExpert'] as Map<String, dynamic>);

    return dto;
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    return TopicDTO.fromJson(jsonDecode(MockGraphqlResponses.topic) as Map<String, dynamic>);
  }

  @override
  Future<String> getTopicId(String slug) async {
    final topicDto = jsonDecode(MockGraphqlResponses.topicId) as Map<String, dynamic>;
    return topicDto['id'] as String;
  }
}
