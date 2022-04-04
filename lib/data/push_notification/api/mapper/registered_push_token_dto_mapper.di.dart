import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/registered_push_token_dto.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisteredPushTokenDTOMapper implements Mapper<RegisteredPushTokenDTO, RegisteredPushToken> {
  @override
  RegisteredPushToken call(RegisteredPushTokenDTO data) {
    return RegisteredPushToken(
      token: data.token,
      updatedAt: DateTime.parse(data.updatedAt),
    );
  }
}
