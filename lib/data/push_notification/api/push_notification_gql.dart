import 'package:gql/src/ast/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

class PushNotificationGQL {
  const PushNotificationGQL._();

  static DocumentNode register(String token) => gql('''
    mutation {
      savePushDeviceToken(token: "$token") {
        token
        updatedAt
      }
    }
  ''');
}
