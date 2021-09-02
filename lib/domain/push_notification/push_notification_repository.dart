import 'package:better_informed_mobile/domain/push_notification/data/push_notification_message.dart';

abstract class PushNotificationRepository {
  Future<void> registerToken();

  Future<void> initialize();

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Stream<PushNotificationMessage> pushNotificationOpenStream();
}
