import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGQL {
  static DocumentNode fullArticle(String slug) => gql(
        '''
    query {
      article(slug: "$slug") {
        ${CommonGQLModels.fullArticle}
      }
    }
  ''',
      );

  static DocumentNode articleHeader(String slug) => gql(
        '''
    query {
      article(slug: "$slug") {
        ${CommonGQLModels.article}
      }
    }
  ''',
      );

  static DocumentNode articleContent(String slug) => gql(
        '''
    query {
      article(slug: "$slug") {
        text {
          content
          markupLanguage
        }
      }
    }
  ''',
      );

  static DocumentNode articleAudioFile(String slug) => gql(
        '''
    query {
      getArticleAudioFile(slug: "$slug") {
        url
      }
    }
  ''',
      );
}
