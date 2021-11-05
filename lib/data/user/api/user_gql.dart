import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class UserGQL {
  const UserGQL._();

  static DocumentNode queryUser() => gql('''
    query {
      me {
        id
        email
        firstName
        lastName
      }
    }
  ''');
}
