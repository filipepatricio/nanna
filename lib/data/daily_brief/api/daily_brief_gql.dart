import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class DailyBriefGql {
  static DocumentNode currentBrief() => gql('''
    query currentBriefForStartupScreen {
      currentBrief {
        $greeting
        $goodbye
        numberOfTopics
        topics {
          id
          title
          lastUpdatedAt
          summaryCards{
            text
          }
          introduction
          $highlightedPublishers
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
            name
            entries {
              note
              style {
                color
                type
              }
              item {
                __typename
                ... on Article {
                  $articleBody
                }
              }
            }
          }
        }
      }
    }
  ''');
}

String greeting = '''
  greeting {
    headline
    message
    icon
  }
''';
String goodbye = '''
  goodbye {
    headline
    message
    icon
  }
''';

String highlightedPublishers = '''
  highlightedPublishers {
    id
    name
    darkLogo{
      publicId
    }
    lightLogo {
      publicId
    }
  }
''';

String articleBody = '''
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
''';
