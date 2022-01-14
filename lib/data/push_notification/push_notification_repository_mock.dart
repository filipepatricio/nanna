import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationRepository, env: mockEnvs)
class PushNotificationRepositoryMock implements PushNotificationRepository {
  final pushToken = 'pushToken';

  @override
  Future<RegisteredPushToken> registerToken() async {
    return RegisteredPushToken(token: pushToken, updatedAt: clock.now());
  }

  @override
  Future<String> getCurrentToken() async {
    return pushToken;
  }

  @override
  Future<bool> hasPermission() async {
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    return true;
  }

  @override
  Stream<IncomingPush> pushNotificationOpenStream() {
    return const Stream.empty();
  }

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    return NotificationPreferences(groups: []);
  }

  @override
  Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {
    return NotificationChannel(
      id: id,
      name: 'channel',
      pushEnabled: pushEnabled ?? true,
      emailEnabled: emailEnabled ?? true,
    );
  }
}
