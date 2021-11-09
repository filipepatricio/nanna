import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGQL {
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
