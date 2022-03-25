import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationApiDataSource, env: mockEnvs)
class PushNotificationMockDataSource implements PushNotificationApiDataSource {
  PushNotificationMockDataSource();

  @override
  Future<RegisteredPushTokenDTO> registerToken(String token) async {
    return RegisteredPushTokenDTO('', '');
  }

  @override
  Future<NotificationPreferencesDTO> getNotificationPreferences() async {
    return MockDTO.notificationPreferences;
  }

  @override
  Future<NotificationChannelDTO> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {
    return MockDTO.notificationPreferences.groups.first.channels.first;
  }
}
