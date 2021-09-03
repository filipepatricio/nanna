import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_gql.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationApiDataSource)
class PushNotificationGraphqlApiDataSource implements PushNotificationApiDataSource {
  final GraphQLClient _client;

  PushNotificationGraphqlApiDataSource(this._client);

  @override
  Future<void> registerToken(String token) async {
    final result = await _client.mutate(
      MutationOptions(
        document: PushNotificationGQL.register(token),
      ),
    );

    GraphQLResponseResolver.resolve(result, (raw) => null, rootKey: null);
  }
}
