import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthTokenDTOMapper implements BidirectionalMapper<AuthToken, AuthTokenDTO> {
  @override
  AuthToken from(AuthTokenDTO data) {
    return AuthToken(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
    );
  }

  @override
  AuthTokenDTO to(AuthToken data) {
    return AuthTokenDTO(
      data.accessToken,
      data.refreshToken,
    );
  }
}
