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
          summaryCards {
            text
          }
          introduction
          highlightedPublishers {
            name
          }
          category {
            name
          }
          coverImage {
            publicId
          }
          heroImage {
            publicId
          }
          readingList {
            id
            articles { 
              wordCount
              sourceUrl
              slug
              note
              id
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
                id
                darkLogo{
                  publicId
                }
                lightLogo {
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
