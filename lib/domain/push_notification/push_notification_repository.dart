import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/push_notification_message.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';

abstract class PushNotificationRepository {
  Future<RegisteredPushToken> registerToken();

  Future<String> getCurrentToken();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Stream<PushNotificationMessage> pushNotificationOpenStream();

  Future<NotificationPreferences> getNotificationPreferences();

  Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled);
}
