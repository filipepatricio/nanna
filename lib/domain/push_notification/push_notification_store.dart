import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';

abstract class PushNotificationStore {
  Future<void> save(RegisteredPushToken registeredPushToken);

  Future<RegisteredPushToken?> load();

  Future<void> clear();
}
