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
          coverImage {
            publicId
          }
          heroImage {
            publicId
          }
          readingList {
            id
            articles {
              slug
              author
              title
              type
              publicationDate
              timeToRead
              image {
                publicId
              }
              publisher {
                name
                lightLogo {
                  publicId
                }
                darkLogo {
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