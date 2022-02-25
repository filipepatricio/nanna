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
    final data = jsonDecode(MockGraphqlResponses.topicsFromExpert) as Map<String, dynamic>;
    return TopicsFromExpertDTO.fromJson(data);
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    final jsonDto = jsonDecode(MockGraphqlResponses.getTopic) as Map<String, dynamic>;
    return TopicDTO.fromJson(jsonDto['topic'] as Map<String, dynamic>);
  }

  @override
  Future<String> getTopicId(String slug) async {
    final topicDto = jsonDecode(MockGraphqlResponses.topicId) as Map<String, dynamic>;
    return topicDto['topic']['id'] as String;
  }
}
