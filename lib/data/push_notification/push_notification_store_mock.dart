import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationStore, env: mockEnvs)
class PushNotificationStoreMock implements PushNotificationStore {
  PushNotificationStoreMock();

  @override
  Future<void> save(RegisteredPushToken registeredPushToken) async {}

  @override
  Future<RegisteredPushToken?> load() async {}

  @override
  Future<void> clear() async {}
}
