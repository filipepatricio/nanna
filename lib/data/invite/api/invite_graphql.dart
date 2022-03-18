import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class InviteGraphql {
  const InviteGraphql._();

  static DocumentNode getInviteCode() => gql(
        '''
          query {
            getInviteCode {
              id
              code
              useCount
              maxUseCount
            }
          }
        ''',
      );
}
