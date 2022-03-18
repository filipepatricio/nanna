import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthGQL {
  static DocumentNode login() => gql(
        '''
    mutation signIn(\$token: String!, \$provider: String!, \$meta: UserMeta!) {
      signIn(idToken: \$token, provider: \$provider, information: \$meta) {
        $signIn
      }
    }
  ''',
      );

  static DocumentNode loginWithCode() => gql(
        '''
    mutation signIn(\$token: String!, \$provider: String!, \$meta: UserMeta!, \$code: String) {
      signIn(idToken: \$token, provider: \$provider, information: \$meta, inviteCode: \$code) {
        $signIn
      }
    }
  ''',
      );

  static DocumentNode refresh(String token) => gql(
        '''
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
  ''',
      );

  static DocumentNode sendLink(String email) => gql(
        '''
    mutation {
      sendMagicLink(email: "$email")
    }
  ''',
      );

  static const String signIn = '''
      successful
      errorCode
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
  ''';
}
