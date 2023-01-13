import 'package:better_informed_mobile/data/push_notification/api/documents/__generated__/get_notification_preferences.ast.gql.dart'
    as get_notification_preferences;
import 'package:better_informed_mobile/data/push_notification/api/documents/__generated__/register_push_device.ast.gql.dart'
    as register_push_device;
import 'package:better_informed_mobile/data/push_notification/api/documents/__generated__/set_notification_preferences.ast.gql.dart'
    as set_notification_preferences;
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationApiDataSource, env: defaultEnvs)
class PushNotificationGraphqlDataSource implements PushNotificationApiDataSource {
  PushNotificationGraphqlDataSource(this._client, this._responseResolver);
  final GraphQLClient _client;
  final GraphQLResponseResolver _responseResolver;

  @override
  Future<RegisteredPushTokenDTO> registerToken(String token) async {
    final result = await _client.mutate(
      MutationOptions(
        document: register_push_device.document,
        operationName: register_push_device.registerPushDeviceMobile.name?.value,
        variables: {
          'token': token,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => RegisteredPushTokenDTO.fromJson(raw),
      rootKey: 'savePushDeviceToken',
    );

    return dto ?? (throw Exception('Registered token data can not be null'));
  }

  @override
  Future<NotificationPreferencesDTO> getNotificationPreferences() async {
    final result = await _client.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: get_notification_preferences.document,
        operationName: get_notification_preferences.getNotificationPreferencesMobile.name?.value,
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) {
        final groupsRaw = raw['getNotificationPreferences'] as List<dynamic>;
        final groups = groupsRaw
            .map((json) => NotificationPreferencesGroupDTO.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);
        return NotificationPreferencesDTO(groups);
      },
    );

    return dto ?? (throw Exception('Getting notification preferences resolved with null'));
  }

  @override
  Future<NotificationChannelDTO> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {
    final result = await _client.mutate(
      MutationOptions(
        document: set_notification_preferences.document,
        operationName: set_notification_preferences.setNotificationPreferences.name?.value,
        variables: {
          'id': id,
          'pushEnabled': pushEnabled,
          'emailEnabled': emailEnabled,
        },
      ),
    );

    final dto = _responseResolver.resolve(
      result,
      (raw) => NotificationChannelDTO.fromJson(raw),
      rootKey: 'setNotificationChannelPreferences',
    );

    return dto ?? (throw Exception('Setting notification preferences resolved with null'));
  }
}
