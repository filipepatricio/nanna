import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/store/entity/registered_push_token_entity.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisteredPushTokenEntityMapper implements BidirectionalMapper<RegisteredPushTokenEntity, RegisteredPushToken> {
  @override
  RegisteredPushTokenEntity from(RegisteredPushToken data) {
    return RegisteredPushTokenEntity(
      token: data.token,
      updatedAt: data.updatedAt.millisecondsSinceEpoch,
    );
  }

  @override
  RegisteredPushToken to(RegisteredPushTokenEntity data) {
    return RegisteredPushToken(
      token: data.token,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data.updatedAt),
    );
  }
}
