import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class DailyBriefGql {
  static DocumentNode currentBrief() => gql('''
    query currentBriefForStartupScreen {
      currentBrief {
        greeting {
          headline
          message
          icon
        }
        goodbye {
          headline
          message
          icon
        }
        numberOfTopics
        topics {
          id
          title
          introduction
          summary
          image {
            publicId
          }
          category {
            name
          }
          readingList {
            id
            articles {
              slug
              title
              type
              publicationDate
              timeToRead
              image {
                publicId
              }
              publisher {
                name
                logo {
                  publicId
                }
              }
            }
          }
        }
      }
    }
  ''');
}