import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dart';

abstract class PushNotificationApiDataSource {
  Future<RegisteredPushTokenDTO> registerToken(String token);
}