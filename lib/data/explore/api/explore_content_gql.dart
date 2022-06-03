import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ExploreContentGQL {
  static DocumentNode highlightedContent() => gql(
        '''
      query getExploreSection {
        pillSection: getExploreSection(isHighlighted: false) {
          __typename
          id
          name
          icon
        }

        highlightedSection: getExploreSection(isHighlighted: true) {
          ${CommonGQLModels.exploreSection}
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

        ... on ArticlesListExploreArea {
          articles(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.article}
          }
        }

        ... on TopicsExploreArea {
          topics(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.topicPreview}
          }
        }

        ... on SmallTopicsExploreArea {
          topics(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.topicPreview}
          }
        }

        ... on HighlightedTopicsExploreArea {
          topics(pagination: {limit: $limit, offset: $offset}) {
            ${CommonGQLModels.topicPreview}
            entryCount
          }
        }
      }
    }
  ''',
      );
}
