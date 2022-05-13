import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class TopicsGql {
  static DocumentNode getTopicsFromExpert(String expertId, [String? excludedTopicSlug = '']) => gql(
        '''
    query {
      getTopicsFromExpert(expertId: "$expertId", excludeTopicSlugs: ["$excludedTopicSlug"]) {
        ${CommonGQLModels.topicPreview}
      }
    }
  ''',
      );

  static DocumentNode getTopicsFromEditor(String editorId, [String? excludedTopicSlug = '']) => gql(
        '''
    query {
      getTopicsFromEditor(editorId: "$editorId", excludeTopicSlugs: ["$excludedTopicSlug"]) {
        ${CommonGQLModels.topicPreview}
      }
    }
  ''',
      );

  static DocumentNode getTopicBySlug(String slug) => gql(
        '''
    query {
      topic(slug: "$slug") {
        ${CommonGQLModels.topic}
      }
    }
  ''',
      );

  static DocumentNode getTopicIdBySlug(String slug) => gql(
        '''
    query {
      topic(slug: "$slug") {
        id
      }
    }
  ''',
      );
}
