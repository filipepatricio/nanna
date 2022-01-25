import 'package:better_informed_mobile/data/gql/common_gql.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGQL {
  static DocumentNode fullArticle(String slug) => gql('''
    query {
      article(slug: "$slug") {
        ${CommonGQLModels.fullArticle}
      }
    }
  ''');

  static DocumentNode articleContent(String slug) => gql('''
    query {
      article(slug: "$slug") {
        text {
          content
          markupLanguage
        }
      }
    }
  ''');
}
