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
          lastUpdatedAt
          summary
          introduction
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
    }
  }
  ''');
