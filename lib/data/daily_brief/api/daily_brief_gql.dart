import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class DailyBriefGql {
  static DocumentNode currentBrief() => gql('''
    query currentBriefForStartupScreen {
      currentBrief {
        $_greeting
        $_goodbye
        numberOfTopics
        topics {
          id
          title
          lastUpdatedAt
          summaryCards{
            text
          }
          introduction
          ${CommonGQLModels.highlightedPublishers}
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
             item {
                __typename
                ... on Article {
                  ${CommonGQLModels.article}
                }
             }
          }
        }
      }
    }
  }
  ''');

  static const String _greeting = '''
    greeting {
      headline
      message
      icon
    }
  ''';

  static const String _goodbye = '''
    goodbye {
      headline
      message
      icon
    }
  ''';
}
