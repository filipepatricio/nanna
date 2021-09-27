import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ArticleGQL {
  static DocumentNode fullArticle(String slug) => gql('''
    query {
      article(slug: "$slug") {
        slug
        author
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
          lightLogo {
            publicId
          }
          darkLogo {
            publicId
          }
        }
      }
    }
  ''');
}
