import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class AudioFileGQL {
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
