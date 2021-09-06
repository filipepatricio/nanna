import 'package:better_informed_mobile/data/push_notification/store/entity/registered_push_token_entity.dart';

abstract class PushNotificationDatabase {
  Future<void> save(RegisteredPushTokenEntity entity);

  Future<RegisteredPushTokenEntity?> load();

  Future<void> clear();
}
