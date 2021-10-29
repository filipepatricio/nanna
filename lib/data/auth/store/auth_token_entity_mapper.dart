import 'package:better_informed_mobile/data/auth/store/auth_token_entity.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthTokenEntityMapper implements BidirectionalMapper<AuthToken, AuthTokenEntity> {
  @override
  AuthToken from(AuthTokenEntity data) {
    return AuthToken(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
    );
  }

  @override
  AuthTokenEntity to(AuthToken data) {
    return AuthTokenEntity(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
    );
  }
}
