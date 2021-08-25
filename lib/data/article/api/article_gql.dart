import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGQL {
  static DocumentNode fullArticle(String slug) => gql('''
    query {
      article(slug: "$slug") {
        slug
        title
        text {
          content
          markupLanguage
        }
        publicationDate
        type
        timeToRead
        sourceUrl
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
  ''');
}
