import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class BookmarkGraphql {
  static DocumentNode topicId(String slug) => gql(
        '''
          query {
            getTopicBookmark(slug: "$slug") {
              id
            }
          }
        ''',
      );

  static DocumentNode articleId(String slug) => gql(
        '''
          query {
            getTopicBookmark(slug: "$slug") {
              id
            }
          }
        ''',
      );

  static DocumentNode bookmarkTopic(String slug) => gql(
        '''
          mutation {
            bookmarkTopic(slug: "$slug") {
              successful
              errorCode
              errorMessage

              bookmark {
                id
              }
            }
          }
        ''',
      );

  static DocumentNode bookmarkArticle(String slug) => gql(
        '''
          mutation {
            bookmarkArticle(slug: "$slug") {
              successful
              errorCode
              errorMessage

              bookmark {
                id
              }
            }
          }
        ''',
      );

  static DocumentNode removeBookmark(String id) => gql(
        '''
          mutation {
            removeBookmark(id: "$id") {
              successful
              errorCode
              errorMessage

              bookmark {
                id
              }
            }
          }
        ''',
      );

  static DocumentNode getPaginatedBookmarks(int limit, int offset, String filter, String order, String sortBy) => gql(
        '''
          query {
            getBookmarks(pagination: { limit: $limit, offset: $offset }, filter: $filter, order: $order, sortBy: $sortBy) {
              id

              entity {
                __typename

                ... on Article {
                  ${CommonGQLModels.article}
                }

                ... on Topic {
                  ${CommonGQLModels.topic}
                }
              }
            }
          }
        ''',
      );
}
