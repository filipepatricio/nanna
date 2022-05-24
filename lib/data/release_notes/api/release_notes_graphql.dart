import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class ReleaseNotesGraphql {
  const ReleaseNotesGraphql._();

  static DocumentNode getReleaseNotes(String version) => gql(
        '''
        query {
          releaseNote(filter: {version: {eq:"$version"}}) {
            headline
            date
            content
            media {
              format
              url
              video {
                mp4Url
              }
            }
            version
          }
        }
        ''',
      );
}
