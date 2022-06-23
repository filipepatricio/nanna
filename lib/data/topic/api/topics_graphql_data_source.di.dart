import 'package:better_informed_mobile/data/topic/api/documents/__generated__/get_topic_by_slug.ast.gql.dart'
    as get_topic_by_slug;
import 'package:better_informed_mobile/data/topic/api/documents/__generated__/get_topic_id_by_slug.ast.gql.dart'
    as get_topic_id_by_slug;
import 'package:better_informed_mobile/data/topic/api/documents/__generated__/get_topics_from_editor.ast.gql.dart'
    as get_topics_from_editor;
import 'package:better_informed_mobile/data/topic/api/documents/__generated__/get_topics_from_expert.ast.gql.dart'
    as get_topics_from_expert;
import 'package:better_informed_mobile/data/topic/api/documents/__generated__/mark_topic_as_visited.ast.gql.dart'
    as mark_topic_as_visited;
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_editor_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topics_from_expert_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/topics_api_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TopicsApiDataSource, env: liveEnvs)
class TopicsGraphqlDataSource implements TopicsApiDataSource {
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  TopicsGraphqlDataSource(this._client, this._responseResolver);

  @override
  Future<TopicsFromExpertDTO> getTopicsFromExpert(String expertId, [String? excludedTopicSlug]) async {
    final result = await _client.query(
      QueryOptions(
        document: get_topics_from_expert.document,
        operationName: get_topics_from_expert.getTopicsFromExpert.name?.value,
        variables: {
          'expertId': expertId,
          'excludedTopicSlug': excludedTopicSlug ?? '',
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => TopicsFromExpertDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Topics from experts are null'));
  }

  @override
  Future<TopicsFromEditorDTO> getTopicsFromEditor(String editorId, [String? excludedTopicSlug]) async {
    final result = await _client.query(
      QueryOptions(
        document: get_topics_from_editor.document,
        operationName: get_topics_from_editor.getTopicsFromEditor.name?.value,
        variables: {
          'editorId': editorId,
          'excludedTopicSlug': excludedTopicSlug ?? '',
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => TopicsFromEditorDTO.fromJson(raw),
    );

    return dto ?? (throw Exception('Topics from editor are null'));
  }

  @override
  Future<TopicDTO> getTopicBySlug(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_topic_by_slug.document,
        operationName: get_topic_by_slug.getTopicBySlug.name?.value,
        variables: {
          'slug': slug,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => TopicDTO.fromJson(raw),
      rootKey: 'topic',
    );

    return dto ?? (throw Exception('Topic is null'));
  }

  @override
  Future<String> getTopicId(String slug) async {
    final result = await _client.query(
      QueryOptions(
        document: get_topic_id_by_slug.document,
        operationName: get_topic_id_by_slug.getTopicByIdSlug.name?.value,
        variables: {
          'slug': slug,
        },
      ),
    );

    final id = _responseResolver.resolve(
      result,
      (raw) {
        return raw['id'] as String;
      },
      rootKey: 'topic',
    );

    return id ?? (throw Exception('Topic id is null'));
  }

  @override
  Future<void> markTopicAsVisited(String slug) => _client.mutate(
        MutationOptions(
          document: mark_topic_as_visited.document,
          operationName: mark_topic_as_visited.markTopicAsVisited.name?.value,
          variables: {
            'slug': slug,
          },
        ),
      );
}
