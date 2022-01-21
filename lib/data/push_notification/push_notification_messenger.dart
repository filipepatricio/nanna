import 'package:better_informed_mobile/data/analytics/incoming_push_analytics_service.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_dto.dart';
import 'package:better_informed_mobile/data/push_notification/incoming_push/mapper/push_notification_message_dto_mapper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PushNotificationMessenger {
  final FirebaseMessaging _firebaseMessaging;
  final RemoteMessageToIncomingPushDTOMapper _remoteMessageToIncomingPushDTOMapper;
  final IncomingPushAnalyticsService _analyticsService;

  PushNotificationMessenger(
    this._firebaseMessaging,
    this._remoteMessageToIncomingPushDTOMapper,
    this._analyticsService,
  );

  Stream<IncomingPushDTO> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp.map<IncomingPushDTO>(_remoteMessageToIncomingPushDTOMapper).map(_track);
  }

  Stream<IncomingPushDTO> onMessage() {
    return FirebaseMessaging.onMessage.map(_remoteMessageToIncomingPushDTOMapper);
  }

  Future<IncomingPushDTO?> initialMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage == null) return null;

    final push = _remoteMessageToIncomingPushDTOMapper(initialMessage);
    return _track(push);
  }

  IncomingPushDTO _track(IncomingPushDTO push) {
    _analyticsService.trackPressedPushNotification(push);
    return push;
  }
}
