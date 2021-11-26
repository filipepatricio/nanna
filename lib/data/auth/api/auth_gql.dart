import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthGQL {
  static DocumentNode login() => gql('''
    mutation signIn(\$token: String!, \$provider: String!, \$meta: UserMeta!) {
      signIn(idToken: \$token, provider: \$provider, information: \$meta) {
        successful
        errorMessage
        tokens {
          accessToken
          refreshToken
        }
        account {
          uuid
          firstName
          lastName
          email
        }
      }
    }
  ''');

  static DocumentNode refresh(String token) => gql('''
    mutation {
      refresh(refreshToken: "$token") {
        successful
        errorMessage
        tokens {
          accessToken
          refreshToken
        }
      }
    }
  ''');

  static DocumentNode sendLink(String email) => gql('''
    mutation {
      sendMagicLink(email: "$email")
    }
  ''');
}
