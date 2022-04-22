import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class TopicsGql {
  static DocumentNode getTopicsFromExpert(String expertId) => gql(
        '''
    query {
      getTopicsFromExpert(expertId: "$expertId") {
        ${CommonGQLModels.topicPreview}
      }
    }
  ''',
      );

  static DocumentNode getTopicsFromEditor(String editorId) => gql(
        '''
    query {
      getTopicsFromEditor(editorId: "$editorId") {
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
