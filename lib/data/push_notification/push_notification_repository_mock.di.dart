import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationRepository, env: mockEnvs)
class PushNotificationRepositoryMock implements PushNotificationRepository {
  final PushNotificationApiDataSource _pushNotificationApiDataSource;
  final NotificationPreferencesDTOMapper _notificationPreferencesDTOMapper;
  final NotificationChannelDTOMapper _notificationChannelDTOMapper;

  final pushToken = 'pushToken';

  PushNotificationRepositoryMock(
    this._pushNotificationApiDataSource,
    this._notificationPreferencesDTOMapper,
    this._notificationChannelDTOMapper,
  );

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
    return _notificationPreferencesDTOMapper(await _pushNotificationApiDataSource.getNotificationPreferences());
  }

  @override
  Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {
    return _notificationChannelDTOMapper.to(
      await _pushNotificationApiDataSource.setNotificationChannel(id, pushEnabled, emailEnabled),
    );
  }

  @override
  void dispose() {}
}
