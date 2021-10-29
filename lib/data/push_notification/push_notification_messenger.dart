import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PushNotificationMessenger {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationMessenger(this._firebaseMessaging);

  Stream<RemoteMessage> onMessageOpenedApp() => FirebaseMessaging.onMessageOpenedApp;

  Stream<RemoteMessage> onMessage() => FirebaseMessaging.onMessage;

  Future<RemoteMessage?> initialMessage() => _firebaseMessaging.getInitialMessage();
}
