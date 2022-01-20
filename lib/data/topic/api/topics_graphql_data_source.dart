import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/data/topic/api/topics_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsApiDataSource, env: liveEnvs)
class TopicsGraphqlDataSource implements TopicsApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  TopicsGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId) async {
    final result = await _client.query(
      QueryOptions(
        document: TopicsGql.getTopicsFromExpert(expertId),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => TopicsFromExpertDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Topics from experts are null'));
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: TopicsGql.getTopicBySlug(slug),
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => TopicDTO.fromJson(raw),
      rootKey: 'topic',
    );

    return dto ?? (throw Exception('Topic is null'));
  }
}
