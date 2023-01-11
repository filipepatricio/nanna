import 'package:better_informed_mobile/data/push_notification/push_notification_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationRepository, env: integrationTestEnvs)
class PushNotificationRepositoryIntegrationMock extends PushNotificationRepositoryImpl {
  PushNotificationRepositoryIntegrationMock(
    super.firebaseMessaging,
    super.pushNotificationApiDataSource,
    super.incomingPushDTOMapper,
    super.pushNotificationMessenger,
    super.registeredPushTokenDTOMapper,
    super.notificationPreferencesDTOMapper,
    super.notificationChannelDTOMapper,
    super.firebaseExceptionMapper,
  );

  @override
  Future<bool> hasPermission() async {
    return true;
  }

  @override
  Future<bool> requestPermission() async {
    return true;
  }
}
