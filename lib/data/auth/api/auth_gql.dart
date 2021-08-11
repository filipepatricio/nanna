import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthGQL {
  static DocumentNode login(String token, String provider) => gql('''
    mutation {
      signIn(idToken: "$token", provider: "$provider", information: {}) {
        successful
        errorMessage
        tokens {
          accessToken
          refreshToken 
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
