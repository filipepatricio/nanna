import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchGQL {
  static DocumentNode search(String query, int limit, int offset) => gql(
        '''
        query {
          search(query: "$query", pagination: { limit: $limit, offset: $offset }) {
              __typename
              ... on Topic {
                ${CommonGQLModels.topicPreview}
              }
              ... on Article {
                 ${CommonGQLModels.article}
              }
            }
        }
    ''',
      );
}
