import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/push_notification/data/push_notification_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@injectable
class PushNotificationMessageDTOMapper implements Mapper<RemoteMessage, PushNotificationMessage> {
  @override
  PushNotificationMessage call(RemoteMessage data) {
    return PushNotificationMessage(); // TODO implement
  }
}
