import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class UserGQL {
  const UserGQL._();

  static DocumentNode queryUser() => gql('''
    query {
      me {
        uuid
        email
        firstName
        lastName
      }
    }
  ''');

  static DocumentNode updateUser() => gql(''' 
    mutation updateUserMeta(\$firstName: String, \$lastName: String) {
      updateUserMeta(information: {firstName: \$firstName, lastName: \$lastName}) {
        uuid
        email
        firstName
        lastName
      }
    }
  ''');
}
