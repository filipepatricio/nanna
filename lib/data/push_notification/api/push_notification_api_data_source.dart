import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dart';

abstract class PushNotificationApiDataSource {
  Future<RegisteredPushTokenDTO> registerToken(String token);

  Future<NotificationPreferencesDTO> getNotificationPreferences();

  Future<NotificationChannelDTO> setNotificationChannel(String id, bool pushEnabled, bool emailEnabled);
}
