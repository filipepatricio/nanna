import 'package:better_informed_mobile/data/push_notification/api/mapper/push_notiication_message_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/registered_push_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/push_notification_api_data_source.dart';
import 'package:better_informed_mobile/data/push_notification/push_notification_messenger.dart';
import 'package:better_informed_mobile/domain/push_notification/data/push_notification_message.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationRepository)
class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final FirebaseMessaging _firebaseMessaging;
  final PushNotificationApiDataSource _pushNotificationApiDataSource;
  final PushNotificationMessageDTOMapper _pushNotificationMessageDTOMapper;
  final PushNotificationMessenger _pushNotificationMessenger;
  final RegisteredPushTokenDTOMapper _registeredPushTokenDTOMapper;

  PushNotificationRepositoryImpl(
    this._firebaseMessaging,
    this._pushNotificationApiDataSource,
    this._pushNotificationMessageDTOMapper,
    this._pushNotificationMessenger,
    this._registeredPushTokenDTOMapper,
  );

  @override
  Future<RegisteredPushToken> registerToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token == null) throw Exception('Could not register FCM token');

    final dto = await _pushNotificationApiDataSource.registerToken(token);

    return _registeredPushTokenDTOMapper(dto);
  }

  @override
  Future<void> initialize() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      _pushNotificationApiDataSource.registerToken(event);
    });
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
  Stream<PushNotificationMessage> pushNotificationOpenStream() {
    return _pushNotificationMessenger.onMessageOpenedApp().map(_pushNotificationMessageDTOMapper);
  }

  bool _isAuthorized(NotificationSettings result) => result.authorizationStatus == AuthorizationStatus.authorized;

  @override
  Future<String> getCurrentToken() async {
    return await _firebaseMessaging.getToken() ?? (throw Exception('Push notification token can not be null'));
  }
}
