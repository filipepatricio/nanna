import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: PushNotificationRepository, env: liveEnvs)
class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final FirebaseMessaging _firebaseMessaging;
  final PushNotificationApiDataSource _pushNotificationApiDataSource;
  final IncomingPushDTOMapper _incomingPushDTOMapper;
  final PushNotificationMessenger _pushNotificationMessenger;
  final RegisteredPushTokenDTOMapper _registeredPushTokenDTOMapper;
  final NotificationPreferencesDTOMapper _notificationPreferencesDTOMapper;
  final NotificationChannelDTOMapper _notificationChannelDTOMapper;

  PushNotificationRepositoryImpl(
    this._firebaseMessaging,
    this._pushNotificationApiDataSource,
    this._incomingPushDTOMapper,
    this._pushNotificationMessenger,
    this._registeredPushTokenDTOMapper,
    this._notificationPreferencesDTOMapper,
    this._notificationChannelDTOMapper,
  );

  @override
  Future<RegisteredPushToken> registerToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token == null) throw Exception('Could not register FCM token');

    final dto = await _pushNotificationApiDataSource.registerToken(token);

    return _registeredPushTokenDTOMapper(dto);
  }

  @override
  Future<String> getCurrentToken() async {
    return await _firebaseMessaging.getToken() ?? (throw Exception('Push notification token can not be null'));
  }

  @override
  Future<bool> hasPermission() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return _isAuthorized(settings);
  }

  @override
  Future<bool> requestPermission() async {
    final result = await _firebaseMessaging.requestPermission();
    return _isAuthorized(result);
  }

  @override
  Stream<IncomingPush> pushNotificationOpenStream() {
    return Rx.concat(
      [
        _pushNotificationMessenger.initialMessage().asStream().whereType<IncomingPushDTO>(),
        _pushNotificationMessenger.onMessageOpenedApp(),
      ],
    ).map(_incomingPushDTOMapper);
  }

  bool _isAuthorized(NotificationSettings result) => result.authorizationStatus == AuthorizationStatus.authorized;

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    final dto = await _pushNotificationApiDataSource.getNotificationPreferences();
    return _notificationPreferencesDTOMapper(dto);
  }

  @override
  Future<NotificationChannel> setNotificationChannel(String id, bool? pushEnabled, bool? emailEnabled) async {
    final dto = await _pushNotificationApiDataSource.setNotificationChannel(id, pushEnabled, emailEnabled);
    return _notificationChannelDTOMapper.to(dto);
  }
}
