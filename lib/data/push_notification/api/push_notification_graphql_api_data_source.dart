import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dart';
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
  Future<RegisteredPushTokenDTO> registerToken(String token) async {
    final result = await _client.mutate(
      MutationOptions(
        document: PushNotificationGQL.register(token),
      ),
    );

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => RegisteredPushTokenDTO.fromJson(raw),
      rootKey: 'savePushDeviceToken',
    );

    return dto ?? (throw Exception('Registered token data can not be null'));
  }
}
