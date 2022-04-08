import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';

abstract class PushNotificationRepository {
  Future<RegisteredPushToken> registerToken();

  Future<String> getCurrentToken();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Stream<IncomingPush> pushNotificationOpenStream();

  Future<NotificationPreferences> getNotificationPreferences();

  Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled);

  void dispose();
}
