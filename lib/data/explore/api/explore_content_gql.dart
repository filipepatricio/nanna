import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ExploreContentGQL {
  static DocumentNode content() => gql(
        '''
    query {
      getExploreSection {
        __typename

        id
        name

        ... on ArticlesExploreArea {
          articles {
            ${CommonGQLModels.article}
          }
        }

        ... on ArticlesWithFeatureExploreArea {
          backgroundColor
          articles {
            ${CommonGQLModels.article}
          }
        }

        ... on TopicsExploreArea {
          topics {
            ${CommonGQLModels.topicPreview}
          }
        }
      }
    }
  ''',
      );

  static DocumentNode paginated(String id, int limit, int offset) => gql(
        '''
    query {
      getExploreArea(id: "$id") {
        __typename

        id
        name

        ... on ArticlesExploreArea {
          articles(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.article}
          }
        }

        ... on ArticlesWithFeatureExploreArea {
          backgroundColor
          articles(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.article}
          }
        }

        ... on TopicsExploreArea {
          topics(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.topicPreview}
          }
        }
      }
    }
  ''',
      );
}
