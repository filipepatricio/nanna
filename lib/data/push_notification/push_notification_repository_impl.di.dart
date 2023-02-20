import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:better_informed_mobile/data/exception/firebase/firebase_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/incoming_push_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push.dart';
import 'package:better_informed_mobile/domain/push_notification/incoming_push/data/incoming_push_action.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:retry/retry.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: PushNotificationRepository, env: liveEnvs)
class PushNotificationRepositoryImpl implements PushNotificationRepository {
  PushNotificationRepositoryImpl(
    this._firebaseMessaging,
    this._pushNotificationApiDataSource,
    this._incomingPushDTOMapper,
    this._pushNotificationMessenger,
    this._registeredPushTokenDTOMapper,
    this._notificationPreferencesDTOMapper,
    this._notificationChannelDTOMapper,
    this._firebaseExceptionMapper,
  );

  final FirebaseMessaging _firebaseMessaging;
  final PushNotificationApiDataSource _pushNotificationApiDataSource;
  final IncomingPushDTOMapper _incomingPushDTOMapper;
  final PushNotificationMessenger _pushNotificationMessenger;
  final RegisteredPushTokenDTOMapper _registeredPushTokenDTOMapper;
  final NotificationPreferencesDTOMapper _notificationPreferencesDTOMapper;
  final NotificationChannelDTOMapper _notificationChannelDTOMapper;
  final FirebaseExceptionMapper _firebaseExceptionMapper;

  StreamController<IncomingPush>? _incomingPushNotificationStream;
  StreamSubscription? _incomingPushSubscription;

  @override
  Future<RegisteredPushToken> registerToken() async {
    try {
      final token = await retry(() => _firebaseMessaging.getToken(), retryIf: (e) => !kIsTest);
      if (token == null) throw Exception('Could not register FCM token');

      final dto = await _pushNotificationApiDataSource.registerToken(token);

      return _registeredPushTokenDTOMapper(dto);
    } on FirebaseException catch (e) {
      _firebaseExceptionMapper.mapAndThrow(e);
      rethrow;
    }
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
  Future<bool> shouldOpenNotificationsSettings() async {
    final result = await _firebaseMessaging.getNotificationSettings();
    return _shouldOpenSettings(result);
  }

  @override
  Future<void> openNotificationsSettings() async {
    return await AppSettings.openNotificationSettings();
  }

  @override
  Stream<IncomingPush> pushNotificationOpenStream() {
    if (_incomingPushNotificationStream != null) return _incomingPushNotificationStream!.stream;

    _incomingPushNotificationStream = StreamController<IncomingPush>.broadcast();

    final incomingPushStream = Rx.merge(
      [
        _pushNotificationMessenger.initialMessage().asStream().whereType<IncomingPushDTO>(),
        _pushNotificationMessenger.onMessageOpenedApp(),
        _pushNotificationMessenger.onMessage(),
      ],
    ).map<IncomingPush>(_incomingPushDTOMapper).map<IncomingPush>(_logUnknownActions);

    _incomingPushSubscription = incomingPushStream.listen(_incomingPushNotificationStream!.sink.add);

    return _incomingPushNotificationStream!.stream;
  }

  bool _isAuthorized(NotificationSettings result) => result.authorizationStatus == AuthorizationStatus.authorized;

  bool _shouldOpenSettings(NotificationSettings result) =>
      result.authorizationStatus != AuthorizationStatus.authorized &&
      result.authorizationStatus != AuthorizationStatus.notDetermined;

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

  @override
  void dispose() {
    _incomingPushSubscription?.cancel();
    _incomingPushNotificationStream?.close();
    _incomingPushNotificationStream = null;
  }

  IncomingPush _logUnknownActions(IncomingPush push) {
    final unknownActions = push.actions.whereType<IncomingPushActionUnknown>();
    if (unknownActions.isNotEmpty) {
      Fimber.w('Unknown action types detected in push notification: $unknownActions');
    }
    return push;
  }
}
