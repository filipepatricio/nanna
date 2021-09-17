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

  static DocumentNode getNotificationPreferences() => gql('''
    query {
      getNotificationPreferences {
        name
        channels {
          id
          name
          pushEnabled
          emailEnabled
        }
      }
    }
  ''');

  static DocumentNode setNotificationPreferences(String id, bool pushEnabled, bool emailEnabled) => gql('''
    mutation {
      setNotificationChannelPreferences(id: "$id", pushEnabled: $pushEnabled, emailEnabled: $emailEnabled) {
        id
        name
        pushEnabled
        emailEnabled
      }
    }
  ''');
}
