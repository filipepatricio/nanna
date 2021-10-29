import 'package:better_informed_mobile/data/auth/store/auth_token_entity.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthTokenEntityToOAuthMapper implements BidirectionalMapper<AuthTokenEntity, OAuth2Token> {
  @override
  AuthTokenEntity from(OAuth2Token data) {
    final refreshToken = data.refreshToken;

    if (refreshToken == null) throw Exception('Refresh token is null');

    return AuthTokenEntity(
      accessToken: data.accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  OAuth2Token to(AuthTokenEntity data) {
    return OAuth2Token(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
    );
  }
}
